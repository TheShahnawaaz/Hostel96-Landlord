import 'package:hostel96_landlord/models/banner_model.dart';
import 'package:hostel96_landlord/models/hostel_model.dart';
import 'package:hostel96_landlord/utils/constants/image_strings.dart';

class MyDummyData {
  static final List<BannerModel> banners = [
    BannerModel(
      imageUrl: TImages.banner1,
      targetScreen: '/city-list',
      isExternalLink: false,
      externalLink: '',
      isActive: true,
      name: 'Zero Brokerage',
      order: 1,
      inMain: false,
      isClickable: false,
    ),
    BannerModel(
      imageUrl: TImages.banner2,
      targetScreen: '/city-list',
      isExternalLink: false,
      externalLink: '',
      isActive: true,
      name: 'Promote your Hostel',
      order: 2,
      inMain: false,
      isClickable: false,
    ),
    BannerModel(
      imageUrl: TImages.banner3,
      targetScreen: '/city-list',
      isExternalLink: false,
      externalLink: '',
      isActive: true,
      name: 'Find your Hostel',
      order: 3,
      inMain: false,
      isClickable: false,
    ),
  ];

  //   String id;
  // final String name;
  // final String city;
  // final String area;
  // final String gender;
  // final String type;
  // final String fullAddress;
  // final String googleAddressLink;
  // final String locality;
  // final String instituteName;
  // final bool hasFood;
  // final bool hasWifi;
  // final bool hasCCTV;
  // final bool hasFridge;
  // final bool hasBiometric;
  // final bool hasAc;
  // final bool hasStudyTable;
  // final bool hasWaterCooler;
  // List<HostelVariation> hostelVariations;
  // final List<String> imageSliderUrls;
  // final String landlordId;
  // final bool isVerified;
  // final bool isDeleted;
  // final bool isFeatured;

  static final List<HostelModel> hostels = [
    HostelModel(
      id: 'yENjneHpBnxaHyQZfIbA',
      name: 'Hostel 1',
      city: 'City 1',
      area: 'Area 1',
      gender: 'Male',
      type: 'Hostel',
      fullAddress: 'Full Address 1',
      googleAddressLink: 'Google Address Link 1',
      locality: 'Locality 1',
      instituteName: 'Institute Name 1',
      hasFood: true,
      hasWifi: true,
      hasCCTV: true,
      hasFridge: true,
      hasBiometric: true,
      hasAc: true,
      hasStudyTable: true,
      hasWaterCooler: true,
      hostelVariations: [
        HostelVariation(
          sharingType: 'Single',
          askedPrice: 10000,
          finalPrice: 9000,
          bedCount: 1,
        ),
        HostelVariation(
          sharingType: 'Double',
          askedPrice: 15000,
          finalPrice: 14000,
          bedCount: 2,
        ),
        HostelVariation(
          sharingType: 'Triple',
          askedPrice: 20000,
          finalPrice: 19000,
          bedCount: 3,
        ),
      ],
      imageSliderUrls: [
        TImages.banner1,
        TImages.banner2,
        TImages.banner3,
      ],
      landlordId: '1',
      isVerified: true,
      isDeleted: false,
      isFeatured: true,
    ),
  ];
}
