import 'package:flutter/foundation.dart';
import '../models/consultant.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  Consultant? _consultant;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isAuthenticated => _consultant != null;
  Consultant? get consultant => _consultant;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _consultant = await ApiService.login(email, password);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
  }

  void setConsultant(Consultant c) {
    _consultant = c;
    notifyListeners();
  }

  void logout() {
    _consultant = null;
    _errorMessage = null;
    notifyListeners();
  }
}
