import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel96_landlord/controllers/add_listing_controller.dart';
import 'package:hostel96_landlord/controllers/city_controller.dart';
import 'package:hostel96_landlord/models/city_model.dart';
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
import 'dart:io'; // Import the 'dart:io' package

class AddListingScreen extends StatelessWidget {
  const AddListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddListingController controller = Get.put(AddListingController());

    return Scaffold(
      body: Column(
        children: [
          CurveEdgesWidget(
            child: Column(
              children: [
                TAppBar(
                  title: Text(
                    'Add Listing',
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
                        "Address Verification",
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
              physics:
                  NeverScrollableScrollPhysics(), // Disable swipe to navigate
              children: [
                BasicDetailsForm(),
                CharacteristicsForm(),
                AmenitiesForm(),
                AddressVerificationForm(),
                ImageUploadForm(),
                HostelVariationsForm(),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: controller.nextPage,
      //   child: Icon(Iconsax.arrow_right_2),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class BasicDetailsForm extends StatelessWidget {
  const BasicDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AddListingController.instance;
    final cityController = Get.put(CityController());
    final city = cityController.cities;
    final basicDetailsFormKey = GlobalKey<FormState>();
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Form(
          key: basicDetailsFormKey,
          child: Obx(
            () {
              if (cityController.isLoading.value) {
                return const TAnimationLogoWidget();    
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
                      onButtonPressed: () {
                        controller.previousPage();
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    TextFormField(
                      initialValue: controller.formData['name'],
                      decoration: const InputDecoration(
                        labelText: TTexts.hostelName,
                        hintText: TTexts.hostelHint,
                        hintStyle: TextStyle(color: TColors.darkGrey),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) {
                        controller.updateField('name', value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the hostel name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    DropdownButtonFormField<String>(
                      value: (controller.formData['city'] == "")
                          ? null
                          : controller.formData['city'],
                      decoration: const InputDecoration(labelText: TTexts.city),
                      hint: const Text(TTexts.cityHint),
                      items: city.map((CityModel city) {
                        return DropdownMenuItem<String>(
                          value: city.city,
                          child: Text(city.city),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        // formData['city'] = newValue;
                        controller.updateField('city', newValue);
                      },
                      validator: (value) =>
                          value == null ? 'Please select a city' : null,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TextFormField(
                      initialValue: controller.formData['area'],
                      decoration: const InputDecoration(
                        labelText: TTexts.area,
                        hintText: TTexts.areaHint,
                        hintStyle: TextStyle(color: TColors.darkGrey),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: (value) => TValidator.validateEmptyText(
                        TTexts.area,
                        value ?? '',
                      ),
                      onChanged: (value) =>
                          controller.updateField('area', value),
                    ),
                  ],
                  // If city is not loading, show the city dropdown
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        onPressed: () {
          // Validate
          if (basicDetailsFormKey.currentState!.validate()) {
            controller.nextPage();
          }
        },
        child: const Icon(Iconsax.direct_right, color: TColors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class CharacteristicsForm extends StatelessWidget {
  CharacteristicsForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = AddListingController.instance;
    final characteristicsFormKey = GlobalKey<FormState>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Form(
          key: characteristicsFormKey,
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
                DropdownButtonFormField<String>(
                  value: (controller.formData['gender'] == "")
                      ? null
                      : controller.formData['gender'],
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
                  onChanged: (String? newValue) {
                    controller.updateField('gender', newValue);
                  },
                  validator: (value) =>
                      TValidator.validateEmptyText("Gender", value ?? ""),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                DropdownButtonFormField<String>(
                  hint: const Text(TTexts.hostelOrPGHint),
                  value: (controller.formData['type'] == "")
                      ? null
                      : controller.formData['type'],
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
                  onChanged: (String? newValue) {
                    controller.updateField('type', newValue);
                  },
                  validator: (value) =>
                      value == null ? 'Please select a type' : null,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                TextFormField(
                  initialValue: controller.formData['instituteName'],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        onPressed: () {
          if (characteristicsFormKey.currentState!.validate()) {
            controller.nextPage();
          }
        },
        child: const Icon(Iconsax.direct_right, color: TColors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// this.food
// this.hasWifi = false,
//     this.hasCCTV = false,
//     this.hasFridge = false,
//     this.hasBiometric = false,
//     this.hasAc = false,
//     this.hasStudyTable = false,
//     this.hasWaterCooler = false,

class AmenitiesForm extends StatefulWidget {
  AmenitiesForm({Key? key}) : super(key: key);

  @override
  _AmenitiesFormState createState() => _AmenitiesFormState();
}

class _AmenitiesFormState extends State<AmenitiesForm> {
  @override
  Widget build(BuildContext context) {
    final controller = AddListingController.instance;
    final amenitiesFormKey = GlobalKey<FormState>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Form(
          key: amenitiesFormKey,
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
                'hasFood',
                TTexts.foodAvailableDesc,
              ),
              _buildSwitchListTile(
                Icons.wifi,
                TTexts.wifiAvailable,
                'hasWifi',
                TTexts.wifiAvailableDesc,
              ),
              _buildSwitchListTile(
                Icons.videocam,
                TTexts.cctvAvailable,
                'hasCCTV',
                TTexts.cctvAvailableDesc,
              ),
              _buildSwitchListTile(
                Icons.kitchen,
                TTexts.fridgeAvailable,
                'hasFridge',
                TTexts.fridgeAvailableDesc,
              ),
              _buildSwitchListTile(
                Icons.fingerprint,
                TTexts.biometricAvailable,
                'hasBiometric',
                TTexts.biometricAvailableDesc,
              ),
              _buildSwitchListTile(
                Icons.ac_unit,
                TTexts.acAvailable,
                'hasAc',
                TTexts.acAvailableDesc,
              ),
              _buildSwitchListTile(
                Icons.desk,
                TTexts.studyTableAvailable,
                'hasStudyTable',
                TTexts.studyTableAvailableDesc,
              ),
              _buildSwitchListTile(
                Icons.local_drink,
                TTexts.waterCoolerAvailable,
                'hasWaterCooler',
                TTexts.waterCoolerAvailableDesc,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        onPressed: () {
          if (amenitiesFormKey.currentState!.validate()) {
            controller.nextPage();
          }
        },
        child: const Icon(Iconsax.direct_right, color: TColors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSwitchListTile(
    IconData leadingIcon,
    String title,
    String key,
    String subtitle,
  ) {
    final controller = AddListingController.instance;
    return SwitchListTile(
      secondary: Icon(
        leadingIcon,
        color: TColors.primary,
      ), // Added leading icon
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.labelMedium),
      value: controller.formData[key] ?? false, // Handle potential null values
      activeColor: TColors.white,
      activeTrackColor: TColors.primary,
      inactiveThumbColor: TColors.black,
      inactiveTrackColor: TColors.white,
      onChanged: (bool value) {
        setState(() {
          controller.updateField(key, value);
        });
      },
    );
  }
}

class AddressVerificationForm extends StatelessWidget {
  const AddressVerificationForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<
        AddListingController>(); // Make sure to use the right method to retrieve the controller
    final addressVerificationFormKey = GlobalKey<FormState>();
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Form(
          key: addressVerificationFormKey,
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
                initialValue: controller.formData['fullAddress'],
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
                initialValue: controller.formData['googleAddressLink'],
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
                initialValue: controller.formData['locality'],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        onPressed: () {
          if (addressVerificationFormKey.currentState!.validate()) {
            controller.nextPage();
          }
        },
        child: const Icon(Iconsax.direct_right, color: TColors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
    final controller = AddListingController.instance;
    final images = controller.images; // Access the images list directly

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
                        return Image.file(
                          File(images[index]),
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
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final List<XFile>? pickedImages = await picker.pickMultiImage();
              if (pickedImages != null && pickedImages.isNotEmpty) {
                setState(() {
                  controller.addImages(
                      pickedImages.map((image) => image.path).toList());
                });
              }
            },
            child: const Text('Pick Images'),
          ),
        ),
      ],
      persistentFooterAlignment: AlignmentDirectional.bottomCenter,
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        onPressed: () {
          final int imageCount = controller.images.length;

          if (imageCount < 4) {
            // Show snackbar for minimum image requirement
            TLoaders.warningSnackbar(
              title: 'Minimum Image Limit',
              message: 'You need to select at least 4 images.',
            );
          } else if (imageCount > 7) {
            // Show snackbar for maximum image limit
            TLoaders.warningSnackbar(
              title: 'Maximum Image Limit',
              message: 'You can select up to 7 images only.',
            );
          } else {
            // Proceed to the next page
            controller.nextPage();
          }
        },
        child: const Icon(Iconsax.direct_right, color: TColors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// ... other imports

class HostelVariationsForm extends StatefulWidget {
  const HostelVariationsForm({Key? key}) : super(key: key);

  @override
  _HostelVariationsFormState createState() => _HostelVariationsFormState();
}

class _HostelVariationsFormState extends State<HostelVariationsForm> {
  final _variationFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = AddListingController.instance;
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Form(
          key: _variationFormKey,
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
                  itemCount: controller.hostelVariations.length,
                  itemBuilder: (context, index) {
                    final variation = controller.hostelVariations[index];
                    return HostelVariationWidget(
                      index: index,
                      variation: variation,
                      onRemove: () {
                        setState(() {
                          controller.removeHostelVariation(index);
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_variationFormKey.currentState!.validate()) {
                controller.submitForm();
              }
            },
            child: Text('Submit Form',
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
          setState(() {
            controller.addHostelVariation(HostelVariation());
          });
        },
        child: const Icon(Icons.plus_one, color: TColors.white),
      ),
    );
  }
}

class HostelVariationWidget extends StatelessWidget {
  final HostelVariation variation;
  final VoidCallback onRemove;
  final int index;

  const HostelVariationWidget(
      {Key? key,
      required this.variation,
      required this.onRemove,
      required this.index})
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
            TextFormField(
              initialValue: variation.sharingType,
              decoration: const InputDecoration(
                labelText: "Variation Type",
                hintText: "Eg. Single, Double, Triple, etc.",
                hintStyle: TextStyle(color: TColors.darkGrey),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              onChanged: (value) => variation.sharingType = value,
              validator: (value) =>
                  value!.isEmpty ? "Please enter sharing type" : null,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            TextFormField(
              initialValue: (variation.askedPrice == 0)
                  ? ""
                  : variation.askedPrice.toString(),
              decoration: const InputDecoration(
                labelText: "Asked Price",
                hintText: "Price per month for normal students",
                hintStyle: TextStyle(color: TColors.darkGrey),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  variation.askedPrice = int.tryParse(value) ?? 0,
              validator: (value) =>
                  value!.isEmpty ? "Please enter asked price" : null,
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
              onChanged: (value) =>
                  variation.bedCount = int.tryParse(value) ?? 0,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter the number of beds";
                }
                if (int.tryParse(value) == null) {
                  return "Please enter a valid number";
                }
                // Also check for zero or negative values
                if (int.tryParse(value)! <= 0) {
                  return "Please enter a number greater than zero";
                }
                return null;
              },
            ),
            // Include other fields similarly
            // Allow deletion only if there are more than one variations
            (index > 0)
                ? IconButton(
                    icon: const Icon(CupertinoIcons.delete),
                    onPressed: onRemove,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
