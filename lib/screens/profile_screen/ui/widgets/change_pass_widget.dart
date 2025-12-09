import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';
import 'package:rep_visit/core/navigation_service/navigation_service.dart';
import 'package:rep_visit/screens/profile_screen/provider/profile_provider.dart';

import '../../../../base/constants/asset_images.dart';
import '../../../../base/ui/widgets/button_widget.dart';
import '../../../../base/ui/widgets/shared_text_form_field.dart';

class ChangePassWidget extends StatefulWidget {
  const ChangePassWidget({super.key});

  @override
  State<ChangePassWidget> createState() => _ChangePassWidgetState();
}

class _ChangePassWidgetState extends State<ChangePassWidget> {
  var provider=Provider.of<ProfileProvider>(NavigationService.navigatorKey.currentContext!);
  @override
  Widget build(BuildContext context) {
    return    Container(
      width: Dimensions.fullWidth(context),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SvgPicture.asset(AssetImages.passIcon),
                  ),
                ),
                const SizedBox(width: 12),
                TextWidget(
                  "Change Password",
                  textSize: 16,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.fontColor,
                )
              ],
            ),
            const SizedBox(height: 12),



            SharedTextFormField(
              label: "Current Password",
              hint: "Enter your current password",
              controller: provider.currentPassController,
              // onChanged: provider.updateName,
              // enabled: provider.isEdit,
              // filled: !provider.isEdit,
            ),

            const SizedBox(height: 10),

            SharedTextFormField(
              label: "New Password",
              hint: "Enter your new password",
              controller: provider.newPassController,
              // onChanged: provider.updatePhone,
              // enabled: provider.isEdit,
              // filled: !provider.isEdit,
            ),
            const SizedBox(height: 10),

            SharedTextFormField(
              label: "Confirm Password",
              hint: "Confirm your new password",
              controller: provider.confirmPassController,
              // onChanged: provider.updatePhone,
              // enabled: provider.isEdit,
              // filled: !provider.isEdit,
            ),
            const SizedBox(height: 12),
            Divider(color: AppColors.grey200),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    text: "Cancel",
                    textColor: AppColors.fontColor,
                    onTap: () => provider.setIsChangePassword(false),
                    backgroundColor: AppColors.whiteColor,
                    borderColor: AppColors.grey500,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ButtonWidget(
                    text: "Save Changes",
                    textColor: AppColors.whiteColor,
                    onTap: () => provider.changePass(),
                    backgroundColor: AppColors.mainColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
