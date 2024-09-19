import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hostel96_landlord/app.dart';
import 'package:hostel96_landlord/firebase_options.dart';
import 'package:hostel96_landlord/repositories/authentication_repository.dart';
import 'package:get/get.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then(
    (FirebaseApp value) => Get.put(
      AuthenticationRepository(),
    ),
  );

  runApp(const MyApp());
}




// keytool -list -v -keystore "C:\Users\shahn\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
// Alias name: androiddebugkey
// Creation date: 29-Apr-2024
// Entry type: PrivateKeyEntry
// Certificate chain length: 1
// Certificate[1]:
// Owner: C=US, O=Android, CN=Android Debug
// Issuer: C=US, O=Android, CN=Android Debug
// Serial number: 1
// Valid from: Mon Apr 29 22:59:14 IST 2024 until: Wed Apr 22 22:59:14 IST 2054
// Certificate fingerprints:
//          SHA1: 78:53:D5:9F:48:A3:58:89:F5:00:0E:ED:E5:B6:5F:5F:39:AD:44:B0
//          SHA256: E1:6B:9D:76:99:8A:8F:9A:4C:5F:74:73:7C:86:CD:DD:F7:B5:9D:2E:EC:2F:5D:15:9A:8A:C7:32:F2:63:87:9B
// Signature algorithm name: SHA1withRSA (weak)
// Subject Public Key Algorithm: 2048-bit RSA key
// Version: 1





// D:\Desktop_24_04_26\Garbage\LandlordApp>keytool -list -v -keystore "C:\Users\shahn\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
// Alias name: androiddebugkey
// Creation date: 10 Aug, 2024
// Entry type: PrivateKeyEntry
// Certificate chain length: 1
// Certificate[1]:
// Owner: CN=Shahnawaz Hussain, OU=Hostel96, O=Hostel96, L=Patna, ST=Bihar, C=IN
// Issuer: CN=Shahnawaz Hussain, OU=Hostel96, O=Hostel96, L=Patna, ST=Bihar, C=IN
// Serial number: 637bd64e
// Valid from: Sat Aug 10 02:29:22 IST 2024 until: Wed Dec 27 02:29:22 IST 2051
// Certificate fingerprints:
//          MD5:  94:B7:05:44:D3:D7:38:C3:5B:0C:DC:1B:A2:9E:27:C0
//          SHA1: 90:61:93:37:58:2D:C6:C7:CC:CF:71:30:A6:26:63:F8:C9:94:54:4D
//          SHA256: BD:59:B8:B4:B0:A8:FF:82:5B:D5:FF:80:E5:CD:25:6C:3B:56:3E:15:B9:80:74:CF:AD:D4:16:DA:42:95:B4:36
// Signature algorithm name: SHA256withRSA
// Subject Public Key Algorithm: 2048-bit RSA key
// Version: 3

// Extensions: 

// #1: ObjectId: 2.5.29.14 Criticality=false
// SubjectKeyIdentifier [
// KeyIdentifier [
// 0000: B5 C7 8F F7 B0 CE 58 B0   4B 9B 1E 2C 1E 88 78 6E  ......X.K..,..xn
// 0010: 0B CA F3 77                                        ...w
// ]
// ]

