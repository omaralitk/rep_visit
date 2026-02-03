import 'package:flutter/material.dart';
import '../../../../base/constants/app_colors.dart';
import '../../../../base/ui/widgets/shimmer_widget.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Tab shimmer
            Row(
              children: [
                CustomShimmer(
                  width: 80,
                  height: 36,
                  borderRadius: BorderRadius.circular(6),
                ),
                const SizedBox(width: 12),
                CustomShimmer(
                  width: 80,
                  height: 36,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Profile info shimmer
            Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border.all(color: AppColors.grey200),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile image
                  CustomShimmer(
                    width: 100,
                    height: 100,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  const SizedBox(height: 20),
                  // Name
                  CustomShimmer(width: 150, height: 18),
                  const SizedBox(height: 12),
                  // Phone
                  CustomShimmer(width: 120, height: 14),
                  const SizedBox(height: 20),
                  // Edit button
                  CustomShimmer(
                    width: double.infinity,
                    height: 48,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Settings section shimmer
            Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border.all(color: AppColors.grey200),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        CustomShimmer(width: 100, height: 14),
                        const Spacer(),
                        CustomShimmer(width: 60, height: 14),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}










