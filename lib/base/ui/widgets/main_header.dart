import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/core/navigation_service/navigation_service.dart';
import 'package:rep_visit/main.dart';
import 'package:rep_visit/screens/base_screen/providers/base_provider.dart';
import 'package:rep_visit/screens/profile_screen/ui/profile_screen.dart';

import '../../constants/app_colors.dart';
import '../../constants/asset_images.dart';
import 'text_widget.dart';

class MainHeader extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool? isProfile;

  const MainHeader(
      {super.key, required this.title, required this.subTitle, this.isProfile});
  @override
  Widget build(BuildContext context) {
    var provider=Provider.of<BaseProvider>(context,listen: false);

    return Column(
      children: [
        // const SizedBox(
        //   height: 60,
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  title,
                  textSize: 20,
                  textColor: AppColors.fontColor,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  width: Dimensions.fullWidth(context) * 0.63,
                  child: TextWidget(
                    subTitle,
                    textSize: 12,
                    textColor: AppColors.typography700,
                    fontWeight: FontWeight.w500,
                    maxLine: 2,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                topIconWidget(AssetImages.notificationIcon, () {}),
                isProfile == true
                    ? const SizedBox()
                    : const SizedBox(
                        width: 20,
                      ),
                isProfile == true
                    ? const SizedBox()
                    : topIconWidget(AssetImages.personIcon, () {
                        // NavigationService.push(const ProfileScreen());
                  provider.setCurrentIndex(5);
                      })
              ],
            )
          ],
        ),
      ],
    );
  }

  /// Top bar icon widget
  topIconWidget(String image, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: SvgPicture.asset(
            image,
          ),
        ),
      ),
    );
  }
}
