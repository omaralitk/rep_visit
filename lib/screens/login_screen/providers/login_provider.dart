import 'package:flutter/material.dart';
import 'package:rep_visit/base/ui/widgets/custom_toast.dart';
import 'package:rep_visit/base/ui/widgets/loading_widget.dart';
import 'package:rep_visit/core/cach/cach_manager.dart';
import 'package:rep_visit/screens/login_screen/repo/login_repo.dart';

import '../../../core/navigation_service/navigation_service.dart';
import '../../base_screen/ui/base_screen.dart';

class LoginProvider extends ChangeNotifier {
  LoginRepo _loginRepo = LoginRepo();

  bool _isRememberMe = false;

  bool get isRememberMe => _isRememberMe;

  TextEditingController empCodeController = TextEditingController();
  TextEditingController passController = TextEditingController();

  LoginProvider() {
    empCodeController.addListener(_onTextChanged);
    passController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    notifyListeners();
  }

  setIsRememberMe(bool val) {
    _isRememberMe = val;
    notifyListeners();
  }

  FocusNode empFocus = FocusNode();
  FocusNode passFocus = FocusNode();

  bool checkValidate() {
    return empCodeController.text.isNotEmpty && passController.text.isNotEmpty;
  }

  Future makeLogin(String email, String pass, BuildContext context) async {
    LoadingWidget.show(context);
    Map<String, dynamic> body = {"email": email, "password": pass};
    _loginRepo.makeLogin(body).then((val) {
      LoadingWidget.hide(context);
      if (val.status == 1) {
        UserCache.setIsLogin(true);
        UserCache.setToken(val.token);
        NavigationService.pushAndRemoveUntil(context, const BaseScreen());
      }else{
        ToastService.showError(context, "Wrong email or password");
      }
    });
  }
}
