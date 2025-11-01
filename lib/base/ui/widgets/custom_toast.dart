import 'package:flutter/material.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';

class ToastService {
  static OverlayEntry? _currentToast;

  static void showToast(
      BuildContext context,
      String message, {
        Color backgroundColor = Colors.black87,
        Color textColor = Colors.white,
        Duration duration = const Duration(seconds: 3),
      }) {
    if (message.isEmpty) return;

    // Remove any active toast first
    _currentToast?.remove();

    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 40,
        left: 0,
        right: 0,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Material(
              color: Colors.transparent,
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                width: Dimensions.fullWidth(context)*0.7,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow:const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset:  Offset(0, -2),
                    )
                  ],
                ),
                child: TextWidget(
                  message,
                  textSize: 14,
                  textColor: textColor,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w700,

                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    _currentToast = overlayEntry;

    // Remove after duration
    Future.delayed(duration, () {
      _currentToast?.remove();
      _currentToast = null;
    });
  }

  static void showSuccess(BuildContext context, String message) {
    showToast(
      context,
      message,
      textColor: AppColors.fontColor,
      backgroundColor: AppColors.whiteColor,
    );
  }

  static void showError(BuildContext context, String message) {
    showToast(
      context,
      message,
      backgroundColor: Colors.red.shade700,
    );
  }

  static void showInfo(BuildContext context, String message) {
    showToast(
      context,
      message,
      backgroundColor: Colors.blue.shade600,
    );
  }
}
