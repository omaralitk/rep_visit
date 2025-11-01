import 'package:flutter/cupertino.dart';
import 'package:rep_visit/screens/onboarding/models/onboarding_model.dart';
import 'package:rep_visit/screens/onboarding/repo/onboarding_repo.dart';

import '../../../core/navigation_service/navigation_service.dart';
import '../ui/onboarding_page.dart';

class OnboardingProvider extends ChangeNotifier {
  OnboardingRepository _onboardingRepository = OnboardingRepository();
  int _pageIndex = 0;

  int get pageIndex => _pageIndex;

  setPageIndex(int val) {
    _pageIndex = val;
    notifyListeners();
  }

  List<OnboardingScreens> screens = [];

  getOnboarding(BuildContext context) {
    _onboardingRepository.getOnboardingScreens().then((val) {
      if (val?.status == 1) {
        screens = val?.data ?? [];
        NavigationService.pushAndRemoveUntil(context, const OnboardingPage());
      }else{
        screens = [];
      }

    });
    notifyListeners();
  }
}
