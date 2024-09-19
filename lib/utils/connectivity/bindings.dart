import 'package:get/get.dart';
import 'package:hostel96_landlord/utils/connectivity/connectivity.dart';

class GeneralBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
  }
}
