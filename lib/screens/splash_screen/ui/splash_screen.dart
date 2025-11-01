import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/asset_images.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';
import 'package:rep_visit/core/cach/cach_manager.dart';
import 'package:rep_visit/core/navigation_service/navigation_service.dart';
import 'package:rep_visit/screens/login_screen/ui/login_screen.dart';
import 'package:rep_visit/screens/onboarding/providers/onboarding_provider.dart';
import 'package:rep_visit/screens/onboarding/ui/onboarding_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Future _initFuture;
  late Timer _timer;

  @override
  void initState() {
    _initFuture = _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) => Stack(
          children: [
            Center(
              child: SvgPicture.asset(AssetImages.splashLogo),
            ),
            Positioned(
                bottom: 20,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    TextWidget(
                      "RepVisit",
                      textSize: 16,
                      textColor: AppColors.fontColor,
                      fontWeight: FontWeight.bold,
                    ),
                    const TextWidget("Medical Representative Tracking App",
                        textColor: Colors.grey,
                        textSize: 16,
                        fontWeight: FontWeight.w600),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 4));
    bool route = await UserCache.getOnBoarding();

    if (!mounted) return;
    if (!route) {
      final onboardingProvider =
          Provider.of<OnboardingProvider>(context, listen: false);
      onboardingProvider.getOnboarding(context);
    } else {
      NavigationService.pushAndRemoveUntil(context, const LoginPage());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
