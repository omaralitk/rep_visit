import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/asset_images.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';
import 'package:rep_visit/screens/base_screen/providers/base_provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;


  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,

  });

  @override
  Widget build(BuildContext context) {
    var baseProvider = Provider.of<BaseProvider>(context, listen: false);

    final items = [
      const _NavItem(icon: AssetImages.homeIcon, label: "Home"),
      const _NavItem(icon: AssetImages.scheduleIcon, label: "Schedule"),
      const _NavItem(icon: AssetImages.trackingIcon, label: "Tracking"),
      const _NavItem(icon: AssetImages.doctorsIcon, label: "Doctors"),
      const _NavItem(icon: AssetImages.reportsIcon, label: "Reports"),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,

      border: Border.fromBorderSide(BorderSide(color: AppColors.grey100))
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
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
