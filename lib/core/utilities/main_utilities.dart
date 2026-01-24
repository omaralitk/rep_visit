import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rep_visit/core/network/constants/network_constants.dart';
import 'package:rep_visit/base/ui/widgets/custom_toast.dart';
import 'package:rep_visit/base/ui/widgets/loading_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class MainUtilities {
  static Future<Position> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1️⃣ Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // 2️⃣ Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, cannot request permissions.');
    }

    // 3️⃣ Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  static Future<void> openFileSmart(String url) async {
    try {
      LoadingWidget.show();

      final Dio dio = Dio();

      // Parse URL to handle query parameters properly
      final uri = Uri.parse(url);

      // Try to get file name from URL path
      // For URLs like: /api/files/9/download, try to extract file ID or use a timestamp
      String fileName = 'download_file';

      if (uri.pathSegments.isNotEmpty) {
        final lastSegment = uri.pathSegments.last;
        // If the last segment is 'download', try to get the file ID from the path
        if (lastSegment == 'download' && uri.pathSegments.length >= 2) {
          // Extract file ID from path like: /api/files/9/download
          final fileId = uri.pathSegments[uri.pathSegments.length - 2];
          fileName = 'file_$fileId';
        } else if (lastSegment != 'download') {
          fileName = lastSegment;
        }
      }

      // Remove query parameters from filename if present
      if (fileName.contains('?')) {
        fileName = fileName.split('?').first;
      }

      // If no extension, add a default one (will be corrected if server provides proper type)
      if (!fileName.contains('.')) {
        fileName = '$fileName.pdf'; // Default to PDF
      }

      // Get authentication headers (as fallback, token might already be in URL)
      final headers = await NetworkConstants.getHeaders();

      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/$fileName";

      // Download file with authentication headers
      // Since token is in URL, headers are optional but kept as fallback
      await dio.download(
        url,
        filePath,
        options: Options(
          headers: headers,
          followRedirects: true,
          validateStatus: (status) => status! < 500,
          receiveTimeout: const Duration(minutes: 5),
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            debugPrint("Download progress: $progress%");
          }
        },
      );

      LoadingWidget.hide();

      // Use the downloaded file path
      final actualFileName = filePath;

      // Open the downloaded file
      final result = await OpenFilex.open(actualFileName);

      if (result.type == ResultType.noAppToOpen) {
        // If no app to open, try to open in browser
        final browserUri = Uri.parse(url);
        if (await canLaunchUrl(browserUri)) {
          await launchUrl(browserUri, mode: LaunchMode.externalApplication);
        } else {
          ToastService.showError("No app available to open this file".tr());
        }
      } else if (result.type == ResultType.error) {
        ToastService.showError("Failed to open file: ${result.message}".tr());
      } else {
        ToastService.showSuccess("File opened successfully".tr());
      }
    } catch (e) {
      LoadingWidget.hide();
      debugPrint("Error downloading file: $e");

      // Fallback: try to open in browser
      try {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          ToastService.showInfo("Opening file in browser".tr());
        } else {
          ToastService.showError("Failed to download file: $e".tr());
        }
      } catch (e2) {
        ToastService.showError("Failed to download file: $e2".tr());
      }
    }
  }

  static Future<void> openFileUrl(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> callPhone(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );
    } else {
      debugPrint("Cannot launch phone call to $phoneNumber");
    }
  }
}
