import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';
import 'package:rep_visit/core/lang_service/lang_service.dart';

class LangSwitcher extends StatelessWidget {
  const LangSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        LangService.changeLang(context);
      },
      child: TextWidget(
        context.locale == const Locale("en") ? "EN" : "AR",
        textSize: 14,
        textColor: AppColors.mainColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
