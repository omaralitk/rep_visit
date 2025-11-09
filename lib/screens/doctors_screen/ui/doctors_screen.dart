import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/ui/widgets/main_header.dart';
import 'package:rep_visit/base/ui/widgets/shared_text_form_field.dart';
import 'package:rep_visit/screens/doctors_screen/providers/doctors_provider.dart';
import 'package:rep_visit/screens/doctors_screen/ui/widgets/doctors_shimmer.dart';

import '../../../base/constants/app_colors.dart';
import '../../../base/constants/asset_images.dart';
import '../../../base/constants/dimensions.dart';
import '../../../base/ui/widgets/text_widget.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DoctorsPage();
  }
}

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((v) async {
      var doctorsProvider =
          Provider.of<DoctorsProvider>(context, listen: false);
      await doctorsProvider.getDoctorsList();

    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    var provider = Provider.of<DoctorsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: MainHeader(
            title: "My Doctors",
            subTitle: "Manage your doctor assignments and generate reports"),
      ),
      body: Selector<DoctorsProvider, bool>(
          builder: (context, doctorProvider, widget) {
            return doctorProvider
                ? const DoctorCardShimmer()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: SharedTextFormField(
                                      label: "",
                                      hint: "Search",
                                      controller: searchController),
                              ),
                             const SizedBox(width: 12,),
                              Container(height: 56,
                              width: 85,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.grey300)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.grey300),
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: SvgPicture.asset(AssetImages.filterIcon),
                                      )),
SizedBox(width: 5,),
                                  Icon(Icons.arrow_drop_down,color: AppColors.grey500,)
                                ],
                              ),)
                            ],
                          ),
                          SizedBox(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: provider.doctorsList.length,
                                itemBuilder: (context, index) {

                                  return doctorSection(index, provider);
                                }),
                          )
                        ],
                      ),
                    ),
                  );
          },
          selector: (context, selector) => selector.isLoading),
    );
  }

  doctorSection(int index, DoctorsProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border.all(color: AppColors.grey200),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header widget
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary100),
                    ),
                    clipBehavior: Clip.antiAlias, // important for rounded corners
                    child: CachedNetworkImage(
                      imageUrl: provider.doctorsList[index].image ?? "",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.mainColor,
                        ),
                      ),
                      errorWidget: (context, url, error) => SvgPicture.asset(
                        AssetImages.emptyImage, // your fallback SVG or PNG
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Container(
                        width: 33,
                        height: 33,
                        decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: TextWidget(
                            provider.doctorsList[index].datumClass??"",
                            textSize: 12,
                            fontWeight: FontWeight.w700,
                            textColor: AppColors.whiteColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      Icon(
                        Icons.star,
                        color: AppColors.starColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      TextWidget(
                        provider.doctorsList[index].rating??"",
                        textSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.typography500,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),

              /// Name of doctor
              TextWidget(
                provider.doctorsList[index].name??"",
                textSize: 16,
                fontWeight: FontWeight.w700,
                textColor: AppColors.fontColor,
              ),
              TextWidget(
                provider.doctorsList[index].speciality??"",
                textSize: 12,
                fontWeight: FontWeight.w500,
                textColor: AppColors.typography500,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AssetImages.hospitalIcon),
                      const SizedBox(
                        width: 5,
                      ),
                      TextWidget(
                        provider.doctorsList[index].hospitalName??"",
                        textSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.typography500,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AssetImages.mapPin),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: Dimensions.fullWidth(context) * 0.3,
                        child: TextWidget(
                          provider.doctorsList[index].address??"",
                          textSize: 12,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.typography500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SvgPicture.asset(AssetImages.timerIcon),
                      Icon(
                        Icons.access_time_rounded,
                        color: AppColors.mainColor,
                        size: 22,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 22,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: AppColors.whiteColor,
                                size: 16,
                              ),
                              TextWidget(
                                provider.doctorsList[index].availableTime??"",
                                textSize: 12,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.whiteColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AssetImages.scheduleIcon),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: Dimensions.fullWidth(context) * 0.3,
                        child: TextWidget(
                          "Last visit: ${provider.doctorsList[index].lastVisit}",
                          textSize: 12,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.typography500,
                        ),
                      ),
                    ],
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
