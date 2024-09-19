import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel96_landlord/controllers/hostel_controller.dart';
import 'package:hostel96_landlord/controllers/landlord_controller.dart';
import 'package:hostel96_landlord/screens/main/add_listing.dart';
import 'package:hostel96_landlord/screens/main/edit_listing.dart';
// import 'package:hostel96_landlord/screens/main/edit_listing.dart';
import 'package:hostel96_landlord/utils/constants/colors.dart';
import 'package:hostel96_landlord/utils/constants/image_strings.dart';
import 'package:hostel96_landlord/utils/constants/sizes.dart';
import 'package:hostel96_landlord/widgets/appbar.dart';
import 'package:hostel96_landlord/widgets/hostel_card.dart';
import 'package:hostel96_landlord/widgets/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// PageView Widget
// Refesh Imdicator

class ListingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hostelController = Get.put(HostelController());
    hostelController.fetchHostelDetailsOfLandlord();
    return Scaffold(
      body: Column(
        children: [
          CurveEdgesWidget(
            child: Column(
              children: [
                TAppBar(
                  title: Text(
                    'My Listings',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .apply(color: TColors.white),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
              child: Obx(() {
                if (hostelController.isLoading.value) {
                  return TAnimationLogoWidget();
                } else if (hostelController.hostelsOfLandlord.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   TImages.empty,
                        //   height: 200,
                        // ),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        Text(
                          'No Listings Found',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: hostelController.hostelsOfLandlord.length,
                    itemBuilder: (context, index) {
                      final hostel = hostelController.hostelsOfLandlord[index];
                      return HostelCard(
                        hostel: hostel,
                        onTap: () {
                          Get.to(() => EditHostelScreen(hostel: hostel));
                        },
                      );
                    },
                  );
                }
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add Listing
          if (LandlordController.instance.isVerifiedLandlord() == false) {
            TLoaders.warningSnackbar(
                title: "Account not verified!",
                message:
                    "Please verify your account by filling bank and address details in the profile section.");
            return;
          }

          Get.to(() => AddListingScreen());
        },
        child: Icon(Iconsax.add),
        tooltip: 'Add Listing',
        backgroundColor: TColors.primary,
        foregroundColor: TColors.white,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
      ),
    );
  }
}
