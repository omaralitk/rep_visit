import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/core/cach/cach_manager.dart';
import 'package:rep_visit/screens/onboarding/providers/onboarding_provider.dart';

import '../../../../base/constants/app_colors.dart';
import '../../../../base/constants/dimensions.dart';
import '../../../../base/ui/widgets/button_widget.dart';
import '../../../../base/ui/widgets/text_widget.dart';
import '../../../../core/navigation_service/navigation_service.dart';
import '../../../login_screen/ui/login_screen.dart';

class OnboardingWidget extends StatefulWidget {
  final String urlImage;
  final String title;
  final List<String> body;
  final int index;

  const OnboardingWidget(
      {super.key,
      required this.urlImage,
      required this.title,
      required this.index,
      required this.body});

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  @override
  Widget build(BuildContext context) {
    var onboardingProvider =
    Provider.of<OnboardingProvider>(context,
        listen: false);
    return Scaffold(
      body: SizedBox(
        height: Dimensions.fullHeight(context),
        child: Column(
          children: [
            SizedBox(
              width: Dimensions.fullWidth(context),
              height: Dimensions.fullHeight(context) * 0.5,

              child: Image.network(widget.urlImage,fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                },
              ),
            ),

            SizedBox(
              height: Dimensions.fullHeight(context) * 0.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 4,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Container(
                                    height: 4,
                                    width: 30,
                                  decoration: BoxDecoration(
                                    color: index != onboardingProvider.pageIndex
                                        ? AppColors.grey200
                                        : AppColors.mainColor,
                                    borderRadius: BorderRadius.circular(2)
                                  ),
                                  ),
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        ///Title
                        TextWidget(
                          widget.title,
                          textColor: AppColors.fontColor,
                          textSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                          padding:const  EdgeInsets.all(0),
                            shrinkWrap: true,
                            itemCount: widget.body.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:const EdgeInsets.only(bottom: 4.0),
                                child: TextWidget(widget.body[index],textSize: 14,),
                              );
                            }),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        children: [

                          onboardingProvider.pageIndex == 2?const SizedBox():Expanded(
                            child: ButtonWidget(
                              text: "Skip",

                              backgroundColor: AppColors.whiteColor,
                              borderColor: AppColors.grey200,
                              onTap: () async{
                                await UserCache.setOnBoarding(true);
                                NavigationService.pushAndRemoveUntil(
                                    const LoginScreen());
                              },
                            ),
                          ),
                          onboardingProvider.pageIndex == 2?const SizedBox():  const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ButtonWidget(
                              text: onboardingProvider.pageIndex == 2?"Get Started":"Next",
                              onTap: () async {

                                if (onboardingProvider.pageIndex < 2) {
                                  onboardingProvider.setPageIndex(
                                      onboardingProvider.pageIndex + 1);
                                } else {
                                  await UserCache.setOnBoarding(true);
                                  NavigationService.pushAndRemoveUntil(
                                      const LoginScreen());
                                }
                              },
                              textColor: AppColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
