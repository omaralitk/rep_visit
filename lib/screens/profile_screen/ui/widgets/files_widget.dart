import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/core/utilities/main_utilities.dart';
import 'package:rep_visit/screens/profile_screen/provider/profile_provider.dart';

import '../../../../base/constants/app_colors.dart';
import '../../../../base/constants/asset_images.dart';
import '../../../../base/ui/widgets/text_widget.dart';

class FilesWidget extends StatefulWidget {
  const FilesWidget({super.key});

  @override
  State<FilesWidget> createState() => _FilesWidgetState();
}

class _FilesWidgetState extends State<FilesWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).getFiles();
    });  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, provider, w) {
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColors.grey100,
                border: Border.all(color: AppColors.grey200),
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.grey300)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(AssetImages.filesIcon),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            "Files",
                            textSize: 16,
                            fontWeight: FontWeight.w700,
                            textColor: AppColors.fontColor,
                          ),
                          SizedBox(
                            width: Dimensions.fullWidth(context) * 0.68,
                            child: TextWidget(
                              // provider.date,
                              "Check the files shared by your organization.",
                              textSize: 12,
                              fontWeight: FontWeight.w500,
                              textColor: AppColors.typography500,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  provider.filesLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: provider.filesList.length,
                          itemBuilder: (context, index) {
                            return Container(
                                decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextWidget(
                                          provider
                                              .filesList[index].originalName,
                                          textSize: 12,
                                          textColor: AppColors.fontColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: AppColors.grey200)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 6),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                AssetImages.openedEyes,
                                                color: AppColors.mainColor,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  MainUtilities.callPhone("+962785804494");
                                                },
                                                child: TextWidget(
                                                  "View",
                                                  textSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  textColor:
                                                      AppColors.mainColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          })
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
