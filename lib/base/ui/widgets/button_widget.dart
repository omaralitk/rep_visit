import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {super.key,
      this.height,
      this.width,
      this.borderRadius,
      this.backgroundColor,
      required this.text,
      this.textColor,
      this.textSize,
      this.fontWeight,
      required this.onTap,
      this.icon,
      this.svgWidth,
      this.borderColor});

  final double? height;
  final double? width;
  final double? borderRadius;
  final Color? backgroundColor;
  final String text;
  final Color? textColor;
  final double? textSize;
  final FontWeight? fontWeight;
  final Function onTap;
  final Widget? icon;
  final double? svgWidth;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: height ?? 44,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(
              color: borderColor != null ? borderColor! : Colors.transparent,
              width: borderColor != null ? 1 : 0),
          color: backgroundColor ?? AppColors.mainColor,
          // boxShadow: [
          // BoxShadow(
          //   color: Colors.grey.withOpacity(0.1),
          //   spreadRadius: 5,
          //   blurRadius: 7,
          //   offset: const Offset(0, 3),
          // ),
          // ],
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
        child: Center(
          child: icon != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon ?? const SizedBox(),
                    const SizedBox(
                      width: 5,
                    ),
                    TextWidget(
                      text,
                      textColor: textColor ?? AppColors.whiteColor,
                      textSize: textSize ?? 14,
                      fontWeight: fontWeight,
                    ),


                  ],
                )
              : TextWidget(
                  text,
                  textColor: textColor,
                  textSize: textSize ?? 14,
                  fontWeight: fontWeight ?? FontWeight.w700,
                ),
        ),
      ),
      onTap: () => onTap(),
    );
  }
}
