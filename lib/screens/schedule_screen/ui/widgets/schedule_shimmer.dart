import 'package:flutter/material.dart';
import '../../../../base/constants/app_colors.dart';
import '../../../../base/ui/widgets/shimmer_widget.dart';

class ScheduleShimmer extends StatelessWidget {
  const ScheduleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Header shimmer
            Container(
              decoration: BoxDecoration(
                color: AppColors.grey100,
                border: Border.all(color: AppColors.grey200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomShimmer(
                          width: 42,
                          height: 42,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomShimmer(width: 120, height: 16),
                            const SizedBox(height: 6),
                            CustomShimmer(width: 100, height: 12),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomShimmer(width: double.infinity, height: 14),
                    const SizedBox(height: 8),
                    CustomShimmer(width: double.infinity, height: 14),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Visit cards shimmer (3 items)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) => _shimmerVisitCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerVisitCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
                CustomShimmer(
                  width: 60,
                  height: 60,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer(width: 120, height: 16),
                      const SizedBox(height: 6),
                      CustomShimmer(width: 100, height: 12),
                      const SizedBox(height: 6),
                      CustomShimmer(width: 80, height: 12),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: CustomShimmer(width: double.infinity, height: 32)),
                const SizedBox(width: 8),
                Expanded(child: CustomShimmer(width: double.infinity, height: 32)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}












