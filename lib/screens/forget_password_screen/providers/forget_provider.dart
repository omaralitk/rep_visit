import 'package:flutter/cupertino.dart';
import 'package:rep_visit/base/ui/widgets/custom_toast.dart';
import 'package:rep_visit/screens/forget_password_screen/repo/forget_pass_repo.dart';

import '../../../base/ui/widgets/loading_widget.dart';

class ForgetProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();

  ForgetProvider() {
    emailController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    notifyListeners();
  }
  Future forgetPass(String email, BuildContext context) async {
    LoadingWidget.show(context);
    Map<String, dynamic> body = {"email": email, };
    ForgetPassRepo().forgetPass(body).then((val) {
      LoadingWidget.hide(context);
      if (val.status == 1) {
        ToastService.showSuccess(context,val.msg);
      }else{
        ToastService.showError(context,val.msg);

      }
    });
  }
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
