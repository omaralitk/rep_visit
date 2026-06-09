import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/base/ui/widgets/no_data_widget.dart';
import 'package:rep_visit/screens/tracking_screen/provider/tracking_provider.dart';

import '../../../../base/constants/app_colors.dart';
import '../../../../base/constants/asset_images.dart';
import '../../../../base/ui/widgets/text_widget.dart';

class CompletedVisits extends StatefulWidget {
  const CompletedVisits({super.key});

  @override
  State<CompletedVisits> createState() => _CompletedVisitsState();
}

class _CompletedVisitsState extends State<CompletedVisits> {
  @override
  Widget build(BuildContext context) {
    var completedProvider =
        Provider.of<TrackingProvider>(context, listen: false);
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.success)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.check,
                  color: AppColors.success,
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  "Completed Visits".tr(),
                  textSize: 16,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.success,
                ),
                Row(
                  children: [
                    TextWidget(
                      "${completedProvider.completedVisits.length} ",
                      textSize: 12,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.success,
                      textAlign: TextAlign.start,
                    ),
                    TextWidget(
                      "visits completed today".tr(),
                      textSize: 12,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.success,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        completedProvider.completedVisits.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: completedProvider.completedVisits.length,
                itemBuilder: (context, index) {
                  return visitSection(completedProvider, index);
                })
            : NoDataWidget(
                title: "You don't have any completed visits for today".tr())
      ],
    );
  }

  visitSection(TrackingProvider provider, int index) {
    TextEditingController controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.success)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        provider.completedVisits[index].doctor?.name ?? "",
                        textSize: 16,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.fontColor,
                      ),
                      TextWidget(
                        provider.completedVisits[index].doctor?.hospitalName??"",
                        textSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.typography500,
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: TextWidget(
                      '${provider.completedVisits[index].totalDuration}' ?? "",
                      textSize: 12,
                      textColor: AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SvgPicture.asset(AssetImages.locationIcon),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextWidget(
                      provider.completedVisits[index].doctor?.address??"",
                      textSize: 12,
                      fontWeight: FontWeight.w300,
                      textColor: AppColors.typography500,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: List.generate(5, (i) {
                  final starIndex = i + 1;
                  final ratingString =
                      provider.completedVisits[index].doctor?.rating;
                  final rating = ratingString != null && ratingString.isNotEmpty
                      ? (double.tryParse(ratingString) ?? 0.0)
                      : 0.0;

                  final filled = starIndex <= rating;

                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: filled ? AppColors.starColor : AppColors.grey100,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: Icon(
                      filled ? Icons.star : Icons.star_border,
                      size: 18,
                      color: filled
                          ? AppColors.whiteColor
                          : AppColors.typography500,
                    ),
                  );
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: Dimensions.fullWidth(context),
                decoration: BoxDecoration(
                    color: AppColors.grey100,
                    border: Border.all(
                      color: AppColors.grey300,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextWidget(
                    provider.completedVisits[index].notes??"",
                    textSize: 15,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.typography500,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AssetImages.noData,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Row(
                          children: [
                            TextWidget(
                              "Check in: ".tr(args: [
                              ]),
                              textSize: 12,
                              fontWeight: FontWeight.w500,
                              textColor: AppColors.fontColor,
                            ),  TextWidget(
                              provider.completedVisits[index].visitTime
                                  ??
                                  "",
                              textSize: 12,
                              fontWeight: FontWeight.w500,
                              textColor: AppColors.fontColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AssetImages.noData,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              TextWidget(
                                "Check out: ".tr(),
                                textSize: 12,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.fontColor,
                              ),
                              TextWidget(
                                provider.completedVisits[index].endTime??
                                    "",
                                textSize: 12,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.fontColor,
                              ),
                            ],
                          ),
                        ),
                      ],
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
