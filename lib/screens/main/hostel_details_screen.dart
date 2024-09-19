// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:hostel96_landlord/models/hostel_model.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HostelDetailsScreen extends StatelessWidget {
//   final Hostel hostel;
//   HostelDetailsScreen({Key? key, required this.hostel}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(hostel.name),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             CarouselSlider(
//               options: CarouselOptions(height: 200.0),
//               items: hostel.imageSliderUrls
//                   .map((item) => Container(
//                         child: Center(
//                             child: Image.network(item,
//                                 fit: BoxFit.cover, width: 1000)),
//                       ))
//                   .toList(),
//             ),
//             ListTile(title: Text('Hostel Name'), subtitle: Text(hostel.name)),
//             ListTile(
//                 title: Text('Call'),
//                 trailing: IconButton(icon: Icon(Icons.call), onPressed: () {})),
//             ListTile(
//                 title: Text('Full Address'),
//                 subtitle: Text(hostel.fullAddress)),
//             ListTile(
//                 title: Text('Google Maps Link'),
//                 trailing: IconButton(
//                     icon: Icon(Icons.map),
//                     onPressed: () => (Uri.parse(hostel.googleAddressLink)))),
//             ListTile(title: Text('Price'), subtitle: Text(hostel.price)),
//             ListTile(title: Text('Locality'), subtitle: Text(hostel.locality)),
//             ListTile(
//                 title: Text('Nearby Institute/College'),
//                 subtitle: Text(hostel.instituteName)),
//             ListTile(title: Text('Gender'), subtitle: Text(hostel.gender)),
//             ListTile(
//                 title: Text('Food'),
//                 subtitle: Text(hostel.hasFood ? "Available" : "Not Available")),
//             ListTile(
//                 title: Text('WiFi'),
//                 subtitle: Text(hostel.hasWifi ? "Available" : "Not Available")),
//             ListTile(
//                 title: Text('CCTV'),
//                 subtitle: Text(hostel.hasCCTV ? "Available" : "Not Available")),
//             ListTile(
//                 title: Text('Fridge'),
//                 subtitle:
//                     Text(hostel.hasFridge ? "Available" : "Not Available")),
//             ListTile(
//                 title: Text('Biometric Access'),
//                 subtitle:
//                     Text(hostel.hasBiometric ? "Available" : "Not Available")),
//             ListTile(
//                 title: Text('AC'),
//                 subtitle: Text(hostel.hasAc ? "Available" : "Not Available")),
//             ListTile(
//                 title: Text('Study Table'),
//                 subtitle:
//                     Text(hostel.hasStudyTable ? "Available" : "Not Available")),
//             ListTile(
//                 title: Text('Water Cooler'),
//                 subtitle: Text(
//                     hostel.hasWaterCooler ? "Available" : "Not Available")),
//           ],
//         ),
//       ),
//     );
//   }
// }
