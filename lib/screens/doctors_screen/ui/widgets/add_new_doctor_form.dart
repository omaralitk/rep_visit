import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../base/constants/app_colors.dart';
import '../../../../base/constants/asset_images.dart';
import '../../../../base/ui/widgets/custom_drop_down.dart';
import '../../../../base/ui/widgets/shared_text_form_field.dart';
import '../../../../base/ui/widgets/text_widget.dart';
import '../../providers/doctors_provider.dart';
import '../../../location_picker/ui/location_picker_screen.dart';

class AddNewDoctorForm extends StatefulWidget {
  const AddNewDoctorForm({super.key});

  @override
  State<AddNewDoctorForm> createState() => _AddNewDoctorFormState();
}

class _AddNewDoctorFormState extends State<AddNewDoctorForm> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _selectedSpeciality;
  String? _selectedCategory;
  String? _selectedArea;

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _hospitalController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Ensure filters are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<DoctorsProvider>(context, listen: false);
      if (provider.categories.isEmpty ||
          provider.specialities.isEmpty ||
          provider.areas.isEmpty) {
        await provider.getFilters();
      }
    });
  }

  List<String> _getSpecialities(DoctorsProvider provider) {
    return [
      'Select specialty'.tr(),
      ...provider.specialities.map((e) => e.label)
    ];
  }

  List<String> _getCategories(DoctorsProvider provider) {
    return ['Select category'.tr(), ...provider.categories.map((e) => e.label)];
  }

  List<String> _getAreas(DoctorsProvider provider) {
    return ['Select area'.tr(), ...provider.areas.map((e) => e.label)];
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _canSubmit(DoctorsProvider provider) {
    final specialities = _getSpecialities(provider);
    final categories = _getCategories(provider);
    final areas = _getAreas(provider);

    // final phoneNotEmpty = _phoneController.text.trim().isNotEmpty;
    // final emailNotEmpty = _emailController.text.trim().isNotEmpty;
    final emailValid = _isValidEmail(_emailController.text.trim());

    return _nameController.text.isNotEmpty &&
        
        _addressController.text.isNotEmpty &&
        _selectedSpeciality != null &&
        _selectedSpeciality != specialities.first &&
        _selectedCategory != null &&
        _selectedCategory != categories.first


        ;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorsProvider>(
      builder: (context, provider, _) {
        final specialities = _getSpecialities(provider);
        final categories = _getCategories(provider);
        final areas = _getAreas(provider);

        return Column(
          children: [
            // Scrollable form fields
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SharedTextFormField(
                      label: 'Dr Name*'.tr(),
                      hint: 'Enter Dr name'.tr(),
                      controller: _nameController,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    CustomDropdown(
                      label: 'Specialty*'.tr(),
                      hint: 'Select specialty'.tr(),
                      items: specialities,
                      value: _selectedSpeciality,
                      onChanged: (value) {
                        setState(() {
                          _selectedSpeciality = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    SharedTextFormField(
                      label: 'Hospital'.tr(),
                      hint: 'Enter hospital name'.tr(),
                      controller: _hospitalController,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdown(
                            label: 'Category*'.tr(),
                            hint: 'Select category'.tr(),
                            items: categories,
                            value: _selectedCategory,
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomDropdown(
                            label: 'Area'.tr(),
                            hint: 'Select area'.tr(),
                            items: areas,
                            value: _selectedArea,
                            onChanged: (value) {
                              setState(() {
                                _selectedArea = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: SharedTextFormField(
                            label: 'Address*'.tr(),
                            hint: 'Select address from map or type manually...'
                                .tr(),
                            controller: _addressController,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () async {
                            final result =
                                await Navigator.of(context).push<String>(
                              MaterialPageRoute(
                                builder: (_) => const LocationPickerScreen(),
                              ),
                            );
                            if (result != null && result.isNotEmpty) {
                              setState(() {
                                _addressController.text = result;
                              });
                            }
                          },
                          child: Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.grey300),
                              color: AppColors.whiteColor,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                AssetImages.locationIcon,
                                width: 22,
                                height: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SharedTextFormField(
                            label: 'Phone'.tr(),
                            hint: 'Enter Dr phone'.tr(),
                            controller: _phoneController,
                            textInputType: TextInputType.phone,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SharedTextFormField(
                            label: 'Email'.tr(),
                            hint: 'Enter Dr email'.tr(),
                            controller: _emailController,
                            textInputType: TextInputType.emailAddress,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Fixed buttons at bottom
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.grey300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.whiteColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: TextWidget(
                        'Cancel'.tr(),
                        textSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.typography700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canSubmit(provider)
                            ? AppColors.mainColor
                            : AppColors.grey200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      onPressed: _canSubmit(provider)
                          ? () async {
                              await provider.addDoctorRequestFromForm(
                                name: _nameController.text,
                                hospitalName: _hospitalController.text??"",
                                address: _addressController.text,
                                specialty: _selectedSpeciality ?? "",
                                category: _selectedCategory ?? "",
                                area: _selectedArea ?? "",
                                phone: _phoneController.text.isNotEmpty
                                    ? _phoneController.text
                                    : "",
                                email: _emailController.text.isNotEmpty
                                    ? _emailController.text
                                    : "",
                              );

                              if (context.mounted && !provider.isLoading && provider.successAdd) {
                                Navigator.of(context).pop();
                              }
                            }
                          : null,
                      child: TextWidget(
                        'Submit'.tr(),
                        textSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: _canSubmit(provider)
                            ? AppColors.whiteColor
                            : AppColors.typography400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
