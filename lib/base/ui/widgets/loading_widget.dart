import 'package:flutter/material.dart';

import '../../../core/navigation_service/navigation_service.dart';

class LoadingWidget {
  static void show() {
    showDialog(
      context: NavigationService.navigatorKey.currentContext!,
      barrierDismissible:false,
      builder: (context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Center(
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }

  static void hide() {
    Navigator.of(NavigationService.navigatorKey.currentContext!, rootNavigator: true).pop();
  }
}
