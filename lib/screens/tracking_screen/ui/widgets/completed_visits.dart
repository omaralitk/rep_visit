import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/ui/widgets/no_data_widget.dart';
import 'package:rep_visit/base/ui/widgets/shared_text_form_field.dart';
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
                  "Completed Visits",
                  textSize: 16,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.success,
                ),
                TextWidget(
                  "${completedProvider.completedVisits.length} visits completed today",
                  textSize: 12,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.success,
                  textAlign: TextAlign.start,
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
            : const NoDataWidget(
                title: "You don't have any completed visits for today")
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
                        provider.completedVisits[index].doctor.name ?? "",
                        textSize: 16,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.fontColor,
                      ),
                      TextWidget(
                        provider.completedVisits[index].doctor.hospitalName,
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
                      provider.completedVisits[index].totalDuration??"",
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
                  TextWidget(
                    provider.completedVisits[index].doctor.address,
                    textSize: 12,
                    fontWeight: FontWeight.w300,
                    textColor: AppColors.typography500,
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              // Button

              const SizedBox(
                height: 10,
              ),
              Container(
                height: 58,
              ),
              const SizedBox(
                height: 10,
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
                        SizedBox(
                          width: 5,
                        ),
                        TextWidget(
                          "Check in: 10:32 AM",
                          textSize: 12,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.fontColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AssetImages.noData,
                          width: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        TextWidget(
                          "Check out: 11:32 AM",
                          textSize: 12,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.fontColor,
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
