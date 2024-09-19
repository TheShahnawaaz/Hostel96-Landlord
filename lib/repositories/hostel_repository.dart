import 'dart:math';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hostel96_landlord/controllers/landlord_controller.dart';
import 'package:hostel96_landlord/models/hostel_model.dart';
import 'package:hostel96_landlord/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:hostel96_landlord/utils/exceptions/firebase_exceptions.dart';
import 'package:hostel96_landlord/utils/exceptions/format_exceptions.dart';
import 'package:hostel96_landlord/utils/firebase/firebase_storage.dart';

class HostelRepository extends GetxController {
  static HostelRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorageService _firebaseStorageService =
      FirebaseStorageService.instance;
  final landlordController = LandlordController.instance;

  Future<void> saveHostelRecord(HostelModel hostel) async {
    try {
      // For each HostelVariation, create a id and save it to the database
      for (var variation in hostel.hostelVariations) {
        // Create a new id with current timestamp and random number
        variation.id = DateTime.now().millisecondsSinceEpoch.toString() +
            Random().nextInt(1000000).toString();
      }
      List<String> uploadedImageUrls = [];
      for (String imagePath in hostel.imageSliderUrls) {
        String fileName = imagePath.split('/').last;
        // Remove the extension from the file name if it has one
        fileName = fileName.split('.').first;
        String downloadUrl = await _firebaseStorageService.uploadImageFile(
          'HostelImages/${landlordController.landlord.value.id}/', // Path with landlord ID
          XFile(imagePath),
          fileName,
        );
        uploadedImageUrls.add(downloadUrl);
      }

      // Update hostel object with uploaded image URLs
      hostel.imageSliderUrls = uploadedImageUrls;

      // Save the hostel record to Firestore
      await _db.collection('Hostels').add(hostel.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw TFormatException();
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

  Future<List<HostelModel>> fetchHostelDetailsOfLandlord(
      String landlordId) async {
    try {
      final snapshot = await _db
          .collection('Hostels')
          .where('LandlordId', isEqualTo: landlordId)
          .get();

      print(snapshot.docs.length);
      if (snapshot.docs.isNotEmpty) {
        var hostelList =
            snapshot.docs.map((doc) => HostelModel.fromSnapshot(doc)).toList();
        print(hostelList);
        for (var hostel in hostelList) {
          for (var variation in hostel.hostelVariations)
            print(variation.toJson());
        }
        return hostelList;
      } else {
        throw "Hostel not found";
      }
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw TFormatException();
    } catch (e) {
      print(e);
      throw "Something went wrong, Please try again";
    }
  }

  Future<void> updateHostelDetails(HostelModel hostel) async {
    try {
      await _db.collection('Hostels').doc(hostel.id).update(hostel.toJson());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw TFormatException();
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }

// Future<void> uploadDummyData(List<BannerModel> banners) async {
//     try {
//       final storage = Get.put(FirebaseStorageService());

//       for (final this_banner in banners) {
//         print("Uploading banner: ${this_banner.imageUrl}");
//         final file = await storage.getImageDataFromAssets(this_banner.imageUrl);

//         final url =
//             await storage.uploadImageData('Banners', file, this_banner.name);

//         this_banner.imageUrl = url;

//         await _db.collection('Banners').add(this_banner.toJson());
//       }
  // } on FirebaseAuthException catch (e) {
  //   throw TFirebaseAuthException(e.code).message;
  // } on FirebaseException catch (e) {
  //   throw TFirebaseException(e.code).message;
  // } on FormatException catch (e) {
  //   throw TFormatException();
//     } catch (e) {
//       throw "Something went wrong, Please try again";
//     }
//   }

  Future<void> uploadDummyData(List<HostelModel> hostels) async {
    try {
      print("Uploading dummy data");
      for (final this_hostel in hostels) {
        print("Uploading hostel: ${this_hostel.name}");
        await saveHostelRecord(this_hostel);
      }
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw const FormatException();
    } catch (e) {
      throw "Something went wrong, Please try again";
    }
  }
}
