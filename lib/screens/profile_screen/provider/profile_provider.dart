import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rep_visit/base/ui/widgets/custom_toast.dart';
import 'package:rep_visit/base/ui/widgets/loading_widget.dart';
import 'package:rep_visit/core/navigation_service/navigation_service.dart';
import 'package:rep_visit/screens/login_screen/ui/login_screen.dart';
import 'package:rep_visit/screens/profile_screen/repo/profile_repo.dart';

import '../../../core/cach/cach_manager.dart';
import '../../../core/utilities/logout_utility.dart';
import '../../login_screen/models/login_model.dart';
import '../models/files_model.dart';

class ProfileProvider extends ChangeNotifier {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool fieldsInitialized = false;

  void fillFieldsFromUser() {
    if (user == null) return;

    fullNameController.text = user!.name;
    phoneController.text = user!.phoneNumber;

    fieldsInitialized = true;
    notifyListeners();
  }

  int selectedTab = 0;

  /// Change tab (Pending / Completed)
  void changeTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  EmpData? user;

  Future<void> loadUser() async {
    user = await UserCache.getEmpData();
    notifyListeners();
  }

  void updateName(String newName) {
    user?.name = newName;
    notifyListeners();
  }

  void updatePhone(String phone) {
    user?.phoneNumber = phone;
    notifyListeners();
  }

  File? pickedImageFile;

  String? base64Image;

  /// Logout Method
  makeLogOut(BuildContext context) async {
    LoadingWidget.show();
    ProfileRepo().makeLogOut({}).then((val) async {
      LoadingWidget.hide();
      if (val is Exception) {
        ToastService.showError(val.msg);
      } else if (val.status == 1) {
        // Dispose all controllers and clear all caches (except onboarding)

        NavigationService.pushAndRemoveUntil(const LoginScreen());
        await LogoutUtility.performLogout(context);
        ToastService.showSuccess(val.msg);
      }
    });
  }

  /// Update info method
  updateInfo(BuildContext context) {
    Map<String, dynamic> body = {};
    body["name"] = fullNameController.text;
    body["phone_number"] = phoneController.text;
    // Include base64 image if one was selected
    body["image"] = base64Image ?? "";
    LoadingWidget.show();
    ProfileRepo().updateInfo(body).then((val) {
      LoadingWidget.hide();
      if (val is Exception) {
        ToastService.showError(val.msg);
      } else if (val.status == 1) {
        isEdit = false;
        // Clear picked image after successful update
        pickedImageFile = null;
        base64Image = null;
        notifyListeners();
        UserCache.setEmpData(user!);
        ToastService.showSuccess("Updated");
      }
    });
  }

  /// enable edit info
  bool isEdit = false;

  setIsEdit(bool val) {
    isEdit = val;
    notifyListeners();
  }

  /// Get Files
  List<Files> filesList = [];
  bool filesLoading = false;

  getFiles() {
    filesLoading = true;
    notifyListeners();
    ProfileRepo().getFiles().then((val) {
      filesLoading = false;

      if (val.status == 1) {
        filesList = val.data;
        // notifyListeners();
      }
      notifyListeners();
    });
  }

  bool isChangePassword = false;

  setIsChangePassword(bool val) {
    isChangePassword = val;
    notifyListeners();
  }

  TextEditingController currentPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  changePass() async {
    /// Validate empty fields
    if (currentPassController.text.isEmpty ||
        newPassController.text.isEmpty ||
        confirmPassController.text.isEmpty) {
      ToastService.showError("Please fill all fields");
      return;
    }

    /// Validate password match
    if (newPassController.text != confirmPassController.text) {
      ToastService.showError("New password and confirmation do not match");
      return;
    }

    Map<String, String> object = {};
    object['current_password'] = currentPassController.text;
    object['new_password'] = newPassController.text;
    object['new_password_confirmation'] = confirmPassController.text;

    LoadingWidget.show();
    await ProfileRepo().changePass(object).then((val) {
      LoadingWidget.hide();
      if (val.status == 1) {
        setIsChangePassword(false);
        ToastService.showSuccess(val.msg);
      } else {
        ToastService.showError(val.msg);
      }
    });
  }

  /// Check and request photo library permission
  Future<bool> _checkPhotoPermission() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), Permission.photos handles READ_MEDIA_IMAGES
      // For older versions, it falls back to READ_EXTERNAL_STORAGE
      PermissionStatus status = await Permission.photos.status;

      if (status.isDenied) {
        status = await Permission.photos.request();
        if (status.isDenied) {
          ToastService.showError("Photo permission is denied.");
          return false;
        }
      }

      if (status.isPermanentlyDenied) {
        ToastService.showError(
            "Photo permission is permanently denied. Please enable it in settings.");
        await openAppSettings();
        return false;
      }

      return status.isGranted;
    } else if (Platform.isIOS) {
      PermissionStatus status = await Permission.photos.status;

      if (status.isDenied) {
        status = await Permission.photos.request();
        if (status.isDenied) {
          ToastService.showError("Photo permission is denied.");
          return false;
        }
      }

      if (status.isPermanentlyDenied) {
        ToastService.showError(
            "Photo permission is permanently denied. Please enable it in settings.");
        await openAppSettings();
        return false;
      }

      return status.isGranted;
    }
    return false;
  }

  /// Pick image from gallery
  Future<void> pickImage() async {
    try {
      // Check permission first
      final hasPermission = await _checkPhotoPermission();
      if (!hasPermission) {
        ToastService.showError(
            "Photo permission is required to select images.");
        return;
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // reduce size
      );

      if (image != null) {
        pickedImageFile = File(image.path);

        // Convert to Base64
        List<int> imageBytes = await pickedImageFile!.readAsBytes();
        base64Image = base64Encode(imageBytes);

        // Update user image locally for preview
        if (user != null) {
          user!.image = image.path; // Temporary local path for preview
        }

        notifyListeners();
        ToastService.showSuccess("Image selected successfully");
      }
    } catch (e) {
      ToastService.showError("Error picking image: $e");
    }
  }
}
