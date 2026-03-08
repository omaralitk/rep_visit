import 'package:flutter/material.dart';
import '../../../../base/constants/app_colors.dart';
import '../../../../base/ui/widgets/shimmer_widget.dart';

class NotificationsShimmer extends StatelessWidget {
  const NotificationsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: 5,
      itemBuilder: (context, index) => _shimmerNotificationCard(),
    );
  }

  Widget _shimmerNotificationCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.grey200),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer(width: 200, height: 16),
                      const SizedBox(height: 8),
                      CustomShimmer(width: 150, height: 12),
                    ],
                  ),
                ),
                CustomShimmer(
                  width: 60,
                  height: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomShimmer(width: double.infinity, height: 12),
            const SizedBox(height: 4),
            CustomShimmer(width: 180, height: 12),
          ],
        ),
      ),
    );
  }
}











