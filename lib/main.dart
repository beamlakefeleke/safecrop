import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:safe_crop/model/DatabaseHelper.dart';
import 'package:safe_crop/view/pages/lang/AppLocalizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:device_info/device_info.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'view/pages/splashscreen.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:safe_crop/model/pestdatabasehelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity,
  // );
  
  //  DatabaseHelper databaseHelper = DatabaseHelper();
  // await databaseHelper.checkAndUploadData();
  runApp(const MyApp());
   DatabaseHelper databaseHelper = DatabaseHelper();
  databaseHelper.checkAndUploadData();
  DatabaseHelperpest databaseHelperpest = DatabaseHelperpest();
  databaseHelperpest.checkAndUploadDatapest();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static Locale? locale;

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _deviceId = "";
  String? _phoneNumber;
  Position? _currentPosition;
  double _latitude=0.0;
  double _longitude=0.0;

  @override
  void initState() {
    super.initState();
     _signInAnonymously();
    _checkPermissionsStatus();
  }
    Future<void> _signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print('Error signing in anonymously: $e');
    }
  }

  Future<void> _checkPermissionsStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasRequestedPermissions =
        prefs.getBool('hasRequestedPermissions') ?? false;

    if (!hasRequestedPermissions) {
      await _requestPermissions();
      await prefs.setBool('hasRequestedPermissions', true);
    } else {
      // Permissions have already been requested, fetch data directly
      await _fetchDeviceId();
      await _fetchLocation();
      await _tryPasteCurrentPhone();
    }
  }

  Future<void> _requestPermissions() async {
    // Request both phone and location permissions
    Map<Permission, PermissionStatus> statuses =
        await [Permission.phone, Permission.location].request();

    // Check if location permission is granted
    if (statuses[Permission.location] == PermissionStatus.granted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
      // Save the location to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('latitude', position.latitude.toString());
      await prefs.setString('longitude', position.longitude.toString());
    }

    // Fetch device ID after permission requests
    await _fetchDeviceId();
    await _fetchLocation();
    await _tryPasteCurrentPhone();
  }

  Future<void> _fetchDeviceId() async {
    String deviceId = await getDeviceId(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('deviceId', deviceId.toString());
    setState(() {
      _deviceId = deviceId;
    });
  }

  Future<void> _fetchLocation() async {
    if (await Permission.location.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _latitude = position.latitude;
      _longitude = position.longitude;
      });
    }
  }

  Future<String> getDeviceId(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor!; // Unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId!; // Unique ID on Android
    }
  }

  Future<void> _tryPasteCurrentPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedPhoneNumber = prefs.getString('phoneNumber');

    if (storedPhoneNumber != null) {
      // Use the stored phone number
      setState(() {
        _phoneNumber = storedPhoneNumber;
      });
    } else {
      // Try to fetch the phone number using SmsAutoFill
      try {
        final autoFill = SmsAutoFill();
        final phone = await autoFill.hint;
        if (phone == null) return;
        if (!mounted) return;
        setState(() {
          _phoneNumber = phone;
        });

        // Store the phone number in SharedPreferences
        await prefs.setString('phoneNumber', phone);
      } on PlatformException catch (e) {
        print('Failed to get mobile number because of: ${e.message}');
      }
    }
  }

  void setLocale(Locale newLocale) {
    setState(() {
      MyApp.locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Device ID: $_deviceId');
      print('Phone Number: $_phoneNumber');
      print('Location: $_currentPosition');
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'BAUHS93',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('am', 'ET'), // Amharic
        const Locale('or', 'ET'), // Oromo``
      ],
      locale: MyApp.locale,
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: SplashScreen(deviceId: _deviceId, longitude: _longitude, latitude: _latitude),
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'am', 'or'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
