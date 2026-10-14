import 'package:voyage_jordan2/models/itinerary_activity_slot.dart';
import 'package:voyage_jordan2/models/itinerary_day.dart';
import 'package:voyage_jordan2/models/trip_plan_build_result.dart';
import 'package:voyage_jordan2/models/trip_plan_cost_summary.dart';

/// Deterministic trip builder: same inputs always yield the same plan.
class TripPlanGenerator {
  TripPlanGenerator._();

  /// Southbound-friendly order used whenever multiple destinations are selected.
  static const jordanFlowOrder = <String>[
    'jerash',
    'dead-sea',
    'petra',
    'wadi-rum',
    'aqaba',
  ];

  static const _timeSlots = <String>[
    '8:00 AM',
    '10:00 AM',
    '12:30 PM',
    '3:00 PM',
    '5:30 PM',
    '8:00 PM',
  ];

  static final Map<String, List<String>> _todoPools = {
    'jerash': ['todoJerash1', 'todoJerash2', 'todoJerash3', 'todoJerash4', 'todoJerash5'],
    'dead-sea': ['todoDead1', 'todoDead2', 'todoDead3', 'todoDead4', 'todoDead5'],
    'petra': ['todoPetra1', 'todoPetra2', 'todoPetra3', 'todoPetra4', 'todoPetra5'],
    'wadi-rum': ['todoWadi1', 'todoWadi2', 'todoWadi3', 'todoWadi4', 'todoWadi5'],
    'aqaba': ['todoAqaba1', 'todoAqaba2', 'todoAqaba3', 'todoAqaba4', 'todoAqaba5'],
  };

  static TripPlanBuildResult build({
    required Set<String> selectedDestinations,
    required int tripDays,
    required int budgetTier,
    required int transportMode,
  }) {
    final ordered = jordanFlowOrder.where(selectedDestinations.contains).toList();
    if (ordered.isEmpty) {
      return TripPlanBuildResult(
        days: const [],
        cost: const TripPlanCostSummary(
          totalUsd: 0,
          accommodationUsd: 0,
          mealsUsd: 0,
          transportUsd: 0,
          activitiesUsd: 0,
        ),
        budgetTier: budgetTier.clamp(0, 2),
        transportMode: transportMode.clamp(0, 3),
        orderedDestinationIds: const [],
        tripDays: tripDays,
      );
    }

    final b = budgetTier.clamp(0, 2);
    final t = transportMode.clamp(0, 3);

    final counters = <String, int>{
      for (final d in ordered) d: 0,
    };

    final specs = _buildDaySpecs(ordered, tripDays);
    final days = <ItineraryDay>[];

    for (var i = 0; i < specs.length; i++) {
      final chunk = specs[i];
      final overnight = chunk.last;
      final activities = _activitiesForChunk(
        chunk: chunk,
        dayIndex: i,
        counters: counters,
      );
      days.add(
        ItineraryDay(
          dayNumber: i + 1,
          locationId: overnight,
          serviceDestinationId: overnight,
          activities: activities,
        ),
      );
    }

    return TripPlanBuildResult(
      days: days,
      cost: _computeCost(
        tripDays: tripDays,
        destinationCount: ordered.length,
        budgetTier: b,
        transportMode: t,
      ),
      budgetTier: b,
      transportMode: t,
      orderedDestinationIds: List<String>.from(ordered),
      tripDays: tripDays,
    );
  }

  /// When [totalDays] >= [ordered].length: one destination may span several consecutive days.
  /// When [totalDays] < [ordered].length: group consecutive destinations into fewer days (non-empty chunks).
  static List<List<String>> _buildDaySpecs(List<String> ordered, int totalDays) {
    final n = ordered.length;
    if (totalDays >= n) {
      final alloc = List.generate(n, (i) => totalDays ~/ n + (i < totalDays % n ? 1 : 0));
      final out = <List<String>>[];
      for (var i = 0; i < n; i++) {
        for (var j = 0; j < alloc[i]; j++) {
          out.add([ordered[i]]);
        }
      }
      return out;
    }

    final k = totalDays;
    final sizes = List.generate(k, (i) => n ~/ k + (i < n % k ? 1 : 0));
    final chunks = <List<String>>[];
    var start = 0;
    for (final s in sizes) {
      chunks.add(ordered.sublist(start, start + s));
      start += s;
    }
    return chunks;
  }

  static List<ItineraryActivitySlot> _activitiesForChunk({
    required List<String> chunk,
    required int dayIndex,
    required Map<String, int> counters,
  }) {
    if (chunk.length == 1) {
      return _singleDestinationDay(
        dest: chunk.first,
        dayIndex: dayIndex,
        counters: counters,
      );
    }
    return _multiDestinationDay(chunk: chunk, counters: counters);
  }

  static List<ItineraryActivitySlot> _singleDestinationDay({
    required String dest,
    required int dayIndex,
    required Map<String, int> counters,
  }) {
    final count = 3 + (dayIndex % 2);
    return _takeSlots(dest, count, counters);
  }

  static List<ItineraryActivitySlot> _multiDestinationDay({
    required List<String> chunk,
    required Map<String, int> counters,
  }) {
    final slots = <ItineraryActivitySlot>[];
    var timeI = 0;

    final target = (3 + chunk.length).clamp(4, 6);
    var budgetActs = target;

    for (var i = 0; i < chunk.length; i++) {
      final d = chunk[i];
      final isLast = i == chunk.length - 1;
      final remainingSegs = chunk.length - i;
      var take = isLast ? budgetActs : (budgetActs ~/ remainingSegs).clamp(1, 3);
      if (!isLast) {
        take = take.clamp(1, 2);
      }
      take = take.clamp(1, budgetActs);

      for (var j = 0; j < take; j++) {
        if (budgetActs <= 0) break;
        slots.add(
          ItineraryActivitySlot(
            time: _timeSlots[timeI.clamp(0, _timeSlots.length - 1)],
            activityItemId: _nextTodoId(d, counters),
          ),
        );
        timeI++;
        budgetActs--;
      }

      if (!isLast && budgetActs > 0) {
        final next = chunk[i + 1];
        slots.add(
          ItineraryActivitySlot(
            time: _timeSlots[timeI.clamp(0, _timeSlots.length - 1)],
            activityItemId: 'TRAVEL:$next',
          ),
        );
        timeI++;
        budgetActs--;
      }
    }

    while (budgetActs > 0 && timeI < _timeSlots.length) {
      final d = chunk.last;
      slots.add(
        ItineraryActivitySlot(
          time: _timeSlots[timeI],
          activityItemId: _nextTodoId(d, counters),
        ),
      );
      timeI++;
      budgetActs--;
    }

    return slots;
  }

  static List<ItineraryActivitySlot> _takeSlots(String dest, int count, Map<String, int> counters) {
    final out = <ItineraryActivitySlot>[];
    for (var i = 0; i < count; i++) {
      out.add(
        ItineraryActivitySlot(
          time: _timeSlots[i.clamp(0, _timeSlots.length - 1)],
          activityItemId: _nextTodoId(dest, counters),
        ),
      );
    }
    return out;
  }

  static String _nextTodoId(String dest, Map<String, int> counters) {
    final pool = _todoPools[dest]!;
    final i = counters[dest] ?? 0;
    counters[dest] = i + 1;
    return pool[i % pool.length];
  }

  static TripPlanCostSummary _computeCost({
    required int tripDays,
    required int destinationCount,
    required int budgetTier,
    required int transportMode,
  }) {
    var core = 210 * tripDays + 140 * destinationCount;

    final budgetMult = switch (budgetTier) {
      0 => 88,
      1 => 100,
      _ => 132,
    };
    core = core * budgetMult ~/ 100;

    final transportMult = switch (transportMode) {
      0 => 94,
      1 => 118,
      2 => 76,
      _ => 124,
    };
    core = core * transportMult ~/ 100;

    final accommodation = core * 36 ~/ 100;
    final meals = core * 22 ~/ 100;
    final transport = core * 20 ~/ 100;
    var activities = core - accommodation - meals - transport;
    if (activities < 40) activities = 40;
    final total = accommodation + meals + transport + activities;

    return TripPlanCostSummary(
      totalUsd: total,
      accommodationUsd: accommodation,
      mealsUsd: meals,
      transportUsd: transport,
      activitiesUsd: activities,
    );
  }
}
