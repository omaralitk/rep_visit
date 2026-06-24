import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Generic in-app browser used for the legal & support pages
/// (Privacy Policy, Terms & Conditions, Contact / data deletion).
class WebViewScreen extends StatefulWidget {
  final String title;
  final String url;

  const WebViewScreen({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.whiteColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            }
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (_) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _hasError = true;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _reload() {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });
    _controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: TextWidget(
          widget.title,
          textSize: 16,
          fontWeight: FontWeight.w600,
          textColor: AppColors.fontColor,
        ),
      ),
      body: Stack(
        children: [
          if (!_hasError) WebViewWidget(controller: _controller),
          if (_hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      color: AppColors.grey500,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    TextWidget(
                      "Could not open link".tr(),
                      textSize: 14,
                      textColor: AppColors.typography500,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _reload,
                      child: TextWidget(
                        "Retry".tr(),
                        textSize: 14,
                        textColor: AppColors.mainColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_isLoading && !_hasError)
            Center(
              child: CircularProgressIndicator(color: AppColors.mainColor),
            ),
        ],
      ),
    );
  }
}
