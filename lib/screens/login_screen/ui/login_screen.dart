import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/base/ui/widgets/button_widget.dart';
import 'package:rep_visit/base/ui/widgets/custom_check_box.dart';
import 'package:rep_visit/base/ui/widgets/lang_switcher.dart';
import 'package:rep_visit/base/ui/widgets/loading_widget.dart';
import 'package:rep_visit/base/ui/widgets/shared_text_form_field.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';
import 'package:rep_visit/core/navigation_service/navigation_service.dart';
import 'package:rep_visit/screens/forget_password_screen/ui/forget_password_screen.dart';
import 'package:rep_visit/screens/login_screen/providers/login_provider.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var loginProvider = Provider.of<LoginProvider>(context, listen: false);
    return Scaffold(
      body: Container(
        color: AppColors.whiteColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      LoadingWidget.show(context);
                    },
                    child: TextWidget(
                      "welcome_back".tr(),
                      fontWeight: FontWeight.bold,
                      textSize: 24,
                      textColor: AppColors.fontColor,
                    ),
                  ),
                  const LangSwitcher()
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  LoadingWidget.hide(context);
                },
                child: TextWidget(
                  "please_enter_a_form".tr(),
                  fontWeight: FontWeight.w500,
                  textSize: 14,
                  textColor: AppColors.fontColor,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Form(
                  child: Column(
                children: [
                  SharedTextFormField(
                    label: "emp_code".tr(),
                    hint: "enter_your_employee".tr(),
                    controller: loginProvider.empCodeController,
                    onSubmitted: (v) {
                      FocusScope.of(context)
                          .requestFocus(loginProvider.passFocus);
                    },
                    focusNode: loginProvider.empFocus,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SharedTextFormField(
                    label: "pass".tr(),
                    hint: "enter_pass".tr(),
                    controller: loginProvider.passController,
                    isPassword: true,
                    focusNode: loginProvider.passFocus,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _rememberMeWidget(loginProvider),
                      InkWell(
                        onTap: () {
                          NavigationService.push(
                              context, const ForgetPasswordScreen());
                        },
                        child: TextWidget(
                          "forget_pass".tr(),
                          textColor: AppColors.fontColor,
                          textSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Selector<LoginProvider, bool>(
                      builder: (context, provider, widget) {
                        return ButtonWidget(
                          text: "sign_in".tr(),
                          onTap: provider
                              ? () {
                            FocusScope.of(context).unfocus();
                                  loginProvider.makeLogin(
                                      loginProvider.empCodeController.text,
                                      loginProvider.passController.text,
                                      context);
                                }
                              : () {},
                          textSize: 14,
                          borderColor: AppColors.grey200,
                          fontWeight: FontWeight.w700,
                          textColor: provider
                              ? AppColors.whiteColor
                              : AppColors.grey300,
                          backgroundColor: provider
                              ? AppColors.mainColor
                              : AppColors.grey100,
                        );
                      },
                      selector: (context, val) => val.checkValidate())
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  _rememberMeWidget(LoginProvider loginProvider) {
    return Selector<LoginProvider, bool>(
        builder: (context, provider, widget) {
          return Row(
            children: [
              CustomCheckBox(
                  checkboxCallback: (val) {
                    loginProvider.setIsRememberMe(val ?? false);
                  },
                  isChecked: provider),
              const SizedBox(
                width: 4,
              ),
              TextWidget(
                "remember".tr(),
                fontWeight: FontWeight.w700,
                textSize: 14,
                textColor: AppColors.fontColor,
              )
            ],
          );
        },
        selector: (context, remember) => remember.isRememberMe);
  }
}
