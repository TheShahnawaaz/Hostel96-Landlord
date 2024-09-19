// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hostel96_landlord/screens/main/home.dart';
// import 'package:hostel96_landlord/models/hostel_model.dart';
// import 'package:hostel96_landlord/utils/constants/colors.dart';
// import 'package:hostel96_landlord/utils/constants/image_strings.dart';
// import 'package:hostel96_landlord/widgets/appbar.dart';
// import 'package:hostel96_landlord/utils/constants/sizes.dart';
// import 'package:hostel96_landlord/screens/main/hostel_details_screen.dart';
// import 'package:hostel96_landlord/widgets/hostel_card.dart';
// import 'package:hostel96_landlord/widgets/shimmer_loader.dart';
// import 'package:hostel96_landlord/widgets/widgets.dart'; // Ensure you have this file created as described earlier

// class CityDetailsScreen extends StatefulWidget {
//   final String? cityName;
//   final String? stateName;

//   CityDetailsScreen({Key? key, required this.cityName, required this.stateName})
//       : super(key: key);

//   @override
//   _CityDetailsScreenState createState() => _CityDetailsScreenState();
// }

// class _CityDetailsScreenState extends State<CityDetailsScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   ScrollController _scrollController = ScrollController();
//   List<Hostel> _hostels = [];
//   List<Hostel> _filteredHostels = [];
//   bool _isLoading = false;
//   int _currentPage = 0;
//   static const int _pageSize = 3; // Number of hostels per page

//   @override
//   void initState() {
//     super.initState();
//     _loadMoreHostels();
//     _scrollController.addListener(_scrollListener);
//   }

//   void _loadMoreHostels() async {
//     if (_isLoading) return;
//     _isLoading = true;

//     // Simulate a database fetch with delay
//     await Future.delayed(Duration(seconds: 1), () {
//       var newHostels = [
//         Hostel(
//           name: "Sunrise Hostel Hostel Hostel Hostel",
//           area: "MG Road",
//           price: "2000/month",
//           gender: "Male",
//           type: "Hostel",
//           photoUrl:
//               'https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg',
//           fullAddress: "1234 MG Road, Bangalore",
//           googleAddressLink: "https://maps.google.com",
//           locality: "Central Bangalore",
//           instituteName: "ABC College",
//           hasFood: true,
//           hasWifi: true,
//           hasCCTV: true,
//           hasFridge: true,
//           hasBiometric: false,
//           hasAc: true,
//           hasStudyTable: true,
//           hasWaterCooler: true,
//           imageSliderUrls: [
//             "https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg",
//             "https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg"
//           ],
//         ),
//         // Add more hostels as needed
//         Hostel(
//           name: "Sunrise Hostel",
//           area: "MG Road",
//           price: "2000/month",
//           gender: "Female",
//           type: "Hostel",
//           photoUrl:
//               'https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg',
//           fullAddress: "1234 MG Road, Bangalore",
//           googleAddressLink: "https://maps.google.com",
//           locality: "Central Bangalore",
//           instituteName: "ABC College",
//           hasFood: true,
//           hasWifi: true,
//           hasCCTV: true,
//           hasFridge: true,
//           hasBiometric: false,
//           hasAc: true,
//           hasStudyTable: true,
//           hasWaterCooler: true,
//           imageSliderUrls: [
//             "https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg",
//             "https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg"
//           ],
//         ),
//         // Add more hostels as needed
//         Hostel(
//           name: "Sunrise Hostel",
//           area: "MG Road",
//           price: "2000/month",
//           gender: "Male",
//           type: "Hostel",
//           photoUrl:
//               'https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg',
//           fullAddress: "1234 MG Road, Bangalore",
//           googleAddressLink: "https://maps.google.com",
//           locality: "Central Bangalore",
//           instituteName: "ABC College",
//           hasFood: true,
//           hasWifi: true,
//           hasCCTV: true,
//           hasFridge: true,
//           hasBiometric: false,
//           hasAc: true,
//           hasStudyTable: true,
//           hasWaterCooler: true,
//           imageSliderUrls: [
//             "https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg",
//             "https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg"
//           ],
//         ),
//         // Add more hostels as needed
//         Hostel(
//           name: "Sunrise Hostel",
//           area: "MG Road",
//           price: "2000/month",
//           gender: "Male",
//           type: "Hostel",
//           photoUrl:
//               'https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg',
//           fullAddress: "1234 MG Road, Bangalore",
//           googleAddressLink: "https://maps.google.com",
//           locality: "Central Bangalore",
//           instituteName: "ABC College",
//           hasFood: true,
//           hasWifi: true,
//           hasCCTV: true,
//           hasFridge: true,
//           hasBiometric: false,
//           hasAc: true,
//           hasStudyTable: true,
//           hasWaterCooler: true,
//           imageSliderUrls: [
//             "https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg",
//             "https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg"
//           ],
//         ),
//         // Add more hostels as needed
//       ];

//       if (mounted) {
//         setState(() {
//           _hostels.addAll(newHostels);
//           _filteredHostels = _hostels;
//           _currentPage++;
//           _isLoading = false;
//         });
//       }
//     });
//   }

//   void _loadHostels() {
//     // Here, you'd fetch your hostels data from a database or a service
//     _hostels = [
//       Hostel(
//         name: "Sunrise Hostel Hostel Hostel Hostel",
//         area: "MG Road",
//         price: "2000/month",
//         gender: "Male",
//         type: "Hostel",
//         photoUrl:
//             'https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg',
//         fullAddress: "1234 MG Road, Bangalore",
//         googleAddressLink: "https://maps.google.com",
//         locality: "Central Bangalore",
//         instituteName: "ABC College",
//         hasFood: true,
//         hasWifi: true,
//         hasCCTV: true,
//         hasFridge: true,
//         hasBiometric: false,
//         hasAc: true,
//         hasStudyTable: true,
//         hasWaterCooler: true,
//         imageSliderUrls: [
//           "https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg",
//           "https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg"
//         ],
//       ),
//       // Add more hostels as needed
//       Hostel(
//         name: "Sunrise Hostel",
//         area: "MG Road",
//         price: "2000/month",
//         gender: "Female",
//         type: "Hostel",
//         photoUrl:
//             'https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg',
//         fullAddress: "1234 MG Road, Bangalore",
//         googleAddressLink: "https://maps.google.com",
//         locality: "Central Bangalore",
//         instituteName: "ABC College",
//         hasFood: true,
//         hasWifi: true,
//         hasCCTV: true,
//         hasFridge: true,
//         hasBiometric: false,
//         hasAc: true,
//         hasStudyTable: true,
//         hasWaterCooler: true,
//         imageSliderUrls: [
//           "https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg",
//           "https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg"
//         ],
//       ),
//       // Add more hostels as needed
//       Hostel(
//         name: "Sunrise Hostel",
//         area: "MG Road",
//         price: "2000/month",
//         gender: "Male",
//         type: "Hostel",
//         photoUrl:
//             'https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg',
//         fullAddress: "1234 MG Road, Bangalore",
//         googleAddressLink: "https://maps.google.com",
//         locality: "Central Bangalore",
//         instituteName: "ABC College",
//         hasFood: true,
//         hasWifi: true,
//         hasCCTV: true,
//         hasFridge: true,
//         hasBiometric: false,
//         hasAc: true,
//         hasStudyTable: true,
//         hasWaterCooler: true,
//         imageSliderUrls: [
//           "https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg",
//           "https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg"
//         ],
//       ),
//       // Add more hostels as needed
//       Hostel(
//         name: "Sunrise Hostel",
//         area: "MG Road",
//         price: "2000/month",
//         gender: "Male",
//         type: "Hostel",
//         photoUrl:
//             'https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg',
//         fullAddress: "1234 MG Road, Bangalore",
//         googleAddressLink: "https://maps.google.com",
//         locality: "Central Bangalore",
//         instituteName: "ABC College",
//         hasFood: true,
//         hasWifi: true,
//         hasCCTV: true,
//         hasFridge: true,
//         hasBiometric: false,
//         hasAc: true,
//         hasStudyTable: true,
//         hasWaterCooler: true,
//         imageSliderUrls: [
//           "https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg",
//           "https://www.hostelworld.com/blog/wp-content/uploads/2018/09/hostel-room-types-5.jpg"
//         ],
//       ),
//       // Add more hostels as needed
//     ];
//   }

//   void _filterHostels(String enteredKeyword) {
//     List<Hostel> results;
//     if (enteredKeyword.isEmpty) {
//       results = _hostels;
//     } else {
//       results = _hostels
//           .where((hostel) =>
//               hostel.name
//                   .toLowerCase()
//                   .contains(enteredKeyword.toLowerCase()) ||
//               hostel.area.toLowerCase().contains(enteredKeyword.toLowerCase()))
//           .toList();
//     }

//     setState(() {
//       _filteredHostels = results;
//     });
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       print("Load more hostels");
//       _loadMoreHostels();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           CurveEdgesWidget(
//             child: Column(
//               children: [
//                 TAppBar(
//                   title: Text('${widget.cityName}, ${widget.stateName}',
//                       style: Theme.of(context)
//                           .textTheme
//                           .headlineMedium!
//                           .apply(color: TColors.white)),
//                   showBackArrow: true,
//                 ),
//                 SearchTextField(
//                   controller: _searchController,
//                   onChanged: _filterHostels,
//                   hintText: "Search for Hostel",
//                   autoFocus: false,
//                 ),
//                 const SizedBox(height: TSizes.spaceBtwItems),
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 5,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
//               child: ListView.builder(
//                 controller: _scrollController,
//                 padding: const EdgeInsets.all(0),
//                 itemCount:
//                     _filteredHostels.length + 2, // +1 for the SectionHeading
//                 itemBuilder: (context, index) {
//                   if (index == 0) {
//                     // Place the SectionHeading as the first item in the list
//                     return Padding(
//                       padding:
//                           const EdgeInsets.symmetric(horizontal: TSizes.sm),
//                       child: SectionHeading(
//                           title: "Hostels in ${widget.cityName}",
//                           showAction: false),
//                     );
//                   }
//                   index -= 1; // Adjust the index for hostel list
//                   if (index < _filteredHostels.length) {
//                     return HostelCard(
//                       hostel: _filteredHostels[index],
//                       onTap: () => Get.to(
//                           () => HostelDetailsScreen(
//                               hostel: _filteredHostels[index]),
//                           transition: Transition.fade),
//                     );
//                   } else if (index == _hostels.length) {
//                     return TShimmerEffect(
//                       width: double.infinity,
//                       height: 300,
//                     );
//                   } else {
//                     return SizedBox.shrink();
//                   }
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
