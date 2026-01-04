import 'package:flutter/material.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final double height;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ---------- LABEL ----------
        TextWidget(
          label,
          textSize: 14,
          fontWeight: FontWeight.w500,
          textColor: AppColors.fontColor,
        ),
        const SizedBox(height: 5),

        /// ---------- DROPDOWN ----------
        Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              hint: TextWidget(
                hint,
                textColor: AppColors.typography500,
                textSize: 14,
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
