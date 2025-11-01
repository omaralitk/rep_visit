import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rep_visit/base/constants/dimensions.dart';

import '../../constants/app_colors.dart';
import '../../constants/asset_images.dart';
import 'text_widget.dart';

class MainHeader extends StatelessWidget {
  String title;
  String subTitle;

  MainHeader({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
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
                  width: Dimensions.fullWidth(context)*0.63,
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
                const SizedBox(
                  width: 20,
                ),
                topIconWidget(AssetImages.personIcon, () {})
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
