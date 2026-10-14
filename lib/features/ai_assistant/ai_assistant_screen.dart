// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyage_jordan2/core/providers/trip_plan_session_provider.dart';
import 'package:voyage_jordan2/core/trip_plan/trip_plan_generator.dart';
import 'package:voyage_jordan2/features/ai_assistant/local_assistant_engine.dart';
import 'package:voyage_jordan2/features/ai_assistant/remote_ai_service.dart';
import 'package:voyage_jordan2/features/ai_assistant/trip_builder_chat_flow.dart';
import 'package:voyage_jordan2/l10n/app_localizations.dart';
import 'package:voyage_jordan2/models/trip_plan_build_result.dart';
import 'package:voyage_jordan2/shared/theme/app_colors.dart';

class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  static const RemoteAiService _remoteAi = RemoteAiService();
  final TextEditingController _input = TextEditingController();
  final FocusNode _inputFocus = FocusNode();
  final ScrollController _scroll = ScrollController();
  final List<_ChatLine> _lines = [];
  TripBuilderChatFlow? _tripBuilder;
  bool _tripPlanComplete = false;
  bool _isSending = false;
  TripPlanBuildResult? _backendSuggestedTrip;
  String? _pressedChoiceId;

  /// In-screen copy only (avoids l10n strings that still describe mock/demo/offline mode).
  static String _neutralAssistantWelcome(bool arabic) => arabic
      ? 'مرحباً. أنا مساعدك في Voyage Jordan للأسئلة عن الوجهات والتخطيط. اكتب سؤالك بالأسفل.'
      : 'Welcome. I am your Voyage Jordan assistant for destinations and trip planning. Type your question below.';

  @override
  void initState() {
    super.initState();
    print('AI_UI_SCREEN_INIT');
    _input.addListener(() => setState(() {}));
    _inputFocus.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_lines.isEmpty) {
        final arabic = Localizations.localeOf(context).languageCode == 'ar';
        setState(() {
          _lines.add(_ChatLine.assistant(_neutralAssistantWelcome(arabic)));
        });
      }
      print('AI_UI_INITIAL_LINES_COUNT ${_lines.length}');
    });
  }

  @override
  void dispose() {
    _input.dispose();
    _inputFocus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  bool get _arabic => Localizations.localeOf(context).languageCode == 'ar';

  bool get _tripBuilderActive => _tripBuilder != null && _tripBuilder!.isActive;

  bool get _tripBuilderChrome => _tripBuilderActive || _tripPlanComplete;
  bool get _showSuggestions => !_tripBuilderActive && !_inputFocus.hasFocus && _input.text.trim().isEmpty;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _flashAndSubmit(String id, String displayLabel, String consumePayload) async {
    setState(() => _pressedChoiceId = id);
    await Future<void>.delayed(const Duration(milliseconds: 140));
    if (!mounted) return;
    setState(() => _pressedChoiceId = null);
    _submitTripBuilderAnswer(displayLabel, consumePayload);
  }

  void _submitTripBuilderAnswer(String displayLabel, String consumePayload) {
    if (_tripBuilder == null) return;
    setState(() {
      _lines.add(_ChatLine.user(displayLabel));
      final flow = _tripBuilder!;
      final reply = flow.consume(consumePayload, _arabic);
      if (reply != null) {
        _lines.add(_ChatLine.assistant(reply));
      }
      if (!flow.isActive) _tripBuilder = null;
    });
    _scrollToBottom();
  }

  void _cancelTripBuilder() {
    setState(() {
      _tripBuilder = null;
      _tripPlanComplete = false;
      _backendSuggestedTrip = null;
      _lines
        ..clear()
        ..add(_ChatLine.assistant(_neutralAssistantWelcome(_arabic)));
    });
    _scrollToBottom();
  }

  void _startTripBuilderOver() {
    if (!_tripBuilderActive) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _lines.add(_ChatLine.user(l10n.aiTripBuilderStartOver));
      final flow = _tripBuilder!;
      _lines.add(_ChatLine.assistant(flow.restartInterview(_arabic)));
      _tripPlanComplete = false;
      _backendSuggestedTrip = null;
    });
    _scrollToBottom();
  }

  void _saveTrip() {
    final flow = _tripBuilder;
    final pending = flow?.pendingBuildResult;
    if (flow == null || pending == null || !flow.awaitingApproval) return;
    final l10n = AppLocalizations.of(context)!;
    ref.read(tripPlanSessionProvider.notifier).setPlan(pending);
    setState(() {
      _lines.add(_ChatLine.user(l10n.aiAssistantSaveTrip));
      _lines.add(_ChatLine.assistant(l10n.tripPlanSavedMessage));
      flow.markSaved();
      _tripBuilder = null;
      _tripPlanComplete = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.tripPlanSavedMessage),
        behavior: SnackBarBehavior.floating,
      ),
    );
    _scrollToBottom();
  }

  void _saveBackendSuggestedTrip() {
    final trip = _backendSuggestedTrip;
    if (trip == null) return;
    final l10n = AppLocalizations.of(context)!;
    ref.read(tripPlanSessionProvider.notifier).setPlan(trip);
    setState(() {
      _lines.add(_ChatLine.user(l10n.aiAssistantSaveTrip));
      _lines.add(_ChatLine.assistant(l10n.tripPlanSavedMessage));
      _backendSuggestedTrip = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.tripPlanSavedMessage),
        behavior: SnackBarBehavior.floating,
      ),
    );
    _scrollToBottom();
  }

  void _modifyTrip() {
    if (_backendSuggestedTrip != null) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _lines.add(_ChatLine.user(l10n.aiAssistantModifyTrip));
        _backendSuggestedTrip = null;
      });
      _send(_arabic
          ? 'عدّل الخطة المقترحة لتكون أكثر مناسبة لي'
          : 'Please modify the suggested trip to fit me better.');
      return;
    }
    final flow = _tripBuilder;
    if (flow == null || !flow.awaitingApproval) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _lines.add(_ChatLine.user(l10n.aiAssistantModifyTrip));
      _lines.add(_ChatLine.assistant(flow.restartInterview(_arabic)));
      _tripPlanComplete = false;
    });
    _scrollToBottom();
  }

  Future<void> _send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    if (_tripBuilderActive || _isSending) return;

    print('AI_UI_SEND_START message=${trimmed.length} chars lang=${_arabic ? 'ar' : 'en'}');

    setState(() {
      _lines.add(_ChatLine.user(trimmed));
      _input.clear();
      _isSending = true;
      _backendSuggestedTrip = null;
    });
    _scrollToBottom();
    try {
      final response = await _remoteAi.chat(
        message: trimmed,
        language: _arabic ? 'ar' : 'en',
        conversationHistory: _recentConversation(10),
        appContext: const {
          'app_name': 'Voyage Jordan',
          'supported_destinations': ['petra', 'wadi-rum', 'aqaba', 'jerash', 'dead-sea'],
        },
      );
      print('AI_UI_REMOTE_SUCCESS');
      final replyText = response.reply.trim();
      print('AI_UI_REMOTE_REPLY ${replyText.isEmpty ? '<empty>' : replyText}');
      if (!mounted) return;
      setState(() {
        if (replyText.isNotEmpty) {
          _lines.add(_ChatLine.assistant(replyText));
          _backendSuggestedTrip = _mapSuggestedTrip(response.suggestedTrip);
        } else {
          _lines.add(
            _ChatLine.assistant(
              _arabic ? 'لم يُرجع الخادم نصاً. أعد المحاولة.' : 'The assistant returned an empty reply. Please try again.',
            ),
          );
        }
      });
      print('AI_UI_FALLBACK_TRIGGERED false');
      print('AI_UI_LOCAL_REPLY_USED false');
      return;
    } catch (e, st) {
      print('AI_UI_REMOTE_FAILURE $e');
      print('AI_UI_FALLBACK_TRIGGERED true');
      print('AI_UI_REMOTE_FAILURE stackTrace=$st');
      final networkFallback = _arabic
          ? 'تعذر الاتصال بخدمة الذكاء الاصطناعي حالياً، لذلك سأحاول المساعدة بوضع محلي.'
          : 'I could not reach the AI service right now. I will share brief offline tips here.';
      if (!mounted) return;
      setState(() {
        _lines.add(_ChatLine.assistant(networkFallback));
        _lines.add(_ChatLine.assistant(LocalAssistantEngine.reply(trimmed, arabic: _arabic)));
      });
      print('AI_UI_LOCAL_REPLY_USED true');
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
      _scrollToBottom();
      print('AI_UI_DONE mounted=$mounted');
    }
  }

  List<Map<String, String>> _recentConversation(int maxItems) {
    final start = _lines.length > maxItems ? _lines.length - maxItems : 0;
    final slice = _lines.sublist(start);
    return slice
        .map((e) => {
              'role': e.isUser ? 'user' : 'assistant',
              'content': e.text,
            })
        .toList();
  }

  TripPlanBuildResult? _mapSuggestedTrip(RemoteAiSuggestedTrip? trip) {
    if (trip == null || trip.destinationIds.isEmpty) return null;
    final valid = trip.destinationIds.where(TripPlanGenerator.jordanFlowOrder.contains).toSet();
    if (valid.isEmpty) return null;
    return TripPlanGenerator.build(
      selectedDestinations: valid,
      tripDays: trip.tripDays.clamp(1, 14),
      budgetTier: trip.budgetTier.clamp(0, 2),
      transportMode: trip.transportMode.clamp(0, 3),
    );
  }

  Widget _tripOptionTile({
    required String id,
    required String label,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    final gold = selected || _pressedChoiceId == id;
    return Material(
      color: gold ? AppColors.primaryGold.withValues(alpha: 0.28) : AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: gold ? AppColors.primaryGold : AppColors.borderGoldLight,
              width: gold ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripBuilderPanel(AppLocalizations l10n) {
    final step = _tripBuilder!.activeUiStep;
    final cancel = TextButton(
      onPressed: _cancelTripBuilder,
      child: Text(l10n.aiTripBuilderCancel, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
    );
    final startOver = OutlinedButton(
      onPressed: _startTripBuilderOver,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.borderGoldLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(l10n.aiTripBuilderStartOver, style: const TextStyle(fontWeight: FontWeight.w700)),
    );

    Widget stepBody;
    switch (step) {
      case TripBuilderActiveStep.days:
        stepBody = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _tripOptionTile(
              id: 'd3',
              label: l10n.aiTbDays3,
              onTap: () => _flashAndSubmit('d3', l10n.aiTbDays3, '3 days'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'd5',
              label: l10n.aiTbDays5,
              onTap: () => _flashAndSubmit('d5', l10n.aiTbDays5, '5 days'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'd7',
              label: l10n.aiTbDays7,
              onTap: () => _flashAndSubmit('d7', l10n.aiTbDays7, '7 days'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'd10',
              label: l10n.aiTbDays10,
              onTap: () => _flashAndSubmit('d10', l10n.aiTbDays10, '10 days'),
            ),
          ],
        );
        break;
      case TripBuilderActiveStep.experience:
        stepBody = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _tripOptionTile(
              id: 'eh',
              label: l10n.aiTbExperienceHistory,
              onTap: () => _flashAndSubmit('eh', l10n.aiTbExperienceHistory, 'history and culture'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'ea',
              label: l10n.aiTbExperienceAdventure,
              onTap: () => _flashAndSubmit('ea', l10n.aiTbExperienceAdventure, 'adventure'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'er',
              label: l10n.aiTbExperienceRelax,
              onTap: () => _flashAndSubmit('er', l10n.aiTbExperienceRelax, 'relaxation'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'ef',
              label: l10n.aiTbExperienceFamily,
              onTap: () => _flashAndSubmit('ef', l10n.aiTbExperienceFamily, 'family-friendly'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'em',
              label: l10n.aiTbExperienceMixed,
              onTap: () => _flashAndSubmit('em', l10n.aiTbExperienceMixed, 'mixed'),
            ),
          ],
        );
        break;
      case TripBuilderActiveStep.budget:
        stepBody = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _tripOptionTile(id: 'be', label: l10n.aiTbBudgetEconomy, onTap: () => _flashAndSubmit('be', l10n.aiTbBudgetEconomy, 'economy')),
            const SizedBox(height: 8),
            _tripOptionTile(id: 'bm', label: l10n.aiTbBudgetModerate, onTap: () => _flashAndSubmit('bm', l10n.aiTbBudgetModerate, 'moderate')),
            const SizedBox(height: 8),
            _tripOptionTile(id: 'bl', label: l10n.aiTbBudgetLuxury, onTap: () => _flashAndSubmit('bl', l10n.aiTbBudgetLuxury, 'luxury')),
          ],
        );
        break;
      case TripBuilderActiveStep.pace:
        stepBody = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _tripOptionTile(
              id: 'pc',
              label: l10n.aiTbPaceCalm,
              onTap: () => _flashAndSubmit('pc', l10n.aiTbPaceCalm, 'calm'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'pa',
              label: l10n.aiTbPaceActive,
              onTap: () => _flashAndSubmit('pa', l10n.aiTbPaceActive, 'active'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'pb',
              label: l10n.aiTbPaceBalanced,
              onTap: () => _flashAndSubmit('pb', l10n.aiTbPaceBalanced, 'balanced'),
            ),
          ],
        );
        break;
      case TripBuilderActiveStep.places:
        stepBody = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _tripOptionTile(
              id: 'lh',
              label: l10n.aiTbPlacesHistorical,
              onTap: () => _flashAndSubmit('lh', l10n.aiTbPlacesHistorical, 'historical places'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'ln',
              label: l10n.aiTbPlacesNature,
              onTap: () => _flashAndSubmit('ln', l10n.aiTbPlacesNature, 'nature'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'ls',
              label: l10n.aiTbPlacesSea,
              onTap: () => _flashAndSubmit('ls', l10n.aiTbPlacesSea, 'sea'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'ld',
              label: l10n.aiTbPlacesDesert,
              onTap: () => _flashAndSubmit('ld', l10n.aiTbPlacesDesert, 'desert'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'lm',
              label: l10n.aiTbPlacesMixed,
              onTap: () => _flashAndSubmit('lm', l10n.aiTbPlacesMixed, 'mixed'),
            ),
          ],
        );
        break;
      case TripBuilderActiveStep.transport:
        stepBody = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _tripOptionTile(
              id: 'tr',
              label: l10n.aiTbTransportRental,
              onTap: () => _flashAndSubmit('tr', l10n.aiTbTransportRental, 'rental car'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'td',
              label: l10n.aiTbTransportDriver,
              onTap: () => _flashAndSubmit('td', l10n.aiTbTransportDriver, 'private driver'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'tg',
              label: l10n.aiTbTransportGuided,
              onTap: () => _flashAndSubmit('tg', l10n.aiTbTransportGuided, 'guided tour'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'tp',
              label: l10n.aiTbTransportPublic,
              onTap: () => _flashAndSubmit('tp', l10n.aiTbTransportPublic, 'public transport'),
            ),
          ],
        );
        break;
      case TripBuilderActiveStep.special:
        stepBody = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _tripOptionTile(
              id: 'sn',
              label: l10n.aiTbSpecialNone,
              onTap: () => _flashAndSubmit('sn', l10n.aiTbSpecialNone, 'none'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'sc',
              label: l10n.aiTbSpecialCrowds,
              onTap: () => _flashAndSubmit('sc', l10n.aiTbSpecialCrowds, 'avoid crowds'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'sh',
              label: l10n.aiTbSpecialHeat,
              onTap: () => _flashAndSubmit('sh', l10n.aiTbSpecialHeat, 'heat sensitive'),
            ),
            const SizedBox(height: 8),
            _tripOptionTile(
              id: 'sw',
              label: l10n.aiTbSpecialWalks,
              onTap: () => _flashAndSubmit('sw', l10n.aiTbSpecialWalks, 'shorter walks'),
            ),
          ],
        );
        break;
      case TripBuilderActiveStep.awaitingApproval:
        stepBody = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton(
              onPressed: _modifyTrip,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.borderGoldLight),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(l10n.aiAssistantModifyTrip, style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _saveTrip,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                foregroundColor: AppColors.onPrimaryGold,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(l10n.aiAssistantSaveTrip, style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        );
        break;
      default:
        stepBody = const SizedBox.shrink();
    }

    return Material(
      color: AppColors.surface,
      elevation: 10,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: cancel),
                  const SizedBox(width: 8),
                  Expanded(child: startOver),
                ],
              ),
              const SizedBox(height: 12),
              stepBody,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.aiAssistant),
      ),
      body: Column(
        children: [
          if (_tripBuilderChrome) _TripBuilderBanner(l10n: l10n, done: false),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              itemCount: _lines.length,
              itemBuilder: (context, index) {
                final line = _lines[index];
                return _ChatBubble(line: line, compact: _tripBuilderChrome);
              },
            ),
          ),
          if (_isSending)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: LinearProgressIndicator(minHeight: 2),
            ),
          if (_tripBuilderActive)
            _buildTripBuilderPanel(l10n)
          else if (_backendSuggestedTrip != null)
            Material(
              color: AppColors.surface,
              elevation: 10,
              shadowColor: Colors.black.withValues(alpha: 0.1),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _modifyTrip,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: AppColors.borderGoldLight),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(l10n.aiAssistantModifyTrip, style: const TextStyle(fontWeight: FontWeight.w800)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: _saveBackendSuggestedTrip,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primaryGold,
                            foregroundColor: AppColors.onPrimaryGold,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(l10n.aiAssistantSaveTrip, style: const TextStyle(fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else ...[
            if (_showSuggestions)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderGoldLight),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _SuggestionChip(
                          label: l10n.aiChipBuildTrip,
                          onSelected: () => _send(l10n.aiChipBuildTrip),
                        ),
                        _SuggestionChip(
                          label: l10n.aiChipPetra,
                          onSelected: () => _send(l10n.aiChipPetra),
                        ),
                        _SuggestionChip(
                          label: l10n.aiChipAdventure,
                          onSelected: () => _send(l10n.aiChipAdventure),
                        ),
                        _SuggestionChip(
                          label: l10n.aiChipPlanTrip,
                          onSelected: () => _send(l10n.aiChipPlanTrip),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Material(
              color: AppColors.surface,
              elevation: 8,
              shadowColor: Colors.black.withValues(alpha: 0.08),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _input,
                          focusNode: _inputFocus,
                          minLines: 1,
                          maxLines: 4,
                          textInputAction: TextInputAction.send,
                          onSubmitted: _send,
                          decoration: InputDecoration(
                            hintText: l10n.aiChatInputHint,
                            filled: true,
                            fillColor: AppColors.surfaceSoft,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(color: AppColors.borderGoldLight),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(color: AppColors.borderGoldLight),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(color: AppColors.primaryGold, width: 1.2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: () => _send(_input.text),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primaryGold,
                          foregroundColor: AppColors.onPrimaryGold,
                          padding: const EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: const Icon(Icons.send_rounded, size: 22),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TripBuilderBanner extends StatelessWidget {
  const _TripBuilderBanner({required this.l10n, required this.done});

  final AppLocalizations l10n;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.accentSoft,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.45)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, size: 20, color: AppColors.primaryGold.withValues(alpha: 0.95)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.aiTripBuilderTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                done ? l10n.aiTripBuilderDoneHint : l10n.aiTripBuilderHint,
                style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatLine {
  _ChatLine._(this.isUser, this.text);
  factory _ChatLine.user(String t) => _ChatLine._(true, t);
  factory _ChatLine.assistant(String t) => _ChatLine._(false, t);

  final bool isUser;
  final String text;
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.line, this.compact = false});

  final _ChatLine line;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final align = line.isUser ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart;
    final bg = line.isUser
        ? AppColors.primaryGold.withValues(alpha: 0.22)
        : AppColors.surface;
    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 8 : 10),
      child: Align(
        alignment: align,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.86),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(line.isUser ? 16 : 4),
                bottomRight: Radius.circular(line.isUser ? 4 : 16),
              ),
              border: line.isUser ? null : Border.all(color: AppColors.borderGoldLight),
              boxShadow: line.isUser
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 14, vertical: compact ? 10 : 12),
              child: Text(
                line.text,
                style: TextStyle(
                  fontSize: compact ? 14.5 : 15,
                  height: 1.38,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onSelected});

  final String label;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      backgroundColor: AppColors.surface,
      side: const BorderSide(color: AppColors.borderGoldLight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: onSelected,
    );
  }
}
