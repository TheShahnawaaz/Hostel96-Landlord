import "package:flutter/material.dart";
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:hostel96_landlord/controllers/phone_auth_controller.dart";
import "package:hostel96_landlord/utils/constants/colors.dart";
import "package:hostel96_landlord/utils/constants/image_strings.dart";
import "package:hostel96_landlord/utils/constants/sizes.dart";
import "package:hostel96_landlord/utils/constants/text_strings.dart";
import "package:hostel96_landlord/utils/helpers/helper_functions.dart";
import "package:hostel96_landlord/utils/validators/validation.dart";

class PhoneLoginScreen extends StatelessWidget {
  const PhoneLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(PhoneAuthController());

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                top: TSizes.appBarHeight,
                left: TSizes.defaultSpace,
                bottom: TSizes.defaultSpace,
                right: TSizes.defaultSpace),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          height: 80,
                          image: AssetImage(dark
                              ? TImages.lightAppLogo
                              : TImages.darkAppLogo),
                        ),
                        Expanded(
                          child: Text(
                            TTexts.appName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  fontSize: 45,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwSections * 1.5,
                    ),
                    Text(TTexts.phoneAuthTitle,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(
                      height: TSizes.sm,
                    ),
                    Text(TTexts.loginSubTitle,
                        style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: TSizes.spaceBtwItems,
                  ),
                  child: Obx(() {
                    return switch (controller.state.value) {
                      PhoneAuthState.phoneNumber => Form(
                          key: controller.formKey,
                          child: Column(children: [
                            TextFormField(
                              controller: controller.phone,
                              validator: (value) =>
                                  TValidator.validatePhoneNo(value),
                              decoration: const InputDecoration(
                                labelText: TTexts.phoneNo,
                                prefixIcon: Icon(Iconsax.call),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(
                              height: TSizes.defaultSpace,
                            ),
                            const SizedBox(
                              height: TSizes.spaceBtwItems,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => controller.sendOTP(),
                                child: const Text(TTexts.sendOTP),
                              ),
                            ),
                            const SizedBox(
                              height: TSizes.spaceBtwItems,
                            ),
                            const SizedBox(
                              height: TSizes.spaceBtwItems,
                            ),
                          ]),
                        ),
                      PhoneAuthState.otp => Column(
                          children: [
                            OtpTextField(
                              numberOfFields: 6,
                              borderColor: TColors.primary,
                              //set to true to show as box or false to show as dash
                              showFieldAsBox: true,
                              //runs when a code is typed in
                              decoration: const InputDecoration(),
                              onCodeChanged: (String code) {
                                //handle validation or checks here
                                controller.otp.text = code;
                              },
                              //runs when every textfield is filled
                              onSubmit: (String verificationCode) {
                                controller.otp.text = verificationCode;
                              }, // end on
                            ),
                            const SizedBox(
                              height: TSizes.defaultSpace,
                            ),
                            const SizedBox(
                              height: TSizes.spaceBtwItems,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => controller.verifyOTP(),
                                child: const Text(TTexts.verifyOTP),
                              ),
                            ),
                            const SizedBox(
                              height: TSizes.spaceBtwItems,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                StreamBuilder<int>(
                                    stream: controller.counter.timeLeftStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var data = snapshot.data;
                                        if ((data != null) && data > 0) {
                                          return Text(
                                              'Resend OTP in ${snapshot.data}s');
                                        }
                                        return TextButton(
                                            onPressed: () {
                                              controller.sendOTP();
                                            },
                                            child: const Text("Resend now"));
                                      }
                                      return const SizedBox();
                                    }),
                              ],
                            ),
                            const SizedBox(
                              height: TSizes.spaceBtwItems,
                            ),
                          ],
                        ),
                    };
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
