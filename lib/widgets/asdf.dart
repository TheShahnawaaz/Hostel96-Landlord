

// class AmenitiesForm extends StatefulWidget {
//   AmenitiesForm({Key? key}) : super(key: key);

//   @override
//   _AmenitiesFormState createState() => _AmenitiesFormState();
// }

// class _AmenitiesFormState extends State<AmenitiesForm> {
//   @override
//   Widget build(BuildContext context) {
//     final controller = AddListingController.instance;
//     final amenitiesFormKey = GlobalKey<FormState>();

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: amenitiesFormKey,
//           child: ListView(
//             children: [
//               _buildCheckboxListTile(
//                 "Food Available",
//                 'hasFood',
//               ),
//               _buildCheckboxListTile(
//                 'Wifi Available',
//                 'hasWifi',
//               ),
//               _buildCheckboxListTile(
//                 'CCTV Available',
//                 'hasCCTV',
//               ),
//               _buildCheckboxListTile(
//                 'Fridge Available',
//                 'hasFridge',
//               ),
//               _buildCheckboxListTile(
//                 'Biometric Available',
//                 'hasBiometric',
//               ),
//               _buildCheckboxListTile(
//                 'AC Available',
//                 'hasAc',
//               ),
//               _buildCheckboxListTile(
//                 'Study Table Available',
//                 'hasStudyTable',
//               ),
//               _buildCheckboxListTile(
//                 'Water Cooler Available',
//                 'hasWaterCooler',
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: TColors.primary,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(100.0),
//         ),
//         onPressed: () {
//           if (amenitiesFormKey.currentState!.validate()) {
//             controller.nextPage();
//           }
//         },
//         child: const Icon(Iconsax.direct_right, color: TColors.white),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }

//   Widget _buildCheckboxListTile(String title, String key) {
//     final controller = AddListingController.instance;

//     return CheckboxListTile(
//       title: Text(title),
//       // secondary: const Icon(Icons.check_box_outline_blank),
//       subtitle: Text("Jfdfgh jhgfdfgh jhg ygfdfg",
//           style: Theme.of(context).textTheme.labelMedium),
//       value: controller.formData[key],
//       onChanged: (bool? value) {
//         setState(() {
//           controller.updateField(key, value);
//         });
//       },
//     );
//   }
// }