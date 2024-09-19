import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel96_landlord/screens/authentication/account_creation.dart';
import 'package:hostel96_landlord/screens/authentication/phone_login.dart';
import 'package:hostel96_landlord/utils/exceptions/exceptions.dart';
import 'package:hostel96_landlord/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:hostel96_landlord/utils/exceptions/firebase_exceptions.dart';
import 'package:hostel96_landlord/utils/exceptions/format_exceptions.dart';
import 'package:hostel96_landlord/utils/firebase/firebase_storage.dart';
import 'package:hostel96_landlord/widgets/navigation_menu.dart';

import 'landlord_repository.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  User? get authUser => _auth.currentUser;

  // final hostelController = Get.put(HostelController());
  final FirebaseStorageService _firebaseStorageService =
      Get.put(FirebaseStorageService());

  @override
  void onReady() {
    // Force 5 seconds delay
    Future.delayed(const Duration(seconds: 1), () {
      screenRedirect();
    });
    // screenRedirect();
  }

  screenRedirect() async {
    // Get.offAllNamed(LoginScreen.routeName);
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final storedUser = await LandlordRepository().fetchLandlordDetails();
        Future.delayed(const Duration(milliseconds: 250)).then((value) {
          if (storedUser.firstName.trim().isEmpty) {
            Get.off(() => const AccountCreationScreen());
          } else {
            Get.offAll(() => const NavigationMenu());
          }
        });
      } catch (e) {
        Get.offAll(() => const AccountCreationScreen());
      }

      /// --------------------------------------
      ///   Remove Email Veification Flow.
      /// --------------------------------------

      // if (user.emailVerified) {
      // Get.offAll(() => const NavigationMenu());
      // } else {
      //   Get.offAll(() => VerifyEmailScreen(
      //         email: user.email,
      //       ));
      // }

      ///
      ///
      ///
    } else {
      Get.offAll(() => const PhoneLoginScreen());
    }
  }

  Future<UserCredential> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // Check if we have a landlord with this id in the database
      final landlord =
          await _db.collection('Landlords').doc(userCredential.user?.uid).get();

      if (!landlord.exists) {
        await _auth.signOut();
        throw TFirebaseAuthException('user-not-found').message;
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw const TFormatException();
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<UserCredential> registerWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.code}");
      print("FirebaseAuthException: ${TExceptions(e.code).message}");
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw const TFormatException();
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
      // // } on PlatformException catch (e) {
      //   throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
      // } on PlatformException catch (e) {
      //   throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAll(() => const PhoneLoginScreen());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
      // } on PlatformException catch (e) {
      //   throw TPlatformException(e.code).message;
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  ///*********************************************************************///
  ///
  ///   Phone Authentication Related Methods
  ///
  ///*********************************************************************///
  ///

  ///
  ///
  ///
  /// Send OTP for the given Phone number
  ///
  ///
  ///
  Future<void> sendOTP({
    required String phoneNo,
    required void Function(
      String verificationId,
      int? forceResendingToken,
    ) onCodeSent,
    required ValueChanged<UserCredential> onVerified,
    required ValueChanged<FirebaseAuthException> onFailed,
    int? resendToken,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credential) async {
        try {
          final newCred = await validateCredential(credential);
          onVerified(newCred);
        } on FirebaseAuthException catch (e) {
          onFailed(e);
        }
      },
      verificationFailed: onFailed,
      forceResendingToken: resendToken,
      codeSent: onCodeSent,
      timeout: const Duration(minutes: 2),
      codeAutoRetrievalTimeout: (verificationId) {
        // Leave it blank, we are not handling timeout
      },
    );
  }

  Future<UserCredential> verifyOTP({
    required String vetificationId,
    required String otp,
  }) async {
    return await validateCredential(
      PhoneAuthProvider.credential(
        verificationId: vetificationId,
        smsCode: otp,
      ),
    );
  }

  Future<UserCredential> validateCredential(PhoneAuthCredential credential) {
    return _auth.signInWithCredential(credential);
  }

  User? getFirebaseUser() {
    return _auth.currentUser;
  }
}
