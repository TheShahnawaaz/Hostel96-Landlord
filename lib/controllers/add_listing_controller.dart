import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hostel96_landlord/controllers/hostel_controller.dart';
import 'package:hostel96_landlord/controllers/landlord_controller.dart';
import 'package:hostel96_landlord/models/hostel_model.dart';
import 'package:hostel96_landlord/repositories/hostel_repository.dart';
import 'package:hostel96_landlord/utils/connectivity/connectivity.dart';
import 'package:hostel96_landlord/widgets/full_screen_loader.dart';
import 'package:hostel96_landlord/widgets/widgets.dart';

class AddListingController extends GetxController {
  static AddListingController get instance => Get.find<AddListingController>();

  final PageController pageController = PageController();
  final formKey = GlobalKey<FormState>();
  RxList<String> images = <String>[].obs;
  RxList<HostelVariation> hostelVariations =
      <HostelVariation>[HostelVariation()].obs;

  final LandlordController landlordController = LandlordController.instance;
  final HostelRepository hostelRepository = HostelRepository.instance;
  final hostelController = HostelController.instance;

  final RxMap<String, dynamic> formData = <String, dynamic>{
    'name': '',
    'city': '',
    'area': '',
    'gender': '',
    'type': '',
    'instituteName': '',
    'hasFood': false,
    'hasWifi': false,
    'hasCCTV': false,
    'hasFridge': false,
    'hasBiometric': false,
    'hasAc': false,
    'hasStudyTable': false,
    'hasWaterCooler': false,
    'fullAddress': '',
    'googleAddressLink': '',
    'locality': '',
    'images': [],
  }.obs;

  RxInt currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void updateField(String field, dynamic value) {
    formData[field] = value;
    print(formData.value);
  }

  void addImages(List<String> newImages) {
    // Dont add images , Set images to newImages
    images(newImages);
    formData['images'] = images.toList();
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

  void addHostelVariation(HostelVariation variation) {
    hostelVariations.add(variation);
    print(hostelVariations.value);
    // formData['hostelVariations'] = hostelVariations.toList();
  }

  void removeHostelVariation(int index) {
    hostelVariations.removeAt(index);
    print(hostelVariations.value);
    for (int i = 0; i < hostelVariations.length; i++) {
      print(hostelVariations[i].toJson());
    }
  }

  Future<void> submitForm() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // TFullScreenLoader.closeLoadingDialog();
        TLoaders.warningSnackbar(
            title: "No internet connection!",
            message: "Please check your internet connection and try again.");
        return;
      }
      // Handle your form submission logic here, e.g., API call

      // Create a new HostelModel object
      HostelModel hostelModel = HostelModel.empty();

      // Set the values of the HostelModel object
      HostelModel updatedHostel = HostelModel.updated(
        hostel: hostelModel,
        name: formData['name'],
        city: formData['city'],
        area: formData['area'],
        gender: formData['gender'],
        type: formData['type'],
        instituteName: formData['instituteName'],
        hasFood: formData['hasFood'],
        hasWifi: formData['hasWifi'],
        hasCCTV: formData['hasCCTV'],
        hasFridge: formData['hasFridge'],
        hasBiometric: formData['hasBiometric'],
        hasAc: formData['hasAc'],
        hasStudyTable: formData['hasStudyTable'],
        hasWaterCooler: formData['hasWaterCooler'],
        fullAddress: formData['fullAddress'],
        googleAddressLink: formData['googleAddressLink'],
        locality: formData['locality'],
        imageSliderUrls: formData['images'],
        hostelVariations: hostelVariations.toList(),
        landlordId: landlordController.landlord.value.id,
      );

      // Save the hostel record to Firestore
      TFullScreenLoader.openLoadingDialog(
          "We are adding your listing!", "assets/lottie/splash_animation.json");

      print("Uploading hostel record to Firestore");
      print(updatedHostel.toJson());
      // Add the hostel record to Firestore
      await hostelRepository.saveHostelRecord(updatedHostel);

      print(updatedHostel.toJson());

      print(updatedHostel.toJson());
      // Close the loading dialog
      TFullScreenLoader.closeLoadingDialog();

      print("Hostel added successfully");
      print("Showing success snackbar...");

      Get.back();
      // Get.snackbar('Success', 'Listing added successfully');
      TLoaders.successSnackbar(
          title: 'Success', message: 'Listing added successfully');
      await hostelController.fetchHostelDetailsOfLandlord();
    } catch (e) {
      TFullScreenLoader.closeLoadingDialog();
      print("Error adding listing: $e");
      TLoaders.errorSnackbar(
          title: 'Error', message: 'Something went wrong, Please try again');
    }
  }
}
