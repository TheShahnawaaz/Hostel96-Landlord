import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:hostel96_landlord/models/landlord_model.dart";
import "package:hostel96_landlord/models/user_model.dart";
import "package:hostel96_landlord/repositories/authentication_repository.dart";
import "package:hostel96_landlord/repositories/landlord_repository.dart";
import "package:hostel96_landlord/repositories/user_repository.dart";
import "package:hostel96_landlord/screens/authentication/verify_email.dart";
import "package:hostel96_landlord/utils/connectivity/connectivity.dart";
import "package:hostel96_landlord/widgets/full_screen_loader.dart";
import "package:hostel96_landlord/widgets/widgets.dart";

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final hidePassword = true.obs;
  final hideConfirmPassword = true.obs;
  final privacyPolicy = false.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNo = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> signUp() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // TFullScreenLoader.closeLoadingDialog();
        TLoaders.warningSnackbar(
            title: "No internet connection!",
            message: "Please check your internet connection and try again.");
        return;
      }

      if (!formKey.currentState!.validate()) {
        // TFullScreenLoader.closeLoadingDialog();
        return;
      }

      if (privacyPolicy.value == false) {
        TLoaders.warningSnackbar(
            title: "Accept privacy policy and terms of use!",
            message:
                "In order to proceed, you must agree to the privacy policy and terms of use.");
        return;
      }

      TFullScreenLoader.openLoadingDialog("We are creating your account!",
          "assets/lottie/splash_animation.json");

      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim());

      // LandlordModel({
      //   required this.id,
      //   required this.firstName,
      //   required this.lastName,
      //   required this.email,
      //   required this.phone,
      //   required this.bankName,
      //   required this.accountNumber,
      //   required this.ifscCode,
      //   required this.beneficiaryName,
      //   required this.upiId,
      //   required this.gstNumber,
      //   required this.address,
      //   required this.createdAt,
      //   required this.updatedAt,
      // });

      final newLandlord = LandlordModel(
        id: userCredential.user!.uid,
        email: email.text.trim(),
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        phone: phoneNo.text.trim(),
        bankName: "",
        accountNumber: "",
        ifscCode: "",
        beneficiaryName: "",
        bankBranch: "",
        upiId: "",
        address: "",
        // createdAt: DateTime.now(),
        // updatedAt: DateTime.now(),
      );

      final landlordRepository = Get.put(LandlordRepository());

      await landlordRepository.saveLandlordRecord(newLandlord);

      TFullScreenLoader.closeLoadingDialog();

      TLoaders.successSnackbar(
          title: "Congratulations!",
          message:
              "Please verify your email address to continue using the app.");

      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      print("Error: $e");
      TLoaders.errorSnackbar(title: "Oops!", message: e.toString());
      TFullScreenLoader.closeLoadingDialog();
    }
  }
}
