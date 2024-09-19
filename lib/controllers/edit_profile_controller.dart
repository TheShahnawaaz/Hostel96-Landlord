import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hostel96_landlord/controllers/landlord_controller.dart';
import 'package:hostel96_landlord/controllers/user_controller.dart';
import 'package:hostel96_landlord/models/landlord_model.dart';
import 'package:hostel96_landlord/models/user_model.dart';
import 'package:hostel96_landlord/utils/connectivity/connectivity.dart';
import 'package:hostel96_landlord/widgets/full_screen_loader.dart';
import 'package:hostel96_landlord/widgets/widgets.dart';

class EditProfileController extends GetxController {
  static EditProfileController get instance => Get.find();

  final email = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNo = TextEditingController();
  final bankName = TextEditingController();
  final accountNumber = TextEditingController();
  final beneficiaryName = TextEditingController();
  final ifscCode = TextEditingController();
  final bankBranch = TextEditingController();
  final upiId = TextEditingController();
  final address = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final userController = LandlordController.instance;

  @override
  void onInit() {
    email.text = userController.landlord.value.email;
    firstName.text = userController.landlord.value.firstName;
    lastName.text = userController.landlord.value.lastName;
    phoneNo.text = userController.landlord.value.phone;
    bankName.text = userController.landlord.value.bankName;
    accountNumber.text = userController.landlord.value.accountNumber;
    beneficiaryName.text = userController.landlord.value.beneficiaryName;
    ifscCode.text = userController.landlord.value.ifscCode;
    bankBranch.text = userController.landlord.value.bankBranch;
    upiId.text = userController.landlord.value.upiId;
    address.text = userController.landlord.value.address;

    super.onInit();
  }

  Future<void> updateProfile() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.warningSnackbar(
            title: "No internet connection!",
            message: "Please check your internet connection and try again.");
        return;
      }

      if (!formKey.currentState!.validate()) {
        return;
      }

      TFullScreenLoader.openLoadingDialog("We are updating your profile!",
          "assets/lottie/splash_animation.json");

      final user = LandlordModel.updated(
        landlord: userController.landlord.value,
        email: email.text,
        firstName: firstName.text,
        lastName: lastName.text,
        phone: phoneNo.text,
        bankName: bankName.text,
        accountNumber: accountNumber.text,
        beneficiaryName: beneficiaryName.text,
        ifscCode: ifscCode.text,
        bankBranch: bankBranch.text,
        upiId: upiId.text,
        address: address.text,
      );

      if (userController.isVerifiedLandlord() && !user.isVerifiedLandlord()) {
        TLoaders.errorSnackbar(
            title: "Profile update failed!",
            message: "You cannot change your verification status.");
        TFullScreenLoader.closeLoadingDialog();
        return;
      }

      await userController.updateLandlordDetails(user);

      await userController.fetchLandlordDetails();

      // await Future.delayed(const Duration(seconds: 5));

      TFullScreenLoader.closeLoadingDialog();
      TLoaders.successSnackbar(
          title: "Profile updated successfully!",
          message: "Your profile has been updated successfully.");
    } catch (e) {
      TFullScreenLoader.closeLoadingDialog();
      print(e);
      TLoaders.errorSnackbar(
          title: "Profile update failed!",
          message: "Something went wrong, Please try again.");
    }
  }
}
