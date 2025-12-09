import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';

import '../../constants/app_colors.dart';
import '../../constants/asset_images.dart';
import '../../constants/dimensions.dart';

class NoDataWidget extends StatelessWidget {
  final String title;

  const NoDataWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.fullWidth(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            SvgPicture.asset(AssetImages.noData),
            const SizedBox(
              height: 10,
            ),
            TextWidget(
              title,
              textSize: 16,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w700,
              textColor: AppColors.typography500,
            ),
          ],
        ),
      ),
    );
  }
}
