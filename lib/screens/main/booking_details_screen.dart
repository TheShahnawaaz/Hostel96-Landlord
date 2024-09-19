import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hostel96_landlord/controllers/edit_listing_controller.dart';
import 'package:hostel96_landlord/controllers/hostel_controller.dart';
import 'package:hostel96_landlord/screens/main/edit_listing.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:hostel96_landlord/controllers/booking_detail_page_controller.dart';
import 'package:hostel96_landlord/controllers/user_controller.dart';
import 'package:hostel96_landlord/models/order_model.dart';
import 'package:hostel96_landlord/screens/main/hostel_details_screen.dart';
import 'package:hostel96_landlord/screens/main/my_booking.dart';
import 'package:hostel96_landlord/utils/constants/colors.dart';
import 'package:hostel96_landlord/utils/constants/sizes.dart';
import 'package:hostel96_landlord/utils/helpers/helper_functions.dart';
import 'package:hostel96_landlord/widgets/appbar.dart';
import 'package:hostel96_landlord/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetailsScreen extends StatelessWidget {
  final OrderModel order;
  final BookingDetailPageController controller =
      Get.put(BookingDetailPageController());

  BookingDetailsScreen({required this.order}) {
    controller.fetchStudentAndHostel(order);
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Column(
        children: [
          CurveEdgesWidget(
            child: Column(
              children: [
                TAppBar(
                  title: Text(
                    'Booking Details',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .apply(color: TColors.white),
                  ),
                  showBackArrow: true,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: LoadingAnimationWidget.newtonCradle(
                          color: TColors.primary, size: 75.0),
                    )
                  : ListView(
                      padding: const EdgeInsets.only(
                          bottom: TSizes.spaceBtwSections),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.defaultSpace),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: TSizes.spaceBtwItems),
                            child: Text('Hostel Details',
                                style: Theme.of(context).textTheme.titleLarge),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            final hostelController =
                                Get.put(HostelController());

                            Get.to(() => EditHostelScreen(
                                  hostel: controller.hostel.value,
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: TSizes.defaultSpace),
                            child: Card(
                              color: dark
                                  ? TColors.white.withOpacity(0.1)
                                  : TColors.white,
                              shadowColor:
                                  dark ? Colors.transparent : TColors.white,
                              child: CustomHostelTile(
                                hostel: controller.hostel.value,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: TSizes.defaultSpace),
                            child: order.isShifted
                                ? AlertBox(
                                    title:
                                        "Already shifted to ${controller.hostel.value.name}",
                                    subtitle:
                                        "${controller.student.value.firstName} have already shifted to your hostel",
                                    type: AlertType.success,
                                    icon: Icons.luggage,
                                  )
                                : AlertBox(
                                    title:
                                        'Check-in to ${controller.hostel.value.name} within 6 days',
                                    subtitle:
                                        "${controller.student.value.firstName} will check-in to the ${controller.hostel.value.name} before ${DateFormat('dd MMM yyyy').format(order.orderDateTime.add(Duration(days: 7)))}",
                                    type: AlertType.warning,
                                    icon: Icons.luggage,
                                  )),
                        MyDivider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.defaultSpace),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: TSizes.spaceBtwItems),
                            child: Text('Chosen Variation',
                                style: Theme.of(context).textTheme.titleLarge),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.defaultSpace),
                          child: Card(
                            color: dark
                                ? TColors.white.withOpacity(0.1)
                                : TColors.white,
                            shadowColor:
                                dark ? Colors.transparent : TColors.white,
                            elevation: 1,
                            margin: EdgeInsets.all(0),
                            child: ListTile(
                              selectedTileColor: TColors.primary,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              dense: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              title: Text(
                                  controller.variation.value.sharingType,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!,
                                  overflow: TextOverflow.ellipsis),
                              subtitle: Text(
                                  "Price after 1st month: ${formatAsIndianCurrency(controller.variation.value.askedPrice)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontSize: 10,
                                      ),
                                  overflow: TextOverflow.ellipsis),
                              trailing: Text(
                                formatAsIndianCurrency(
                                    controller.variation.value.finalPrice),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: TColors.primary,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        MyDivider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.defaultSpace),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: TSizes.spaceBtwItems),
                            child: Text('Student Details',
                                style: Theme.of(context).textTheme.titleLarge),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.defaultSpace),
                          child: Card(
                            color: dark
                                ? TColors.white.withOpacity(0.1)
                                : TColors.white,
                            shadowColor:
                                dark ? Colors.transparent : TColors.white,
                            elevation: 1,
                            margin: EdgeInsets.all(0),
                            child: ListTile(
                              selectedTileColor: TColors.primary,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              dense: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              title: Text(controller.student.value.fullName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!,
                                  overflow: TextOverflow.ellipsis),
                              subtitle: Text(controller.student.value.phone,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium!,
                                  overflow: TextOverflow.ellipsis),
                              trailing: IconButton(
                                icon: Icon(Icons.phone, color: TColors.primary),
                                onPressed: () {
                                  launchUrl(
                                    Uri.parse(
                                        'tel:${controller.student.value.phone}'),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(height: 10),
                        // (order.isShifted)
                        //     ? Container()
                        //     : Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: TSizes.defaultSpace),
                        //         child: AlertBox(
                        //           title: 'Request for cancellation',
                        //           subtitle:
                        //               "Please read the cancellation policy and contact Hostel96 to cancel the booking",
                        //           type: AlertType.error,
                        //           icon: Icons.cancel,
                        //         ),
                        //       ),
                        // MyDivider(),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: TSizes.defaultSpace),
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(
                        //         bottom: TSizes.spaceBtwItems),
                        //     child: Text('Payment Details',
                        //         style: Theme.of(context).textTheme.titleLarge),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: TSizes.defaultSpace),
                        //   child: PriceDetailsWidget(
                        //     originalPrice:
                        //         controller.variation.value.askedPrice,
                        //     priceDetails: controller.variation.value.finalPrice,
                        //   ),
                        // ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
