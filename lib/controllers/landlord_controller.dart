// import 'package:get/get.dart';
// import 'package:hostel96_landlord/models/user_model.dart';
// import 'package:hostel96_landlord/repositories/user_repository.dart';

// class UserController extends GetxController {
//   static UserController get instance => Get.find();

//   Rx<UserModel> user = UserModel.empty().obs;
//   final userRepository = Get.put(UserRepository());
//   final isProfileLoading = false.obs;

//   @override
//   void onInit() {
//     fetchUserDetails();
//     super.onInit();
//   }

//   Future<void> fetchUserDetails() async {
//     try {
//       isProfileLoading(true);
//       user.value = await userRepository.fetchUserDetails();
//     } catch (e) {
//       user(UserModel.empty());
//     } finally {
//       isProfileLoading(false);
//     }
//   }

//   Future<void> updateUserDetails(UserModel user) async {
//     try {
//       await userRepository.updateUserDetails(user);
//     } catch (e) {
//       print(e);
//     }
//   }
// }

// Path: lib/controllers/landlord_controller.dart
// Compare this snippet from lib/controllers/signup_controller.dart:

//
import 'package:get/get.dart';
import 'package:hostel96_landlord/models/landlord_model.dart';
import 'package:hostel96_landlord/repositories/landlord_repository.dart';

class LandlordController extends GetxController {
  static LandlordController get instance => Get.find();

  Rx<LandlordModel> landlord = LandlordModel.empty().obs;
  final isProfileLoading = false.obs;
  final landlordRepository = Get.put(LandlordRepository());

  @override
  void onInit() {
    fetchLandlordDetails();
    super.onInit();
  }

  bool isVerifiedLandlord() {
    return landlord.value.isVerifiedLandlord();
  }

  Future<void> fetchLandlordDetails() async {
    try {
      isProfileLoading(true);
      landlord.value = await landlordRepository.fetchLandlordDetails();
      print("landlord.value: ${landlord.value}");
    } catch (e) {
      print("Error fetching landlord details: $e");
      landlord(LandlordModel.empty());
    } finally {
      isProfileLoading(false);
    }
  }

  Future<void> updateLandlordDetails(LandlordModel landlord) async {
    try {
      await landlordRepository.updateLandlordDetails(landlord);
    } catch (e) {
      print(e);
    }
  }
}
