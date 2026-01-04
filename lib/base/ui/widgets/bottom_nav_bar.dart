import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/asset_images.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';
import 'package:rep_visit/screens/base_screen/providers/base_provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
final bool? isProfile;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    this.isProfile

  });

  @override
  Widget build(BuildContext context) {
    var baseProvider = Provider.of<BaseProvider>(context, listen: false);

    final items = [
       _NavItem(icon: AssetImages.homeIcon, label: "Home".tr()),
       _NavItem(icon: AssetImages.scheduleIcon, label: "Schedule".tr()),
       _NavItem(icon: AssetImages.trackingIcon, label: "Tracking".tr()),
       _NavItem(icon: AssetImages.doctorsIcon, label: "Doctors".tr()),
       _NavItem(icon: AssetImages.reportsIcon, label: "Reports".tr()),
       _NavItem(icon: AssetImages.personalInfoIcon, label: "Profile"),

    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,

      border: Border.fromBorderSide(BorderSide(color: AppColors.grey100))
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length-1, (index) {
          final item = items[index];
          final isActive = currentIndex == index;

          return GestureDetector(
            onTap: (){

              baseProvider.setCurrentIndex(index);
            },
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  item.icon,
                  color: isActive ? AppColors.mainColor : Colors.grey,
                ),
                const SizedBox(height: 4),
                TextWidget(
                  item.label,
                  textSize: 12,
                  style: TextStyle(

                    color: isActive ? AppColors.mainColor : Colors.grey,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final String icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
