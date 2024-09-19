import 'package:get/get.dart';
import 'package:hostel96_landlord/controllers/landlord_controller.dart';
import 'package:hostel96_landlord/dummy_data.dart';
import 'package:hostel96_landlord/models/hostel_model.dart';
import 'package:hostel96_landlord/repositories/hostel_repository.dart';

class HostelController extends GetxController {
  static HostelController get instance => Get.find();
  RxList<HostelModel> hostelsOfLandlord = <HostelModel>[].obs;
  Rx<HostelModel> hostel = HostelModel.empty().obs;
  final isLoading = false.obs;
  final hostelRepository = Get.put(HostelRepository());

  final landlordController = LandlordController.instance;

  @override
  void onInit() async {
    super.onInit();
    // fetchHostelDetailsOfLandlord();
    // fetchInitialHostelDetails();
    // hostelRepository.uploadDummyData(MyDummyData.hostels);
    // Fetching hostel details of a landlord and storing it in hostel variable
    //  hostelRepository.fetchHostelDetailsOfLandlord("1");
    // Updating hostel details of a landlord

    // hostelRepository.updateHostelDetails(MyDummyData.hostels[0]);
  }

  Future<void> fetchHostelDetailsOfLandlord() async {
    try {
      isLoading(true);
      // Take only whose isDeleted is false
      hostelsOfLandlord.value = await hostelRepository
          .fetchHostelDetailsOfLandlord(landlordController.landlord.value.id)
          .then(
              (value) => value.where((element) => !element.isDeleted).toList());
    } catch (e) {
      print("Error fetching hostel details: $e");
      hostelsOfLandlord(<HostelModel>[]);
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchInitialHostelDetails() async {
    try {
      isLoading(true);
      // hostel.value = await hostelRepository.fetchHostelDetails();
    } catch (e) {
      print("Error fetching hostel details: $e");
      hostel(HostelModel.empty());
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateHostelDetails(HostelModel hostel) async {
    try {
      await hostelRepository.updateHostelDetails(hostel);
    } catch (e) {
      print(e);
    }
  }
}
