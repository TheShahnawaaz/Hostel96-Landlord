import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:hostel96_landlord/controllers/verify_email_controller.dart";
import "package:hostel96_landlord/screens/authentication/login.dart";
import "package:hostel96_landlord/screens/authentication/success_screen.dart";
import "package:hostel96_landlord/utils/constants/image_strings.dart";
import "package:hostel96_landlord/utils/constants/sizes.dart";
import "package:hostel96_landlord/utils/constants/text_strings.dart";
import "package:hostel96_landlord/utils/helpers/helper_functions.dart";

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(VerifyEmailController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const LoginScreen()),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // Image
              Image(
                image: const AssetImage(TImages.deliveredEmailIllustration),
                width: THelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),

              //   Text
              Text(TTexts.confirmEmail,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwItems,),
              Text(email ?? "",
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwItems,),
              Text(TTexts.confirmEmailSubTitle,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwSections,),



              SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: () => controller.checkEmailVerification(),
                  child: const Text(TTexts.tContinue),
              ),),
              const SizedBox(height: TSizes.spaceBtwItems,),
              SizedBox(width: double.infinity, child: TextButton(
                onPressed: () => controller.sendEmailVerification(),
                child: const Text(TTexts.resendEmail),
              ),),




            ],
          ),
        ),
      ),
    );
  }
}
