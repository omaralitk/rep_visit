import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/ui/widgets/button_widget.dart';
import 'package:rep_visit/base/ui/widgets/shared_text_form_field.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';
import 'package:rep_visit/core/navigation_service/navigation_service.dart';
import 'package:rep_visit/screens/forget_password_screen/providers/forget_provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    var forgetProvider = Provider.of<ForgetProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            IconButton(
                onPressed: () {
                  NavigationService.back();
                },
                icon: const Icon(Icons.arrow_back_ios_new)),
            const SizedBox(
              height: 20,
            ),
        TextWidget(
          "Forget Password".tr(),
          fontWeight: FontWeight.w700,
          textColor: AppColors.fontColor,
          textSize: 24,
        ),
            const SizedBox(
              height: 20,
            ),
            SharedTextFormField(
                label: "Email".tr(),
                hint: "Enter your email".tr(),
                controller: forgetProvider.emailController),
            const SizedBox(
              height: 30,
            ),
            Selector<ForgetProvider, String>(
              selector: (context, provider) => provider.emailController.text,
              builder: (context, text, child) {
                final isFilled = text.isNotEmpty;
                return ButtonWidget(
                  text: "Submit".tr(),
                  onTap:isFilled? () {
                    forgetProvider.forgetPass(text, context);
                  }:(){},
                  backgroundColor: isFilled
                      ? AppColors.mainColor
                      : AppColors.grey100,
                  textColor: isFilled
                      ? AppColors.whiteColor
                      : AppColors.grey300,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
