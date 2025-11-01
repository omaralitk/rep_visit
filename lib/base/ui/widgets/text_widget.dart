import 'package:flutter/material.dart';
import 'package:rep_visit/base/constants/dimensions.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
      this.text, {
        super.key,
        this.style,
        required this.textSize,
        this.textColor,
        this.fontWeight,
        this.height,
        this.underline = false,
        this.overflow,
        this.maxLine,
        this.textAlign,
      });

  final String text;
  final TextStyle? style;
  final double textSize;
  final Color? textColor;
  final FontWeight? fontWeight;
  final double? height;
  final bool underline;
  final TextOverflow? overflow;
  final int? maxLine;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final width = Dimensions.fullWidth(context);

    return Text(
      text,
      maxLines: maxLine,
      textAlign: textAlign,
      style: style ??
          TextStyle(
            fontSize: width >= 700 ? ((textSize ?? 0) + 4) : textSize,
            color: textColor,
            fontWeight: fontWeight,
            fontFamily: 'Manrope',
            height: height??0,
            overflow: overflow,

            decoration:

            underline ? TextDecoration.underline : TextDecoration.none,
          ),
    );
  }
}
