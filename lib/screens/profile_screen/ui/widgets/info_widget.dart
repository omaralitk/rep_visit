// import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/asset_images.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/base/ui/widgets/button_widget.dart';
import 'package:rep_visit/base/ui/widgets/cached_image.dart';
import 'package:rep_visit/base/ui/widgets/lang_switcher.dart';
import 'package:rep_visit/base/ui/widgets/shared_text_form_field.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';
import 'package:rep_visit/core/navigation_service/navigation_service.dart';
import 'package:rep_visit/screens/profile_screen/provider/profile_provider.dart';
import 'package:rep_visit/screens/profile_screen/ui/widgets/change_pass_widget.dart';

class InfoWidget extends StatefulWidget {
  const InfoWidget({super.key});

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(
        context,
        listen: false,
      ).loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final user = provider.user;

        if (user != null && !provider.fieldsInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            provider.fillFieldsFromUser();
          });
        }

        return provider.isChangePassword
            ? ChangePassWidget()
            : Column(
                children: [
                  /// Personal info widget
                  Container(
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
                                  child: SvgPicture.asset(
                                      AssetImages.personalInfoIcon),
                                ),
                              ),
                              const SizedBox(width: 12),
                              TextWidget(
                                "Personal Information",
                                textSize: 16,
                                fontWeight: FontWeight.w700,
                                textColor: AppColors.fontColor,
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              // Show picked image if available, otherwise show cached network image
                              provider.pickedImageFile != null
                                  ? Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: AppColors.primary100),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.file(
                                        provider.pickedImageFile!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : CachedImage(
                                      url: provider.user?.image ?? ""),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () {
                                  provider.pickImage();
                                },
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: AppColors.grey200),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.camera_alt_outlined,
                                            color: AppColors.grey500),
                                        const SizedBox(width: 12),
                                        TextWidget(
                                          "Change Photo",
                                          textSize: 12,
                                          fontWeight: FontWeight.w700,
                                          textColor: AppColors.fontColor,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          SharedTextFormField(
                            label: "Full Name".tr(),
                            hint: "Enter your full name".tr(),
                            controller: provider.fullNameController,
                            onChanged: provider.updateName,
                            enabled: provider.isEdit,
                            filled: !provider.isEdit,
                          ),
                          const SizedBox(height: 10),
                          SharedTextFormField(
                            label: "Phone Number".tr(),
                            hint: "XXXXXXXX".tr(),
                            controller: provider.phoneController,
                            onChanged: provider.updatePhone,
                            enabled: provider.isEdit,
                            filled: !provider.isEdit,
                          ),
                          const SizedBox(height: 12),
                          Divider(color: AppColors.grey200),
                          const SizedBox(height: 12),
                          provider.isEdit == false
                              ? ButtonWidget(
                                  textColor: AppColors.whiteColor,
                                  backgroundColor: AppColors.black,
                                  icon: SvgPicture.asset(AssetImages.editIcon),
                                  text: "Edit Personal Profile".tr(),
                                  onTap: () => provider.setIsEdit(true),
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: ButtonWidget(
                                        text: "Cancel".tr(),
                                        textColor: AppColors.fontColor,
                                        onTap: () => provider.setIsEdit(false),
                                        backgroundColor: AppColors.whiteColor,
                                        borderColor: AppColors.grey500,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ButtonWidget(
                                        text: "Save Changes".tr(),
                                        textColor: AppColors.whiteColor,
                                        onTap: () =>
                                            provider.updateInfo(context),
                                        backgroundColor: AppColors.mainColor,
                                      ),
                                    ),
                                  ],
                                )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Settings
                  Container(
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
                                  child: SvgPicture.asset(
                                      AssetImages.settingsIcon),
                                ),
                              ),
                              const SizedBox(width: 12),
                              TextWidget(
                                "Settings".tr(),
                                textSize: 16,
                                fontWeight: FontWeight.w700,
                                textColor: AppColors.fontColor,
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(AssetImages.passIcon),
                                        const SizedBox(width: 5),
                                        TextWidget(
                                          "pass".tr(),
                                          textSize: 14,
                                          textColor: AppColors.typography500,
                                          fontWeight: FontWeight.w500,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: ButtonWidget(
                                      text: "Change".tr(),
                                      icon: SvgPicture.asset(
                                          AssetImages.editIcon),
                                      backgroundColor: AppColors.black,
                                      fontWeight: FontWeight.w700,
                                      onTap: () {
                                        provider.setIsChangePassword(true);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                "Language".tr(),
                                textSize: 16,
                                fontWeight: FontWeight.w700,
                                textColor: AppColors.fontColor,
                              ),
                              const SizedBox(width: 12),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.grey300),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: LangSwitcher(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Divider(color: AppColors.grey200),
                  const SizedBox(height: 10),

                  ButtonWidget(
                    backgroundColor: AppColors.signOutColor,
                    borderColor: AppColors.signOutBorderColor,
                    textColor: AppColors.signOutBorderColor,
                    text: "Sign Out".tr(),
                    onTap: () async => await provider.makeLogOut(context),
                  ),

                  const SizedBox(height: 40),
                ],
              );
      },
    );
  }
}
