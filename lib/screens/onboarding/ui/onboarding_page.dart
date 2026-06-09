import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/base/ui/widgets/button_widget.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';
import 'package:rep_visit/core/cach/cach_manager.dart';
import 'package:rep_visit/core/network/constants/end_points.dart';
import 'package:rep_visit/screens/onboarding/providers/onboarding_provider.dart';
import 'package:rep_visit/screens/onboarding/ui/widgets/onboarding_widget.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingScreen();
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {


  @override
  Widget build(BuildContext context) {
    var onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
    return Selector<OnboardingProvider, int>(
        builder: (context, index, widget) {
          return OnboardingWidget(
              urlImage: "${EndPoints.baseUrl}/${onboardingProvider.screens[index].image}",
              title: onboardingProvider.screens[index].title,
              index: index,
              body: onboardingProvider.screens[index].body);
        },
        selector: (context, pageIndex) => pageIndex.pageIndex);
  }
}
