import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hostel96_landlord/controllers/edit_listing_controller.dart';
import 'package:hostel96_landlord/models/hostel_model.dart';
import 'package:hostel96_landlord/screens/main/home.dart';
import 'package:hostel96_landlord/utils/constants/colors.dart';
import 'package:hostel96_landlord/utils/constants/sizes.dart';
import 'package:hostel96_landlord/utils/constants/text_strings.dart';
import 'package:hostel96_landlord/utils/helpers/helper_functions.dart';
import 'package:hostel96_landlord/utils/validators/validation.dart';
import 'package:hostel96_landlord/widgets/appbar.dart';
import 'package:hostel96_landlord/widgets/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class EditHostelScreen extends StatelessWidget {
  final HostelModel hostel;

  EditHostelScreen({Key? key, required this.hostel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditHostelController controller =
        Get.put(EditHostelController(hostel));

    return Scaffold(
      body: Column(children: [
        CurveEdgesWidget(
          child: Column(
            children: [
              TAppBar(
                title: Text(
                  'Edit Listing',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .apply(color: TColors.white),
                ),
                showBackArrow: true,
              ),
              Obx(() => CustomStepper(
                    currentStep: controller.currentPage.value,
                    stepLabels: [
                      "Basic Details",
                      "Characteristics",
                      "Amenities",
                      "Address",
                      "Image Upload",
                      "Variations"
                    ],
                  )),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
          // Create a custom stepper widget with step number and step title
        ),
        Expanded(
          child: PageView(
            controller: controller.pageController,
            scrollDirection: Axis.horizontal,
            padEnds: false,
            onPageChanged: controller.onPageChanged,

            // onPageChanged: controller.onPageChanged,
            // scrollBehavior: const MaterialScrollBehavior(),
            // physics:
            //     NeverScrollableScrollPhysics(), // Disable swipe to navigate
            children: [
              EditBasicDetailsForm(controller: controller),
              EditCharacteristicsForm(controller: controller),
              EditAmenitiesForm(controller: controller),
              EditAddressVerificationForm(controller: controller),
              ImageUploadForm(),
              EditHostelVariationsForm(),
            ],
          ),
        ),
      ]),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // if (_variationFormKey.currentState!.validate()) {
              controller.submitChanges();
              // }
            },
            child: Text('Save Changes',
                style: Theme.of(context).textTheme.headlineSmall!.apply(
                      color: TColors.white,
                    )),
          ),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        onPressed: () {
          controller.nextPage();
        },
        child: const Icon(Iconsax.direct_right, color: TColors.white),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class EditBasicDetailsForm extends StatelessWidget {
  final EditHostelController controller;

  EditBasicDetailsForm({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Form(
          key: controller.basicDetailsFormKey,
          child: Obx(
            () {
              if (controller.hostel.value.city == "") {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                padding: EdgeInsets.zero,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) => Column(
                  children: [
                    SectionHeading(
                      title: 'Basic Details',
                      showAction: false,
                      color: dark ? TColors.white : TColors.dark,
                      buttonText: '< Previous',
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    TextFormField(
                      initialValue: controller.hostel.value.name,
                      decoration: const InputDecoration(
                        labelText: TTexts.hostelName,
                        hintText: TTexts.hostelHint,
                        hintStyle: TextStyle(color: TColors.darkGrey),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) =>
                          controller.updateField('name', value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the hostel name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    GestureDetector(
                      onTap: () {
                        TLoaders.cantChageSnackbar();
                      },
                      child: DropdownButtonFormField<String>(
                        value: (controller.hostel.value.city == "")
                            ? null
                            : controller.hostel.value.city,
                        decoration:
                            const InputDecoration(labelText: TTexts.city),
                        hint: const Text(TTexts.cityHint),
                        items: [
                          DropdownMenuItem<String>(
                            value: controller.hostel.value.city,
                            child: Text(controller.hostel.value.city),
                          )
                        ],
                        onChanged: null,
                        validator: (value) =>
                            value == null ? 'Please select a city' : null,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    TextFormField(
                      initialValue: controller.hostel.value.area,
                      decoration: const InputDecoration(labelText: 'Area'),
                      onChanged: (value) =>
                          controller.updateField('area', value),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    _buildSwitchListTile(
                        Iconsax.eye,
                        "Visibility",
                        controller.hostel.value.isFeatured,
                        "Do you want to show this hostel on aur main app?",
                        context,
                        "isFeatured"),
                    _buildSwitchListTile(
                      CupertinoIcons.delete,
                      "Delete",
                      controller.hostel.value.isDeleted,
                      "Do you want to delete this hostel listing?",
                      context,
                      "isDeleted",
                    ),
                  ],
                  // If city is not loading, show the city dropdown
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchListTile(
    IconData leadingIcon,
    String title,
    bool value,
    String subtitle,
    BuildContext context,
    String key,
  ) {
    final controller = EditHostelController.instance;
    return Obx(
      () => SwitchListTile(
        secondary: Icon(
          leadingIcon,
          color: TColors.primary,
        ), // Added leading icon
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle:
            Text(subtitle, style: Theme.of(context).textTheme.labelMedium),
        value: (key == "isFeatured"
            ? controller.hostel.value.isFeatured
            : (key == "isDeleted" ? controller.hostel.value.isDeleted : false)),
        activeColor: TColors.white,
        activeTrackColor: TColors.primary,
        inactiveThumbColor: TColors.black,
        inactiveTrackColor: TColors.white,
        onChanged: (bool value) {
          print("Value: $value Key: $key");
          controller.updateField(key, value);
        },
      ),
    );
  }
}

class EditCharacteristicsForm extends StatelessWidget {
  final EditHostelController controller;

  EditCharacteristicsForm({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Form(
          key: controller.characteristicsFormKey,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context, index) => Column(
              children: [
                SectionHeading(
                  title: 'Characteristics',
                  showAction: true,
                  color: THelperFunctions.isDarkMode(context)
                      ? TColors.white
                      : TColors.dark,
                  buttonText: '< Previous',
                  onButtonPressed: () {
                    controller.previousPage();
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                GestureDetector(
                  onTap: () {
                    TLoaders.cantChageSnackbar();
                  },
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                          value: (controller.hostel.value.gender == "")
                              ? null
                              : controller.hostel.value.gender,
                          decoration: const InputDecoration(
                            labelText: TTexts.gender,
                          ),
                          hint: Text(TTexts.genderHint),
                          items: const [
                            DropdownMenuItem<String>(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Both',
                              child: Text('Both'),
                            ),
                          ],
                          onChanged: null),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      DropdownButtonFormField<String>(
                        hint: const Text(TTexts.hostelOrPGHint),
                        value: (controller.hostel.value.type == "")
                            ? null
                            : controller.hostel.value.type,
                        decoration:
                            const InputDecoration(labelText: TTexts.hostelOrPG),
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'Hostel',
                            child: Text('Hostel'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'PG',
                            child: Text('PG'),
                          )
                        ],
                        onChanged: null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                TextFormField(
                  initialValue: controller.hostel.value.instituteName,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: TTexts.instituteName,
                    hintText: TTexts.instituteNameHint,
                    hintStyle: TextStyle(color: TColors.darkGrey),
                  ),
                  onChanged: (value) =>
                      controller.updateField('instituteName', value),
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: TColors.primary,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(100.0),
      //   ),
      //   onPressed: () {
      //     controller.nextPage();
      //   },
      //   child: const Icon(Iconsax.direct_right, color: TColors.white),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class EditAmenitiesForm extends StatefulWidget {
  final EditHostelController controller;

  EditAmenitiesForm({Key? key, required this.controller}) : super(key: key);

  @override
  _AmenitiesFormState createState() => _AmenitiesFormState();
}

class _AmenitiesFormState extends State<EditAmenitiesForm> {
  @override
  Widget build(BuildContext context) {
    final controller = EditHostelController.instance;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Form(
          key: controller.amenitiesFormKey,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SectionHeading(
                title: "Amenities Details",
                showAction: true,
                color: THelperFunctions.isDarkMode(context)
                    ? TColors.white
                    : TColors.dark,
                buttonText: '< Previous',
                onButtonPressed: () {
                  controller.previousPage();
                },
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              _buildSwitchListTile(
                Icons.restaurant,
                TTexts.foodAvailable,
                controller.hostel.value.hasFood,
                TTexts.foodAvailableDesc,
              ),
              _buildSwitchListTile(
                Icons.wifi,
                TTexts.wifiAvailable,
                controller.hostel.value.hasWifi,
                TTexts.wifiAvailableDesc,
              ),
              _buildSwitchListTile(
                Icons.videocam,
                TTexts.cctvAvailable,
                controller.hostel.value.hasCCTV,
                TTexts.cctvAvailableDesc,
              ),
              _buildSwitchListTile(
                Icons.kitchen,
                TTexts.fridgeAvailable,
                controller.hostel.value.hasFridge,
                TTexts.fridgeAvailableDesc,
              ),
              _buildSwitchListTile(
                Icons.fingerprint,
                TTexts.biometricAvailable,
                controller.hostel.value.hasBiometric,
                TTexts.biometricAvailableDesc,
              ),
              _buildSwitchListTile(
                Icons.ac_unit,
                TTexts.acAvailable,
                controller.hostel.value.hasAc,
                TTexts.acAvailableDesc,
              ),
              _buildSwitchListTile(
                Icons.desk,
                TTexts.studyTableAvailable,
                controller.hostel.value.hasStudyTable,
                TTexts.studyTableAvailableDesc,
              ),
              _buildSwitchListTile(
                Icons.local_drink,
                TTexts.waterCoolerAvailable,
                controller.hostel.value.hasWaterCooler,
                TTexts.waterCoolerAvailableDesc,
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: TColors.primary,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(100.0),
      //   ),
      //   onPressed: () {
      //     // if (amenitiesFormKey.currentState!.validate()) {
      //     controller.nextPage();
      //     // }
      //   },
      //   child: const Icon(Iconsax.direct_right, color: TColors.white),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSwitchListTile(
    IconData leadingIcon,
    String title,
    bool value,
    String subtitle,
  ) {
    // final controller = AddListingController.instance;
    return SwitchListTile(
      secondary: Icon(
        leadingIcon,
        color: TColors.primary,
      ), // Added leading icon
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.labelMedium),
      value: value == true, // Handle potential null values
      activeColor: TColors.white,
      activeTrackColor: TColors.primary,
      inactiveThumbColor: TColors.black,
      inactiveTrackColor: TColors.white,
      onChanged: (bool value) {
        TLoaders.cantChageSnackbar();
      },
    );
  }
}

class EditAddressVerificationForm extends StatelessWidget {
  final EditHostelController controller;

  const EditAddressVerificationForm({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Form(
          key: controller.addressVerificationFormKey,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SectionHeading(
                title: 'Address Verification',
                showAction: true,
                color: dark ? TColors.white : TColors.dark,
                buttonText: '< Previous',
                onButtonPressed: () {
                  controller.previousPage();
                },
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              TextFormField(
                initialValue: controller.hostel.value.fullAddress,
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Full Address',
                  hintText: 'Enter the full address here',
                  hintStyle: TextStyle(color: TColors.darkGrey),
                ),
                validator: (value) =>
                    TValidator.validateEmptyText('Full Address', value ?? ''),
                onChanged: (value) =>
                    controller.updateField('fullAddress', value),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                initialValue: controller.hostel.value.googleAddressLink,
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Google Maps Address Link',
                  hintText: 'Paste the Google Maps link here',
                  hintStyle: TextStyle(color: TColors.darkGrey),
                ),
                onChanged: (value) =>
                    controller.updateField('googleMapsAddressLink', value),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                initialValue: controller.hostel.value.locality,
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'Locality',
                  hintText: 'Famous place near your hostel',
                  hintStyle: TextStyle(color: TColors.darkGrey),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the locality';
                  }
                  return null;
                },
                onChanged: (value) => controller.updateField('locality', value),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: TColors.primary,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(100.0),
      //   ),
      //   onPressed: () {
      //     controller.nextPage();
      //   },
      //   child: const Icon(Iconsax.direct_right, color: TColors.white),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ImageUploadForm extends StatefulWidget {
  const ImageUploadForm({super.key});

  @override
  _ImageUploadFormState createState() => _ImageUploadFormState();
}

class _ImageUploadFormState extends State<ImageUploadForm> {
  @override
  Widget build(BuildContext context) {
    final controller = EditHostelController.instance;
    final images = controller
        .hostel.value.imageSliderUrls; // Access the images list directly

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Column(
          children: [
            SectionHeading(
              title: 'Image Upload',
              showAction: true,
              color: THelperFunctions.isDarkMode(context)
                  ? TColors.white
                  : TColors.dark,
              buttonText: '< Previous',
              onButtonPressed: () {
                controller.previousPage();
              },
            ),
            Expanded(
              child: images.isEmpty
                  ? Center(
                      child: Text(
                        'No images selected',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: images.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          // Add error handling for loading images
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: TColors.primary,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(100.0),
      //   ),
      //   onPressed: () {
      //     controller.nextPage();
      //   },
      //   child: const Icon(Iconsax.direct_right, color: TColors.white),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class EditHostelVariationsForm extends StatefulWidget {
  const EditHostelVariationsForm({Key? key}) : super(key: key);

  @override
  _HostelVariationsFormState createState() => _HostelVariationsFormState();
}

class _HostelVariationsFormState extends State<EditHostelVariationsForm> {
  @override
  Widget build(BuildContext context) {
    final controller = EditHostelController.instance;
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Form(
          key: controller.variationFormKey,
          child: Column(
            children: [
              SectionHeading(
                title: 'Hostel Variations',
                showAction: true,
                color: dark ? TColors.white : TColors.dark,
                buttonText: '< Previous',
                onButtonPressed: () {
                  controller.previousPage();
                },
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.hostel.value.hostelVariations.length,
                  itemBuilder: (context, index) {
                    final variation =
                        controller.hostel.value.hostelVariations[index];
                    return HostelVariationWidget(
                      index: index,
                      variation: variation,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HostelVariationWidget extends StatelessWidget {
  final HostelVariation variation;
  final int index;

  const HostelVariationWidget(
      {Key? key, required this.variation, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Card(
      elevation: 3,
      color: dark ? TColors.white.withOpacity(0.1) : TColors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Open a dialog to edit the final price
                print("Edit Final Price");
                TLoaders.cantChageSnackbar();
              },
              child: Column(
                children: [
                  TextFormField(
                    initialValue: variation.sharingType,
                    decoration: const InputDecoration(
                      labelText: "Variation Type",
                      hintText: "Eg. Single, Double, Triple, etc.",
                      hintStyle: TextStyle(color: TColors.darkGrey),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    enabled: false,
                    onChanged: null,
                    validator: (value) =>
                        value!.isEmpty ? "Please enter sharing type" : null,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TextFormField(
                    initialValue: (variation.askedPrice == 0)
                        ? ""
                        : variation.askedPrice.toString(),
                    decoration: const InputDecoration(
                      labelText: "Asked Price (Price you asked for)",
                      hintText: "Price per month for normal students",
                      hintStyle: TextStyle(color: TColors.darkGrey),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    keyboardType: TextInputType.number,
                    enabled: false,
                    onChanged: null,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TextFormField(
                    initialValue: (variation.basePrice == 0)
                        ? ""
                        : variation.basePrice.toString(),
                    decoration: const InputDecoration(
                      labelText: "Base Price (Price you will be paid)",
                      hintText: "",
                      hintStyle: TextStyle(color: TColors.darkGrey),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    keyboardType: TextInputType.number,
                    enabled: false,
                    onChanged: null,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TextFormField(
                    initialValue: (variation.finalPrice == 0)
                        ? ""
                        : variation.finalPrice.toString(),
                    decoration: const InputDecoration(
                      labelText: "Listing Price (Price students will pay us)",
                      hintText: "",
                      hintStyle: TextStyle(color: TColors.darkGrey),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    keyboardType: TextInputType.number,
                    enabled: false,
                    onChanged: null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            TextFormField(
              initialValue: (variation.bedCount == 0)
                  ? ""
                  : variation.bedCount.toString(),
              decoration: const InputDecoration(
                labelText: "No of Beds available",
                hintText: "Number of beds in this variation",
                hintStyle: TextStyle(color: TColors.darkGrey),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              keyboardType: TextInputType.number,
              onChanged: ((value) => EditHostelController.instance
                  .updateVariationField(
                      variation.id, int.tryParse(value) ?? 0)),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter the number of beds";
                }
                if (int.tryParse(value) == null) {
                  return "Please enter a valid number";
                }
                // Also check for zero or negative values
                if (int.tryParse(value)! < 0) {
                  return "Please enter a number greater than equal to zero";
                }
                return null;
              },
            ),
            // Include other fields similarly
            // Allow deletion only if there are more than one variations
          ],
        ),
      ),
    );
  }
}
