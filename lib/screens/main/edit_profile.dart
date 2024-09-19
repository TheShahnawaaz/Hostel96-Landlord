// ignore_for_file: use_key_in_widget_constructors, unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hostel96_landlord/controllers/landlord_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:hostel96_landlord/controllers/edit_profile_controller.dart';
import 'package:hostel96_landlord/controllers/user_controller.dart';
import 'package:hostel96_landlord/screens/main/account.dart';
import 'package:hostel96_landlord/utils/validators/validation.dart';
import 'package:hostel96_landlord/widgets/appbar.dart';
import 'package:hostel96_landlord/screens/main/home.dart';
import 'package:hostel96_landlord/utils/constants/colors.dart';
import 'package:hostel96_landlord/utils/constants/image_strings.dart';
import 'package:hostel96_landlord/utils/constants/sizes.dart';
import 'package:hostel96_landlord/utils/constants/text_strings.dart';
import 'package:hostel96_landlord/utils/helpers/helper_functions.dart';

import '../../widgets/widgets.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userController = LandlordController.instance;
    final controller = Get.put(EditProfileController());

    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Column(
        children: [
          CurveEdgesWidget(
            child: Column(
              children: [
                TAppBar(
                  title: Text('Edit Profile',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: TColors.white)),
                  showBackArrow: true,
                ),
                Obx(
                  () => UserProfileTile(
                    imageUrl: TImages.user,
                    name: userController.landlord.value.fullName,
                    email: userController.landlord.value.email,
                    trailing: userController.isVerifiedLandlord()
                        ? IconButton(
                            onPressed: () {
                              TLoaders.successSnackbar(
                                  title: "Account verified",
                                  message:
                                      "Your account has been verified!! Now you can add your hostel");
                              
                            },
                            icon: const Icon(Icons.check_circle,
                                size: 30, color: Colors.green),
                          )
                        : IconButton(
                            onPressed: () {
                              TLoaders.warningSnackbar(
                                  title: "Account not verified",
                                  message:
                                      "Please verify your account by filling the bank and address details");
                            },
                            icon: const Icon(Icons.error,
                                size: 30, color: Colors.redAccent),
                          ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
          Expanded(
            // flex: 1,
            child: Padding(
              //
              padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultSpace, vertical: TSizes.sm),
              child: ListView.builder(
                padding: EdgeInsets.zero,

                itemCount: 1,
                itemBuilder: (context, index) => Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      // Personal Information
                      SectionHeading(
                        title: 'Personal Information',
                        showAction: false,
                        color: dark ? TColors.white : TColors.dark,
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      ProfileTextField(
                        controller: controller.firstName,
                        validator: (value) =>
                            TValidator.validateEmptyText("First Name", value),
                        label: 'First Name',
                        icon: Iconsax.user,
                      ),
                      ProfileTextField(
                        controller: controller.lastName,
                        validator: (value) =>
                            TValidator.validateEmptyText("Last Name", value),
                        label: 'Last Name',
                        icon: Iconsax.user,
                      ),
                      ProfileTextField(
                        controller: controller.email,
                        label: 'Email',
                        icon: Iconsax.direct_right,
                        readOnly: true,
                      ),
                      ProfileTextField(
                        controller: controller.phoneNo,
                        validator: (value) => TValidator.validatePhoneNo(value),
                        label: 'Phone Number',
                        icon: Iconsax.call,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      // Bank Information
                      SectionHeading(
                        title: "Bank Information",
                        showAction: false,
                        color: dark ? TColors.white : TColors.dark,
                      ),

                      const SizedBox(height: TSizes.spaceBtwItems),
                      ProfileTextField(
                        controller: controller.bankName,
                        label: 'Bank Name',
                        icon: Iconsax.bank,
                      ),
                      ProfileTextField(
                        controller: controller.accountNumber,
                        label: 'Account Number',
                        icon: Iconsax.bank,
                      ),
                      ProfileTextField(
                        controller: controller.beneficiaryName,
                        label: 'Beneficiary Name',
                        icon: Iconsax.bank,
                      ),
                      ProfileTextField(
                        controller: controller.ifscCode,
                        label: 'IFSC Code',
                        icon: Iconsax.bank,
                      ),
                      ProfileTextField(
                        controller: controller.bankBranch,
                        label: 'Bank Branch',
                        icon: Iconsax.bank,
                      ),
                      ProfileTextField(
                        controller: controller.upiId,
                        label: 'UPI ID',
                        icon: Iconsax.bank,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      // Address Information
                      SectionHeading(
                        title: "Address Information",
                        showAction: false,
                        color: dark ? TColors.white : TColors.dark,
                      ),

                      const SizedBox(height: TSizes.spaceBtwItems),
                      ProfileTextField(
                        controller: controller.address,
                        label: 'Address',
                        icon: Iconsax.location,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => controller.updateProfile(),
                          child: const Text("Save"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool readOnly;
  final String? Function(String?)? validator;

  const ProfileTextField({
    Key? key,
    required this.controller,
    this.validator,
    required this.label,
    required this.icon,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
      child: TextFormField(
        controller: controller,
        validator: validator,
        readOnly: readOnly,
        cursorColor: TColors.primary,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: dark ? TColors.white : TColors.darkGrey,
            // fontSize: TSizes.sm,
          ),

          prefixIcon: Icon(icon, color: TColors.primary),
          fillColor: dark ? Colors.transparent : TColors.lightGrey,
          filled: true,

          // hintText: label,
          // contentPadding: const EdgeInsets.all(TSizes.sm),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: dark ? TColors.white : TColors.dark),
      ),
    );
  }
}

// builder: (context) => BottomSheet(
//   onClosing: () {},
//   builder: (context) => Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       ListTile(
//         leading: Icon(Icons.camera),
//         title: Text('Camera'),
//         onTap: () => _pickImage(ImageSource.camera),
//       ),
//       ListTile(
//         leading: Icon(Icons.image),
//         title: Text('Gallery'),
//         onTap: () => _pickImage(ImageSource.gallery),
//       ),
//     ],
//   ),
// ),
