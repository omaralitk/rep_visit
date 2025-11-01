import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/asset_images.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/base/ui/widgets/main_header.dart';
import 'package:rep_visit/base/ui/widgets/shared_text_form_field.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:rep_visit/screens/reports/provider/reports_provider.dart';
import 'package:rep_visit/screens/reports/ui/widgets/reports_shimmer.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReportsPage();
  }
}

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  late ReportsProvider reportsProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((v) async {
      reportsProvider = Provider.of<ReportsProvider>(context, listen: false);
      await reportsProvider.getReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ReportsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title:

            MainHeader(
          title: "Reports",
          subTitle: "View and export your activity reports",
        ),
      ),
      body: Selector<ReportsProvider, bool>(
          builder: (context, loading, widget) {
            return loading
                ? const ReportsShimmerScreen()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: AppColors.grey300)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      SvgPicture.asset(AssetImages.reportsIcon),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    "Daily Report",
                                    textSize: 16,
                                    fontWeight: FontWeight.w700,
                                    textColor: AppColors.fontColor,
                                  ),
                                  TextWidget(
                                    provider.date,
                                    textSize: 12,
                                    fontWeight: FontWeight.w500,
                                    textColor: AppColors.typography500,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              visitsWidget(provider.visits),
                              const SizedBox(
                                width: 10,
                              ),
                              durationWidget(provider.duration)
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              distanceTraveledWidget(provider.distance)
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          notesWidget("Hello Comment")
                        ],
                      ),
                    ),
                  );
          },
          selector: (context, selector) => selector.isLoading),
    );
  }

  /// Duration Widget
  durationWidget(String duration) {
    return Expanded(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.success50,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
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
                      child: SvgPicture.asset(AssetImages.durationIcon),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      TextWidget(
                        duration,
                        textSize: 16,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.fontColor,
                      ),
                      const TextWidget(
                        "Duration",
                        textSize: 12,
                        fontWeight: FontWeight.w500,
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Number of visits widget
  visitsWidget(int visits) {
    return Expanded(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primary500,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
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
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    "$visits",
                    fontWeight: FontWeight.w700,
                    textColor: AppColors.fontColor,
                    textSize: 16,
                  ),
                  TextWidget(
                    "Visits",
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.typography500,
                    textSize: 12,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Distance traveled widget
  distanceTraveledWidget(String distance) {
    return Expanded(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.info50,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: AppColors.info100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary200)),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: SvgPicture.asset(AssetImages.addressIcon),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    distance,
                    fontWeight: FontWeight.w700,
                    textColor: AppColors.fontColor,
                    textSize: 16,
                  ),
                  TextWidget(
                    "Distance traveled",
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.typography500,
                    textSize: 12,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Notes Widget
  notesWidget(String latestComment) {
    return Container(
      width: Dimensions.fullWidth(context),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.grey100,
          border: Border.all(color: AppColors.grey200)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              "Notes",
              textSize: 16,
              fontWeight: FontWeight.w700,
              textColor: AppColors.fontColor,
            ),
            const SizedBox(
              height: 12,
            ),
            SharedTextFormField(
              label: "",
              hint: "Enter Your Note",
              controller: TextEditingController(),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey300)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      latestComment,
                      textSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.typography700,
                    ),
                    Icon(
                      Icons.delete_outlined,
                      color: AppColors.red,
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
