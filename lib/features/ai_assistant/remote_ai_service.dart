// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String backendUrl = "http://192.168.1.12:8000";

class RemoteAiSuggestedTrip {
  const RemoteAiSuggestedTrip({
    required this.destinationIds,
    required this.tripDays,
    required this.budgetTier,
    required this.transportMode,
    this.summary,
  });

  final List<String> destinationIds;
  final int tripDays;
  final int budgetTier;
  final int transportMode;
  final String? summary;

  /// Never throws. Malformed backend `suggested_trip` must not fail the chat reply.
  static RemoteAiSuggestedTrip? tryParse(dynamic raw) {
    if (raw == null || raw is! Map) return null;
    try {
      final json = Map<String, dynamic>.from(
        raw.map((Object? k, Object? v) => MapEntry(k.toString(), v)),
      );
      final idsRaw = json['destination_ids'];
      final List<String> destinations;
      if (idsRaw is List) {
        destinations = idsRaw.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
      } else if (idsRaw is String && idsRaw.trim().isNotEmpty) {
        destinations = [idsRaw.trim()];
      } else {
        return null;
      }
      if (destinations.isEmpty) return null;
      int asInt(dynamic v, int fallback) {
        if (v is num) return v.toInt();
        if (v is String) return int.tryParse(v) ?? fallback;
        return fallback;
      }

      return RemoteAiSuggestedTrip(
        destinationIds: destinations,
        tripDays: asInt(json['trip_days'], 5),
        budgetTier: asInt(json['budget_tier'], 1),
        transportMode: asInt(json['transport_mode'], 1),
        summary: json['summary']?.toString(),
      );
    } catch (e, st) {
      print('AI_REMOTE suggested_trip skipped (parse error): $e\n$st');
      return null;
    }
  }

  factory RemoteAiSuggestedTrip.fromJson(Map<String, dynamic> json) {
    final parsed = tryParse(json);
    if (parsed == null) {
      throw FormatException('Invalid suggested_trip');
    }
    return parsed;
  }
}

class RemoteAiChatResponse {
  const RemoteAiChatResponse({
    required this.reply,
    this.intent,
    this.suggestedTrip,
  });

  final String reply;
  final String? intent;
  final RemoteAiSuggestedTrip? suggestedTrip;

  factory RemoteAiChatResponse.fromJson(Map<String, dynamic> json) {
    return RemoteAiChatResponse(
      reply: json['reply']?.toString() ?? '',
      intent: json['intent']?.toString(),
      suggestedTrip: RemoteAiSuggestedTrip.tryParse(json['suggested_trip']),
    );
  }
}

class RemoteAiService {
  const RemoteAiService({
    this.timeout = const Duration(seconds: 15),
  });

  final Duration timeout;

  /// [jsonDecode] returns JSON objects as [Map] with dynamic keys/values — not
  /// [Map<String, dynamic>]. Normalizing avoids false failures on valid 200 bodies.
  static Map<String, dynamic>? _asStringKeyedMap(dynamic decoded) {
    if (decoded is! Map) return null;
    return Map<String, dynamic>.from(
      decoded.map((Object? k, Object? v) => MapEntry(k.toString(), v)),
    );
  }

  Future<RemoteAiChatResponse> chat({
    required String message,
    required String language,
    List<Map<String, String>>? conversationHistory,
    Map<String, dynamic>? appContext,
  }) async {
    Never throwReasoned(Object error, String reason) {
      print('AI_REMOTE_THROW_REASON $reason | error=$error');
      throw error;
    }

    final requestUrl = '$backendUrl/chat';
    final payload = <String, dynamic>{
      'message': message,
      'language': language,
      if (conversationHistory != null && conversationHistory.isNotEmpty)
        'conversation_history': conversationHistory,
      if (appContext != null && appContext.isNotEmpty) 'app_context': appContext,
    };
    final requestBody = jsonEncode(payload);

    try {
      print('AI_REMOTE_REQUEST_URL $requestUrl');
      print('AI_REMOTE_REQUEST_BODY $requestBody');

      final response = await http
          .post(
            Uri.parse(requestUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: requestBody,
          )
          .timeout(timeout);

      final status = response.statusCode;
      final rawBody = response.body;
      print('AI_REMOTE_STATUS_CODE $status');
      print('AI_REMOTE_RAW_BODY $rawBody');

      if (response.statusCode == 500) {
        throwReasoned(Exception('مشكلة في السيرفر'), 'HTTP 500 from backend');
      }
      if (rawBody.trim().isEmpty) {
        throwReasoned(Exception('لم يتم استلام رد من السيرفر'), 'Empty response body');
      }
      if (response.statusCode != 200) {
        throwReasoned(
          Exception('Backend error $status'),
          'Non-200 status (body preserved in AI_REMOTE_RAW_BODY)',
        );
      }

      dynamic decoded;
      try {
        decoded = jsonDecode(rawBody);
      } catch (e, st) {
        throwReasoned(Exception('رد غير صالح من السيرفر'), 'jsonDecode failed: $e\n$st');
      }

      final map = _asStringKeyedMap(decoded);
      if (map == null) {
        throwReasoned(
          Exception('رد غير صالح من السيرفر'),
          'JSON root is not an object (${decoded.runtimeType})',
        );
      }

      // 200 + presence of "reply" key => success. Do not throw on malformed suggested_trip.
      if (!map.containsKey('reply')) {
        throwReasoned(
          Exception('Invalid response structure'),
          '200 JSON missing "reply" key',
        );
      }

      final parsed = RemoteAiChatResponse.fromJson(map);
      print('AI_REMOTE_PARSED_REPLY ${parsed.reply}');
      return parsed;
    } on http.ClientException catch (e, stackTrace) {
      print('AI_REMOTE_THROW_REASON ClientException: $e\n$stackTrace');
      throw Exception('لا يوجد اتصال بالسيرفر');
    } on TimeoutException catch (e, stackTrace) {
      print('AI_REMOTE_THROW_REASON TimeoutException: $e\n$stackTrace');
      throw Exception('الاتصال بطيء، حاول مرة أخرى');
    } catch (e, stackTrace) {
      print('AI_REMOTE_THROW_REASON $e\n$stackTrace');
      if (e is Exception) rethrow;
      throw Exception('لم يتم استلام رد من السيرفر');
    }
  }
}
