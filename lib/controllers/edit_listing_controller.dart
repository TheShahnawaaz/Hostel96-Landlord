import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hostel96_landlord/controllers/hostel_controller.dart';
import 'package:hostel96_landlord/models/hostel_model.dart';
import 'package:hostel96_landlord/repositories/hostel_repository.dart';
import 'package:hostel96_landlord/widgets/full_screen_loader.dart';
import 'package:hostel96_landlord/widgets/widgets.dart';

class EditHostelController extends GetxController {
  final HostelModel _hostel;
  final GlobalKey<FormState> basicDetailsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> characteristicsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> amenitiesFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> addressVerificationFormKey =
      GlobalKey<FormState>();
  final GlobalKey<FormState> variationFormKey = GlobalKey<FormState>();
  final PageController pageController = PageController();
  final HostelRepository hostelRepository = HostelRepository.instance;
  final hostelController = HostelController.instance;

  Rx<HostelModel> hostel;

  static EditHostelController get instance => Get.find();

  EditHostelController(this._hostel) : hostel = Rx<HostelModel>(_hostel);

  RxInt currentPage = 0.obs;

  void onPageChanged(int index) {
    print("Paged chnaged from $currentPage to $index");
    if (getCurrentPageFormKey() != null) {
      if (getCurrentPageFormKey()!.currentState != null &&
          !getCurrentPageFormKey()!.currentState!.validate()) {
        pageController.animateToPage(currentPage.value,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
        return;
      }
    }
    currentPage.value = index;
  }

  void nextPage() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void previousPage() {
    if (pageController.page! > 0) {
      pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void updateField(String field, dynamic value) {
    // Update field in the model
    print("Field: $field, Value: $value");

    switch (field) {
      case 'name':
        hostel.value.name = value;
        break;
      case 'area':
        hostel.value.area = value;
        break;
      case 'instituteName':
        hostel.value.instituteName = value;
        break;
      case 'fullAddress':
        hostel.value.fullAddress = value;
        break;
      case 'locality':
        hostel.value.locality = value;
        break;
      case "isFeatured":
        hostel.value.isFeatured = value;
        print("hostel.value.isFeatured: ${hostel.value.isFeatured}");
        break;
      case "isDeleted":
        hostel.value.isDeleted = value;
        print("hostel.value.isDeleted: ${hostel.value.isDeleted}");
        break;
      default:
        break;
    }

    hostel.refresh();
  }

  void updateVariationField(String id, dynamic value) {
    var variation =
        hostel.value.hostelVariations.firstWhere((element) => element.id == id);
    print("Variation: $variation");
    variation.bedCount = value;
    print(
        "Updated Hostel Variations: ${hostel.value.hostelVariations[0].toJson()}");
    hostel.refresh();
  }

  Future<void> submitChanges() async {
    try {
      print("Saving Changes");
      // If current state is null or not valid, animate to the first page
      if (getCurrentPageFormKey() != null &&
          getCurrentPageFormKey()!.currentState != null &&
          !getCurrentPageFormKey()!.currentState!.validate()) {
        pageController.animateToPage(currentPage.value,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
        return;
      }

      // Save the hostel record to Firestore
      TFullScreenLoader.openLoadingDialog(
          "We are adding your listing!", "assets/lottie/splash_animation.json");

      await hostelRepository.updateHostelDetails(hostel.value);

      TFullScreenLoader.closeLoadingDialog();

      Get.back();

      TLoaders.successSnackbar(
          title: "Hostel Updated",
          message: "Your hostel has been updated successfully");

      await hostelController.fetchHostelDetailsOfLandlord();
    } catch (e) {
      TFullScreenLoader.closeLoadingDialog();
      print("Error adding listing: $e");
      TLoaders.errorSnackbar(
          title: 'Error', message: 'Something went wrong, Please try again');
    }
  }

  getCurrentPageFormKey() {
    switch (currentPage.value) {
      case 0:
        return basicDetailsFormKey;
      case 1:
        return characteristicsFormKey;
      case 2:
        return amenitiesFormKey;
      case 3:
        return addressVerificationFormKey;
      case 4:
        return null;
      case 5:
        return variationFormKey;
      default:
        return null;
    }
  }
}
