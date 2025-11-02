import 'package:flutter/material.dart';
import '../../../../base/constants/app_colors.dart';
import '../../../../base/ui/widgets/shimmer_widget.dart';

class DoctorCardShimmer extends StatelessWidget {
  const DoctorCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context,index){
          return ShimmerCard();
        }),
      ),
    );

  }
}
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
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


            /// Name + speciality
            const CustomShimmer(width: 120, height: 14),
            const SizedBox(height: 6),
            const CustomShimmer(width: 80, height: 12),
            const SizedBox(height: 12),

            /// Hospital + address
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                CustomShimmer(width: 100, height: 12),
                CustomShimmer(width: 100, height: 12),
              ],
            ),
            const SizedBox(height: 12),

            /// Available time + last visit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                CustomShimmer(width: 120, height: 20),
                CustomShimmer(width: 100, height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

