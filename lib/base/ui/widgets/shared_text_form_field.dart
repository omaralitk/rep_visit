import 'package:flutter/material.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';

class SharedTextFormField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final ValueChanged? onSubmitted;
  final FocusNode? focusNode;
  const SharedTextFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.onSubmitted,
    this.focusNode
  });

  @override
  State<SharedTextFormField> createState() => _SharedTextFormFieldState();
}

class _SharedTextFormFieldState extends State<SharedTextFormField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label.isNotEmpty? TextWidget(
          widget.label,
          textSize: 14,
          fontWeight: FontWeight.w500,

        ):const SizedBox(),
         SizedBox(height:  widget.label.isNotEmpty?6:0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.whiteColor
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscure : false,
            decoration: InputDecoration(

              hintText: widget.hint,
              hintStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.typography400
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.grey300, width: 1),
                // unfocused
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.mainColor, width: 1), // focused
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),

              ),

              suffixIcon: widget.isPassword
                  ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
                  : null,
            ),
            focusNode: widget.focusNode,
            onFieldSubmitted: widget.onSubmitted,
          ),
        ),
      ],
    );
  }
}
