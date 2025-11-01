import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/asset_images.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/base/ui/widgets/button_widget.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';
import 'package:rep_visit/screens/home_screen/providers/home_provider.dart';
import 'package:rep_visit/screens/home_screen/ui/widgets/day_status_widget.dart';
import 'package:rep_visit/base/ui/widgets/main_header.dart';
import 'package:rep_visit/screens/home_screen/ui/widgets/home_shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).getSummary(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title:  MainHeader(
          title: homeProvider.title,
          subTitle: homeProvider.subTitle,
        ),
      ),
      body: Selector<HomeProvider, bool>(
          builder: (context, provider, widget) {
            return provider
                ? const HomeShimmer()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        return await homeProvider.getSummary(context);
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [

                            const SizedBox(
                              height: 30,
                            ),

                            /// Day Status
                            const DayStatusWidget(),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: todayProgress(
                                        homeProvider.completedVisits,
                                        homeProvider.percentage,
                                        homeProvider.allVisits)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: nextVisit(
                                        homeProvider.time,
                                        homeProvider.doctorName,
                                        homeProvider.address,
                                        "0",
                                        "0",
                                        "0000000"))
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: Dimensions.fullWidth(context),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.grey200),
                                  color: AppColors.grey100),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: AppColors.grey300),
                                        color: AppColors.whiteColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: SvgPicture.asset(
                                          AssetImages.locationIcon,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextWidget(
                                      "Today's Visits",
                                      textSize: 16,
                                      fontWeight: FontWeight.w700,
                                      textColor: AppColors.fontColor,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ListView.builder(
                                        padding: const EdgeInsets.all(0),
                                        shrinkWrap: true,
                                        itemCount: homeProvider.visits.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return todayVisitCard(
                                              homeProvider.visits[index].doctor,
                                              homeProvider.visits[index].address,
                                              homeProvider.visits[index].time,
                                              homeProvider.visits[index].status == "Completed",
                                              index == 1);
                                        })
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
          },
          selector: (context, selector) => selector.isLoading),
    );
  }

  /// Today Progress widget
  todayProgress(String percentage, int numOfTasks, int totalTasks) {
    return Container(
      height: Dimensions.isTablet(context) ? 230 : 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.primary500,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Section 1 (Top)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                          color: AppColors.primary100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.primary200)),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SvgPicture.asset(AssetImages.todayProgressIcon),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(6)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        child: TextWidget(
                          "${(numOfTasks/totalTasks).toInt()}%",
                          fontWeight: FontWeight.w700,
                          textColor: AppColors.whiteColor,
                          textSize: 12,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextWidget(
                  "Today's Progress",
                  fontWeight: FontWeight.bold,
                  textColor: AppColors.fontColor,
                  textSize: 16,
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),

            /// Section 2 (Bottom)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      "Visits Completed",
                      textSize: 12,
                      textColor: AppColors.typography500,
                      fontWeight: FontWeight.w400,
                    ),
                    TextWidget(
                      percentage.toString(),
                      textSize: 12,
                      textColor: AppColors.mainColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: numOfTasks / totalTasks,
                    minHeight: 8,
                    backgroundColor: AppColors.primary100,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.mainColor),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// Next Visit widget
  nextVisit(String time, String doctorName, String hospital, String lat,
      String long, String callNumber) {
    String formattedTime = time.substring(0, 5);
    return Container(
      height: Dimensions.isTablet(context) ? 230 : 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.success50,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 12, right: 12, left: 12, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                          color: AppColors.success100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.success200)),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SvgPicture.asset(AssetImages.nextVisitIcon),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(6)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        child: TextWidget(
                          formattedTime,
                          fontWeight: FontWeight.w700,
                          textColor: AppColors.whiteColor,
                          textSize: 12,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextWidget(
                  "Next Visit",
                  fontWeight: FontWeight.bold,
                  textColor: AppColors.fontColor,
                  textSize: 16,
                ),
              ],
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Doctor name
                TextWidget(
                  doctorName,
                  textSize: 12,
                  textColor: AppColors.typography500,
                  fontWeight: FontWeight.bold,
                ),

                /// Hospital name
                TextWidget(
                  hospital,
                  textSize: 12,
                  textColor: AppColors.typography500,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                        child: ButtonWidget(
                      height: 32,
                      text: "Navigate",
                      onTap: () {
                        openGoogleMap(double.parse(lat), double.parse(long));
                      },
                      borderRadius: 8,
                      textColor: AppColors.whiteColor,
                      backgroundColor: AppColors.success,
                    )),
                    const SizedBox(
                      width: 12,
                    ),
                    InkWell(
                      onTap: () {
                        makePhoneCall(callNumber);
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.success)),
                        child: Icon(
                          Icons.phone_outlined,
                          color: AppColors.success,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// Today's visit card
  todayVisitCard(String doctorName, String address, String time,
      bool isCompleted, bool isNext) {
    String formattedTime = time.substring(0, 5);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        width: Dimensions.fullWidth(context),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.whiteColor),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: Dimensions.fullWidth(context)*0.4,
                    child: TextWidget(
                      doctorName,
                      textSize: 16,
                      fontWeight: FontWeight.bold,
                      textColor: AppColors.fontColor,
                      maxLine: 1,
                    ),
                  ),
                  Row(
                    children: [
                      isNext
                          ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColors.success100),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 3),
                          child: Row(
                            children: [
                              TextWidget(
                                "Next Visit",
                                textSize: 12,
                                fontWeight: FontWeight.w700,
                                textColor: AppColors.success,
                              )
                            ],
                          ),
                        ),
                      )
                          : const SizedBox(),
                      SizedBox(
                        width: isNext ? 5 : 0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: isCompleted
                                ? AppColors.primary400
                                : AppColors.black),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 3),
                          child: Row(
                            children: [
                              isCompleted
                                  ? Icon(
                                Icons.check,
                                color: AppColors.whiteColor,
                                size: 16,
                              )
                                  : const SizedBox(),
                              SizedBox(
                                width: isCompleted ? 4 : 0,
                              ),
                              TextWidget(
                                formattedTime,
                                textSize: 12,
                                fontWeight: FontWeight.w700,
                                textColor: AppColors.whiteColor,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              TextWidget(
                address,
                textSize: 16,
                fontWeight: FontWeight.w400,
                textColor: AppColors.typography500,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Open google map
  Future<void> openGoogleMap(double latitude, double longitude) async {
    final Uri googleMapUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open Google Maps.';
    }
  }

  /// Makes a phone call
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not make the call.';
    }
  }
}
