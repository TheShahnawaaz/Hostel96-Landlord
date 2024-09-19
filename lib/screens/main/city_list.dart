// import 'package:flutter/material.dart';
// import 'package:get/get.dart'; // Using GetX for navigation and state management
// import 'package:iconsax/iconsax.dart';
// import 'package:hostel96_landlord/screens/main/city_listing_screen.dart';
// import 'package:hostel96_landlord/widgets/appbar.dart';
// import 'package:hostel96_landlord/screens/main/home.dart';
// import 'package:hostel96_landlord/utils/constants/colors.dart';
// import 'package:hostel96_landlord/utils/constants/sizes.dart';
// import 'package:hostel96_landlord/utils/helpers/helper_functions.dart';
// import '../../widgets/widgets.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:hostel96_landlord/controllers/city_controller.dart'; // Import your CityController

// class SearchCityListScreen extends StatefulWidget {
//   const SearchCityListScreen({super.key});

//   @override
//   State<SearchCityListScreen> createState() => _SearchCityListScreenState();
// }

// class _SearchCityListScreenState extends State<SearchCityListScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   // No need for _filteredCities as it's managed in the controller
//   // bool _isLoading = true; // No need as loading state is also in the controller

//   final cityController =
//       Get.put(CityController()); // Create an instance of CityController

//   // final cityController = CityController(); // Get the CityController instance

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   cityController.fetchCities(); // Fetch cities on screen initialization
//   // }

//   // void _filterCities(String enteredKeyword) {
//   //   cityController.filterCities(
//   //       enteredKeyword); // Call the filter method in the controller
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final dark = THelperFunctions.isDarkMode(context);

//     return Scaffold(
//       body: Column(
//         children: [
//           CurveEdgesWidget(
//             child: Column(
//               children: [
//                 TAppBar(
//                   title: Text(
//                     'Search by City',
//                     style: Theme.of(context)
//                         .textTheme
//                         .headlineMedium!
//                         .apply(color: TColors.white),
//                   ),
//                   showBackArrow: true,
//                 ),
//                 SearchTextField(
//                   controller: _searchController,
//                   onChanged: cityController.filterCities,
//                   hintText: "Search for City",
//                   // autoFocus: false,
//                 ),
//                 const SizedBox(height: TSizes.spaceBtwSections),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
//               child: Obx(
//                 // Use Obx to observe changes in the controller
//                 () => cityController.isLoading.value
//                     ? Center(
//                         child: LoadingAnimationWidget.bouncingBall(
//                             color: TColors.primary, size: 75.0),
//                       )
//                     : cityController.filteredCities.isEmpty
//                         ? Center(
//                             child: Text(
//                               'No cities found',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headlineMedium!
//                                   .apply(
//                                       color:
//                                           dark ? TColors.white : TColors.dark),
//                             ),
//                           )
//                         : Column(
//                             children: [
//                               SectionHeading(
//                                 title: 'All Cities',
//                                 showAction: false,
//                                 color: dark ? TColors.white : TColors.dark,
//                               ),
//                               Expanded(
//                                 flex: 1,
//                                 child: ListView.builder(
//                                   itemCount:
//                                       cityController.filteredCities.length,
//                                   itemBuilder: (context, index) {
//                                     final cityData =
//                                         cityController.filteredCities[index];
//                                     return ListTile(
//                                       isThreeLine: true,
//                                       minVerticalPadding: 20,
//                                       leading: Icon(Iconsax.location),
//                                       title: Text(cityData.city),
//                                       subtitle: Text(cityData.state),
//                                       trailing: Icon(Icons.arrow_forward),
//                                       onTap: () {
//                                         Get.to(() => CityDetailsScreen(
//                                               cityName: cityData.city,
//                                               stateName: cityData.state,
//                                             ));
//                                       },
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
