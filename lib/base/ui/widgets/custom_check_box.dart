import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class CustomCheckBox extends StatelessWidget {
  final bool isChecked;
  final void Function(bool?) checkboxCallback;


  const CustomCheckBox(
      {Key? key,
        required this.checkboxCallback,
        required this.isChecked,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return AppColors.whiteColor;
      }
      return AppColors.whiteColor;
    }

    return SizedBox(
        height: 26,
        width: 26,
        child: Checkbox(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          checkColor:
          AppColors.mainColor,
          activeColor: AppColors.grey200,
          side: WidgetStateBorderSide.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return  BorderSide(color: AppColors.mainColor, width: 1); // checked
            }
            return BorderSide(color: AppColors.grey300, width: 1);   // unchecked
          }),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.grey200; // background when checked
            }
            return Colors.transparent;  // background when unchecked
          }),
          value: isChecked,
          onChanged: checkboxCallback,
        ));
  }
}
// (bool? value) {
// isChecked = value!;
// }
