import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

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
      final Dio dio = Dio();
      final fileName = url.split('/').last;

      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/$fileName";

      await dio.download(url, filePath);

      final result = await OpenFilex.open(filePath);

      if (result.type == ResultType.noAppToOpen) {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch $url in browser either';
        }
      }
    } catch (e) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
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

    // استخدم هذا الخيار للـ Android و iOS
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.platformDefault, // مهم!
      );
    } else {
      debugPrint("Cannot launch phone call to $phoneNumber");
      // يمكن عرض رسالة للمستخدم
    }
  }
}
