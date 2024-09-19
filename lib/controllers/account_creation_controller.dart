import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:hostel96_landlord/models/landlord_model.dart";
import "package:hostel96_landlord/models/user_model.dart";
import "package:hostel96_landlord/repositories/authentication_repository.dart";
import "package:hostel96_landlord/repositories/landlord_repository.dart";
import "package:hostel96_landlord/repositories/user_repository.dart";
import "package:hostel96_landlord/utils/connectivity/connectivity.dart";
import "package:hostel96_landlord/widgets/full_screen_loader.dart";
import "package:hostel96_landlord/widgets/widgets.dart";

class AccountCreationController extends GetxController {
  static AccountCreationController get instance => Get.find();

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
  @override
  void onInit() {
    super.onInit();
    phoneNo.text =
        AuthenticationRepository.instance.getFirebaseUser()?.phoneNumber ?? "";
  }

  Future<void> createAccount() async {
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
      final firebaseUser = AuthenticationRepository.instance.getFirebaseUser();
      final newUser = LandlordModel(
        id: firebaseUser!.uid,
        email: email.text.trim(),
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        phone: (firebaseUser.phoneNumber ?? phoneNo.text.trim()).replaceFirst("+91", ""),
        bankName: "",
        accountNumber: "",
        ifscCode: "",
        beneficiaryName: "",
        bankBranch: "",
        upiId: "",
        address: "",
      );

      final userRepository = Get.put(LandlordRepository());

      await userRepository.saveLandlordRecord(newUser);

      TFullScreenLoader.closeLoadingDialog();

      // TLoaders.successSnackbar(
      //     title: "Congratulations!",
      //     message:
      //         "Please verify your email address to continue using the app.");

     await AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      print("Error: $e");
      TLoaders.errorSnackbar(title: "Oops!", message: e.toString());
      TFullScreenLoader.closeLoadingDialog();
    }
  }
}
