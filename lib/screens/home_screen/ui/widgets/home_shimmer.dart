import 'package:flutter/material.dart';

import '../../../../base/ui/widgets/shimmer_widget.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            const CustomShimmer(width: 200, height: 14),
            const SizedBox(height: 30),
            const CustomShimmer(height: 100),
            const SizedBox(height: 10),
            Row(
              children: const [
                Expanded(child: CustomShimmer(height: 120)),
                SizedBox(width: 10),
                Expanded(child: CustomShimmer(height: 120)),
              ],
            ),
            const SizedBox(height: 15),
            Column(
              children: List.generate(
                4,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      const CustomShimmer(width: 42, height: 42),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            CustomShimmer(width: 100, height: 12),
                            SizedBox(height: 6),
                            CustomShimmer(width: 150, height: 10),
                          ],
                        ),
                      ),
                    ],
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
