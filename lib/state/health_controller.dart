import 'dart:async';

import 'package:flutter/foundation.dart';

import '../config/api_config.dart';
import '../data/api_exception.dart';
import '../data/rag_api_client.dart';

class HealthController extends ChangeNotifier {
  HealthController(this._api);

  final RagApiClient _api;
  Timer? _timer;

  bool _up = false;
  bool _checked = false;
  DateTime? _lastChecked;
  String? _error;

  bool get isUp => _up;
  bool get hasChecked => _checked;
  DateTime? get lastChecked => _lastChecked;
  String? get error => _error;

  void start() {
    refresh();
    _timer?.cancel();
    _timer = Timer.periodic(ApiConfig.healthPollInterval, (_) => refresh());
  }

  Future<void> refresh() async {
    try {
      final health = await _api.getHealth();
      _up = health.isUp;
      _error = null;
    } on ApiException catch (e) {
      _up = false;
      _error = e.userMessage;
    } catch (e) {
      _up = false;
      _error = e.toString();
    }
    _checked = true;
    _lastChecked = DateTime.now();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
