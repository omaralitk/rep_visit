import 'package:flutter/material.dart';
import '../../../../base/constants/app_colors.dart';
import '../../../../base/ui/widgets/shimmer_widget.dart';

class TrackingShimmer extends StatelessWidget {
  const TrackingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                CustomShimmer(
                  width: 80,
                  height: 30,
                  borderRadius: BorderRadius.circular(6),
                ),
                const SizedBox(width: 12),
                CustomShimmer(
                  width: 80,
                  height: 30,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                CustomShimmer(
                  width: 42,
                  height: 42,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(width: 12),
               const  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmer(width: 120, height: 16),
                     SizedBox(height: 6),
                    CustomShimmer(width: 180, height: 14),
                  ],
                )
              ],
            ),

            const SizedBox(height: 20),

            // List shimmer (5 items)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) => shimmerVisitCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget shimmerVisitCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Name + time
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer(width: 140, height: 16),
                       SizedBox(height: 6),
                      CustomShimmer(width: 100, height: 14),
                    ],
                  ),
                  CustomShimmer(width: 60, height: 20),
                ],
              ),

              const SizedBox(height: 15),

              // Address
              const Row(
                children: [
                  CustomShimmer(width: 20, height: 20),
                   SizedBox(width: 8),
                  CustomShimmer(width: 180, height: 14),
                ],
              ),

              const SizedBox(height: 15),

              // Start Button
              CustomShimmer(
                height: 48,
                width: double.infinity,
                borderRadius: BorderRadius.circular(12),
              ),

              const SizedBox(height: 15),

              // Navigate + Call
              Row(
                children: [
                  Expanded(
                    child: CustomShimmer(
                      height: 40,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomShimmer(
                      height: 40,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
