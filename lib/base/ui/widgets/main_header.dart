import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/core/navigation_service/navigation_service.dart';
import 'package:rep_visit/main.dart';
import 'package:rep_visit/screens/base_screen/providers/base_provider.dart';
import 'package:rep_visit/screens/notifications/providers/notifications_provider.dart';
import 'package:rep_visit/screens/notifications/ui/notifications_screen.dart';
import 'package:rep_visit/screens/profile_screen/ui/profile_screen.dart';

import '../../constants/app_colors.dart';
import '../../constants/asset_images.dart';
import 'text_widget.dart';

class MainHeader extends StatefulWidget {
  final String title;
  final String subTitle;
  final bool? isProfile;

  const MainHeader({
    super.key,
    required this.title,
    required this.subTitle,
    this.isProfile,
  });

  @override
  State<MainHeader> createState() => _MainHeaderState();
}

class _MainHeaderState extends State<MainHeader> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationsProvider>(context, listen: false)
          .getNotifications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BaseProvider>(context, listen: false);
    var notificationsProvider =
        Provider.of<NotificationsProvider>(context, listen: false);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  widget.title,
                  textSize: 20,
                  textColor: AppColors.fontColor,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  width: Dimensions.fullWidth(context) * 0.63,
                  child: TextWidget(
                    widget.subTitle,
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
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    topIconWidget(AssetImages.notificationIcon, () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return const NotificationsScreen();
                        },
                      );
                    }),
                    Selector<NotificationsProvider, bool>(
                        builder: (context, provider, _) {
                          return provider
                              ? const Positioned(
                                  top: -8,
                                  right: -8,
                                  child: NotificationDotWithRipple(),
                                )
                              : const SizedBox();
                        },
                        selector: (context, selector) =>
                            selector.notifications.isNotEmpty)
                  ],
                ),
                widget.isProfile == true
                    ? const SizedBox()
                    : const SizedBox(width: 20),
                widget.isProfile == true
                    ? const SizedBox()
                    : topIconWidget(AssetImages.personIcon, () {
                        provider.setCurrentIndex(5);
                      }),
              ],
            )
          ],
        ),
      ],
    );
  }

  /// Top bar icon widget
  Widget topIconWidget(String image, VoidCallback onTap) {
    return GestureDetector(
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
          child: SvgPicture.asset(image),
        ),
      ),
    );
  }
}

class NotificationDotWithRipple extends StatefulWidget {
  const NotificationDotWithRipple({super.key});

  @override
  State<NotificationDotWithRipple> createState() =>
      _NotificationDotWithRippleState();
}

class _NotificationDotWithRippleState extends State<NotificationDotWithRipple>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ripple
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: 10 + (_controller.value * 12),
                height: 10 + (_controller.value * 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.red.withOpacity(
                    1 - _controller.value,
                  ),
                ),
              );
            },
          ),

          // fixed dot
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.red,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
