import 'package:flutter/material.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import '../../../../base/ui/widgets/shimmer_widget.dart';

class ReportsShimmerScreen extends StatelessWidget {
  const ReportsShimmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60,
              ),
              const SizedBox(height: 20),
              const CustomShimmer(width: 120, height: 20),
              const SizedBox(height: 8),

              const Row(
                children: [
                  CustomShimmer(width: 42, height: 42),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomShimmer(width: 120, height: 16),
                        SizedBox(height: 8),
                        CustomShimmer(width: 80, height: 12),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),

              /// Two cards (Visits + Duration)
              const Row(
                children: [
                  Expanded(child: _ShimmerCard()),
                  SizedBox(width: 10),
                  Expanded(child: _ShimmerCard()),
                ],
              ),
              const SizedBox(height: 15),

              /// Distance Card
              const _ShimmerCard(),
              const SizedBox(height: 15),

              /// Notes Section
              Container(
                width: Dimensions.fullWidth(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.grey100,
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      CustomShimmer(width: 100, height: 16),
                      SizedBox(height: 12),
                      CustomShimmer(height: 48),
                      SizedBox(height: 8),
                      CustomShimmer(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const CustomShimmer(),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShimmer(width: 60, height: 16),
                  SizedBox(height: 6),
                  CustomShimmer(width: 80, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
