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

  static Future<void> openFileSmart(String url,
      {String? originalFileName}) async
  {
    try {
      LoadingWidget.show();

      final Dio dio = Dio();

      // Parse URL to handle query parameters properly
      final uri = Uri.parse(url);

      // Get authentication headers first (needed for header checks)
      final headers = await NetworkConstants.getHeaders();

      // Use original file name if provided, otherwise try to extract from URL
      String fileName = originalFileName ?? 'download_file';

      // If no original file name provided, try to get from URL
      if (originalFileName == null || originalFileName.isEmpty) {
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

        // If no extension, try to detect from Content-Type or default to PDF
        if (!fileName.contains('.')) {
          // Try to get file extension from Content-Type header
          try {
            final headResponse = await dio.head(
              url,
              options: Options(
                headers: headers,
                followRedirects: true,
                validateStatus: (status) => status! < 500,
              ),
            );
            final contentType = headResponse.headers.value('content-type');
            if (contentType != null) {
              // Map common MIME types to file extensions
              final extension = _getExtensionFromMimeType(contentType);
              if (extension != null) {
                fileName = '$fileName.$extension';
              } else {
                fileName = '$fileName.pdf'; // Default to PDF
              }
            } else {
              fileName = '$fileName.pdf'; // Default to PDF
            }
          } catch (_) {
            fileName = '$fileName.pdf'; // Default to PDF if header check fails
          }
        }
      }

      final dir = await getTemporaryDirectory();
      String filePath = "${dir.path}/$fileName";

      // First, make a HEAD request to check Content-Disposition header for filename
      try {
        final response = await dio.head(
          url,
          options: Options(
            headers: headers,
            followRedirects: true,
            validateStatus: (status) => status! < 500,
          ),
        );

        // Check Content-Disposition header for filename
        final contentDisposition =
            response.headers.value('content-disposition');
        if (contentDisposition != null) {
          // Try to extract filename from Content-Disposition header
          // Look for filename= or filename*= pattern
          final filenameIndex =
              contentDisposition.toLowerCase().indexOf('filename');
          if (filenameIndex != -1) {
            final afterFilename =
                contentDisposition.substring(filenameIndex + 8);
            final equalsIndex = afterFilename.indexOf('=');
            if (equalsIndex != -1) {
              String extractedFileName =
                  afterFilename.substring(equalsIndex + 1).trim();
              // Remove quotes if present
              if (extractedFileName.startsWith('"') &&
                  extractedFileName.endsWith('"')) {
                extractedFileName = extractedFileName.substring(
                    1, extractedFileName.length - 1);
              } else if (extractedFileName.startsWith("'") &&
                  extractedFileName.endsWith("'")) {
                extractedFileName = extractedFileName.substring(
                    1, extractedFileName.length - 1);
              }
              // Handle UTF-8 encoded filenames (filename*=UTF-8''filename.xlsx)
              if (extractedFileName.startsWith("utf-8''")) {
                extractedFileName = extractedFileName.substring(7);
              }
              // Decode URL encoding if present
              try {
                extractedFileName = Uri.decodeComponent(extractedFileName);
              } catch (_) {}

              // Take only the filename part (before semicolon if present)
              final semicolonIndex = extractedFileName.indexOf(';');
              if (semicolonIndex != -1) {
                extractedFileName =
                    extractedFileName.substring(0, semicolonIndex);
              }

              if (extractedFileName.isNotEmpty &&
                  extractedFileName.contains('.')) {
                fileName = extractedFileName.trim();
                filePath = "${dir.path}/$fileName";
              }
            }
          }
        }
      } catch (e) {
        debugPrint("Could not get file name from headers: $e");
        // Continue with original filename
      }

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
      // Supported file types: PDF, Word (.doc, .docx), Excel (.xls, .xlsx), Images, etc.
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

  /// Get file extension from MIME type
  static String? _getExtensionFromMimeType(String mimeType) {
    // Normalize MIME type (remove parameters like charset)
    final normalizedMime = mimeType.split(';').first.trim().toLowerCase();

    // Map MIME types to file extensions
    final mimeToExtension = {
      // Word documents
      'application/msword': 'doc',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
          'docx',
      'application/vnd.ms-word.document.macroEnabled.12': 'docm',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.template':
          'dotx',

      // Excel documents
      'application/vnd.ms-excel': 'xls',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
          'xlsx',
      'application/vnd.ms-excel.sheet.macroEnabled.12': 'xlsm',

      // PDF
      'application/pdf': 'pdf',

      // Images
      'image/jpeg': 'jpg',
      'image/png': 'png',
      'image/gif': 'gif',
      'image/bmp': 'bmp',
      'image/webp': 'webp',

      // Text
      'text/plain': 'txt',
      'text/html': 'html',
      'text/csv': 'csv',

      // PowerPoint
      'application/vnd.ms-powerpoint': 'ppt',
      'application/vnd.openxmlformats-officedocument.presentationml.presentation':
          'pptx',

      // Archives
      'application/zip': 'zip',
      'application/x-rar-compressed': 'rar',
      'application/x-7z-compressed': '7z',
    };

    return mimeToExtension[normalizedMime];
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
