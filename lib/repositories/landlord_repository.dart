import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel96_landlord/models/landlord_model.dart';
import 'package:hostel96_landlord/models/user_model.dart';
import 'package:hostel96_landlord/repositories/authentication_repository.dart';
import 'package:hostel96_landlord/utils/exceptions/firebase_auth_exceptions.dart';

import '../utils/exceptions/exceptions.dart';
import '../utils/exceptions/format_exceptions.dart';

class LandlordRepository extends GetxController {
  static LandlordRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveLandlordRecord(LandlordModel landlord) async {
    try {
      await _db.collection('Landlords').doc(landlord.id).set(landlord.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFormatException(e.code).message;
    } on FormatException catch (e) {
      throw const TFormatException();
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<LandlordModel> fetchLandlordDetails() async {
    try {
      print(AuthenticationRepository.instance.authUser?.uid);
      final doc = await _db
          .collection('Landlords')
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .get();
      print(doc.data());
      if (doc.exists) {
        return LandlordModel.fromSnapshot(doc);
      } else {
        throw "Landlord not found";
      }
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFormatException(e.code).message;
    } on FormatException catch (e) {
      throw const TFormatException();
    } catch (e) {
      print(e);
      throw "Something went wrong, Please try again";
    }
  }

  Future<void> updateLandlordDetails(LandlordModel landlord) async {
    try {
      await _db
          .collection('Landlords')
          .doc(landlord.id)
          .update(landlord.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFormatException(e.code).message;
    } on FormatException catch (e) {
      throw const TFormatException();
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }
}
