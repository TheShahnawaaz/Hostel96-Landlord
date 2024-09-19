import 'package:get/get.dart';
import 'package:hostel96_landlord/models/city_model.dart';
import 'package:hostel96_landlord/repositories/city_repository.dart';

class CityController extends GetxController {
  static CityController get instance => Get.find();

  final CityRepository cityRepository = Get.put(CityRepository());
  final RxList<CityModel> cities = <CityModel>[].obs;
  final RxList<CityModel> filteredCities = <CityModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    fetchCities();
    super.onInit();
  }

  Future<void> fetchCities() async {
    try {
      isLoading(true);
      cities.value = await cityRepository.fetchCities();
      // Sort cities by city name
      cities.sort((a, b) => a.city.compareTo(b.city));
      filteredCities.value = cities; // Initially display all cities
    } finally {
      // Wait for 1 hostel96_landlord to show the loading indicator
      // await Future.delayed(const Duration(hostel96_landlords: 3));
      isLoading(false);
    }
  }

  void filterCities(String query) {
    if (query.isEmpty) {
      filteredCities.value = cities; // Show all when query is empty
    } else {
      filteredCities.value = cities
          .where((city) =>
              city.city.toLowerCase().contains(query.toLowerCase()) ||
              city.state.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
