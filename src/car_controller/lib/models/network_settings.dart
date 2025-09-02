import 'package:flutter/foundation.dart';

class NetworkSettings extends ChangeNotifier {
  String _ipAddress = '';

  String get ipAddress => _ipAddress;

  void setIpAddress(String newIpAddress) {
    if (_ipAddress != newIpAddress) {
      _ipAddress = newIpAddress;
      notifyListeners();
    }
  }

  void reset() {
    _ipAddress = '';
    notifyListeners();
  }
}