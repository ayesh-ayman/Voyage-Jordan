import 'package:voyage_jordan2/features/ai_assistant/local_assistant_intent.dart';
import 'package:voyage_jordan2/features/ai_assistant/local_assistant_knowledge.dart';
import 'package:voyage_jordan2/features/ai_assistant/local_assistant_retriever.dart';

/// Local deterministic assistant pipeline:
/// user text -> intent layer -> retrieval -> composed response.
class LocalAssistantEngine {
  LocalAssistantEngine._();

  static String reply(String raw, {required bool arabic}) {
    final text = raw.trim();
    if (text.isEmpty) {
      return arabic ? 'اكتب سؤالك وسأساعدك بالتخطيط السياحي داخل التطبيق.' : 'Type your question and I’ll help with Jordan trip planning.';
    }
    final lower = text.toLowerCase();
    final matchedDestinations = _matchDestinations(lower, text);
    final intent = LocalAssistantIntentLayer.detect(
      text: text,
      lower: lower,
      matchedDestinationIds: matchedDestinations,
    );
    return LocalAssistantRetriever.retrieveAndCompose(
      intent: intent,
      arabic: arabic,
      originalText: text,
    );
  }

  static List<String> _matchDestinations(String lower, String original) {
    final out = <String>[];
    for (final entry in LocalAssistantKnowledgeBase.destinations.entries) {
      final aliases = entry.value.aliases;
      if (aliases.any((a) => lower.contains(a.toLowerCase()) || original.contains(a))) {
        out.add(entry.key);
      }
    }
    return out;
  }
}
