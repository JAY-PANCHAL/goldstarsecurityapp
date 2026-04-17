import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final _connectivity = Connectivity();
  final RxBool _isOnline = true.obs;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool get isOnline => _isOnline.value;

  Future<ConnectivityService> init() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _isOnline.value = _hasConnection(result);

      _subscription = _connectivity.onConnectivityChanged.listen((result) {
        _isOnline.value = _hasConnection(result);
      });
    } catch (_) {
      _isOnline.value = true;
    }
    return this;
  }

  bool _hasConnection(List<ConnectivityResult> result) {
    return result.any((r) => r != ConnectivityResult.none);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
