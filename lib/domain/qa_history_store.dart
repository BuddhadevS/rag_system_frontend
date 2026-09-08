import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/models.dart';

class QaHistoryStore {
  QaHistoryStore();

  final Map<int, List<QaTurn>> _memory = {};

  String _key(int documentId) => 'rag.qa.$documentId';

  Future<List<QaTurn>> load(int documentId) async {
    if (_memory.containsKey(documentId)) {
      return List.unmodifiable(_memory[documentId]!);
    }
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key(documentId));
    if (raw == null || raw.isEmpty) {
      _memory[documentId] = [];
      return const [];
    }
    try {
      final decoded = jsonDecode(raw);
      final list = decoded is List
          ? decoded
              .whereType<Map>()
              .map((e) => QaTurn.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : <QaTurn>[];
      _memory[documentId] = list;
      return List.unmodifiable(list);
    } catch (_) {
      _memory[documentId] = [];
      return const [];
    }
  }

  Future<List<QaTurn>> append(int documentId, QaTurn turn) async {
    final current = List<QaTurn>.from(await load(documentId));
    current.insert(0, turn);
    _memory[documentId] = current;
    await _persist(documentId, current);
    return List.unmodifiable(current);
  }

  Future<void> clear(int documentId) async {
    _memory.remove(documentId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(documentId));
  }

  Future<void> _persist(int documentId, List<QaTurn> turns) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key(documentId),
      jsonEncode(turns.map((t) => t.toJson()).toList()),
    );
  }
}
