import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hostel96_landlord/repositories/authentication_repository.dart';
import 'package:hostel96_landlord/utils/connectivity/connectivity.dart';
import 'package:hostel96_landlord/widgets/full_screen_loader.dart';
import 'package:hostel96_landlord/widgets/widgets.dart';

enum PhoneAuthState { phoneNumber, otp }

class PhoneAuthController extends GetxController {
  final phone = TextEditingController();
  final otp = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final counter = TimerCounter(30);

  final state = PhoneAuthState.phoneNumber.obs;
  @override
  onInit() {
    super.onInit();
    if (kDebugMode) {
      phone.text = "7209109480";
      otp.text = "993400";
    }
  }

  int? _resendCode;
  String? _verificationId;

  Future<void> sendOTP() async {
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

    try {
      TFullScreenLoader.openLoadingDialog(
          "We are Sending OTP!!", "assets/lottie/splash_animation.json");
      final completer = Completer();
      print("Phone No: ${phone.text}");
      await AuthenticationRepository.instance.sendOTP(
        phoneNo: "+91${phone.text}",
        resendToken: _resendCode,
        onCodeSent: (verificationId, resendCode) {
          _verificationId = verificationId;
          _resendCode = resendCode;
          otp.text = "";
          state.value = PhoneAuthState.otp;
          counter.startCountingDown();
          completer.complete();
        },
        onVerified: (_) async {
          await _onLoggedIn();
          completer.complete();
        },
        onFailed: (error) {
          TLoaders.errorSnackbar(
              title: "Failed!!", message: error.message ?? "");
          completer.complete();
        },
      );
      await completer.future;
      TFullScreenLoader.closeLoadingDialog();
    } catch (e) {
      TFullScreenLoader.closeLoadingDialog();
      TLoaders.errorSnackbar(title: "Failed!!", message: e.toString());
    }
  }

  Future<void> _onLoggedIn() async {
    AuthenticationRepository.instance.screenRedirect();
  }

  Future<void> verifyOTP() async {
    final code = otp.text;

    if (code.trim().length != 6) {
      TLoaders.errorSnackbar(
          title: "Failed!!", message: "OTP should be a 6 digit code");
      return;
    }
    final verificationId = _verificationId;
    if (verificationId == null) {
      TLoaders.errorSnackbar(
          title: "Failed!!",
          message: "OTP is not yet sent. Please request for otp");
      return;
    }
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      TLoaders.warningSnackbar(
          title: "No internet connection!",
          message: "Please check your internet connection and try again.");
      return;
    }

    TFullScreenLoader.openLoadingDialog("Verifying the OTP. Please wait.",
        "assets/lottie/splash_animation.json");
    try {
      await AuthenticationRepository.instance
          .verifyOTP(vetificationId: verificationId, otp: code.trim());
      await _onLoggedIn();
      TFullScreenLoader.closeLoadingDialog();
    } catch (e) {
      TFullScreenLoader.closeLoadingDialog();
      TLoaders.errorSnackbar(title: "Failed!!", message: e.toString());
    }
  }
}

class TimerCounter {
  late StreamController<int> _timeLeftController;
  Timer? _timer;
  late int totalTime;
  late int _initialTime;

  TimerCounter(this.totalTime) {
    _initialTime = totalTime;
    _timeLeftController = StreamController<int>.broadcast();
  }

  // Getter for the timeLeft stream
  Stream<int> get timeLeftStream => _timeLeftController.stream;
  void cancel() {
    _timer?.cancel();
  }

  // Function to start counting down every second
  void startCountingDown() {
    _initialTime = totalTime;
    // Initial value
    _timeLeftController.add(_initialTime);

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      // Decrease the time left by 1 second
      _initialTime--;

      // Add the updated time left to the stream
      _timeLeftController.add(_initialTime);

      // Check if the countdown is finished
      if (_initialTime <= 0) {
        // Cancel the timer
        _timer?.cancel();

        // Close the stream controller
      }
    });
  }

  void dispose() {
    _timer?.cancel();
    _timeLeftController.close();
  }
}
