import '/../models/ui_model_status.dart';
import '/../repositories/dio_instance.dart';
import '/../repositories/session_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  // UI States
  UIModelStatus _status = UIModelStatus.Ended;
  String _errorCode = '';
  String _errorMessage = '';

  String get errorCode => _errorCode;
  String get errorMessage => _errorMessage;
  UIModelStatus get status => _status;

  final FocusNode _focusNodeMerchantId = FocusNode();
  final FocusNode _focusNodePin = FocusNode();
  final FocusNode _focusNodeTerminalId = FocusNode();

  FocusNode get focusNodeMerchantId => _focusNodeMerchantId;
  FocusNode get focusNodePin => _focusNodePin;
  FocusNode get focusNodeTerminalId => _focusNodeTerminalId;

  // Form States
  final _loginFormKey = GlobalKey<FormState>();
  String _merchantId = '0000000000';
  String _pin = '000000';
  String _terminalId = '0000000000';
  bool _hiddenPin = true;
  bool _withTerminalId = false;

  GlobalKey<FormState> get loginFormKey => _loginFormKey; 
  String get merchantId => _merchantId;
  String get pin => _pin;
  String get terminalId => _terminalId;
  bool get hiddenPin => _hiddenPin;
  bool get withTerminalId => _withTerminalId;

  var dioInstance = DioSingleton();
  var secureStorageInstance = SecureStorageSingleton();

  LoginViewModel();

  // Functions
  void toggleVisibility() {
    _hiddenPin = !hiddenPin;
    notifyListeners();
  }

  void setMerchantId(newMerchantId) {
    _merchantId = newMerchantId;
  }

  void setPin(newPin) {
    _pin = newPin;
  }

  void setTerminalId(newTerminalId) {
    _terminalId = newTerminalId;
  }

  void toggleTerminalId() {
    _withTerminalId = !withTerminalId;
    notifyListeners();
  }

  // Test connectivity
  Future<bool> submitLoginInfo() async {
  _status = UIModelStatus.Loading;
  notifyListeners();

  try {
    Response response = await dioInstance.postLoginInfo(merchantId, pin);

    if (response.statusCode == 200) {
      final data = response.data;

      final token = await secureStorageInstance.getValue('session-token');
      if (token != null && token.isNotEmpty) {
        await secureStorageInstance.write('auth_token', data['token']);
        _status = UIModelStatus.Ended;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Login gagal: token tidak ditemukan';
      }
    } else {
      _errorMessage = 'Server error: ${response.statusCode}';
    }
  } catch (e) {
    _errorMessage = 'Koneksi gagal: $e';
  }

  _status = UIModelStatus.Ended;
  notifyListeners();
  return false;
}

}