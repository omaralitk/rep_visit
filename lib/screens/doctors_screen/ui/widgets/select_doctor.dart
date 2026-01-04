import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/screens/doctors_screen/providers/doctors_provider.dart';
import 'package:rep_visit/screens/doctors_screen/ui/widgets/from_list_doctor.dart';
import 'package:rep_visit/screens/doctors_screen/ui/widgets/add_new_doctor_form.dart';

import '../../../../base/constants/app_colors.dart';
import '../../../../base/constants/dimensions.dart';
import '../../../../base/ui/widgets/text_widget.dart';

class SelectDoctor extends StatefulWidget {
  const SelectDoctor({super.key});

  @override
  State<SelectDoctor> createState() => _SelectDoctorState();
}

class _SelectDoctorState extends State<SelectDoctor> {
  @override
  void initState() {
    super.initState();
    // Load filters when the bottom sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var doctorProvider = Provider.of<DoctorsProvider>(context, listen: false);
      if (doctorProvider.categories.isEmpty ||
          doctorProvider.specialities.isEmpty ||
          doctorProvider.areas.isEmpty) {
        await doctorProvider.getFilters();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var doctorProvider = Provider.of<DoctorsProvider>(context, listen: false);
    return Container(
      width: Dimensions.fullWidth(context),
      height: Dimensions.fullHeight(context) * 0.9,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary500,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xffD7D9F2)),
              ),
              child: Row(
                children: [
                  _tabItem("From List".tr(), 0, doctorProvider),
                  _tabItem("Add New".tr(), 1, doctorProvider),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Selector<DoctorsProvider, int>(
                  builder: (context, provider, widget) {
                    switch (provider) {
                      case 0:
                        return const FromListDoctor();
                      case 1:
                        return const AddNewDoctorForm();
                      default:
                        return const SizedBox();
                    }
                  },
                  selector: (context, selector) => selector.selectedIndex),
            )
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String title, int index, DoctorsProvider provider) {
    return Selector<DoctorsProvider, int>(
        builder: (context, indexProvider, widget) {
          bool isSelected = indexProvider == index;
          return Expanded(
            child: InkWell(
              onTap: () {
                provider.setSelectedTap(index);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected ? AppColors.whiteColor : Colors.transparent,
                ),
                child: Center(
                  child: TextWidget(
                    title,
                    textSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    textColor: isSelected
                        ? AppColors.mainColor
                        : AppColors.typography700,
                  ),
                ),
              ),
            ),
          );
        },
        selector: (context, selector) => selector.selectedIndex);
  }
}
