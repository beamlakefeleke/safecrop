import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

import '../../model/account.dart';
import 'lang/AppLocalizations.dart';
// Ensure this import points to your DatabaseHelper

class ProfilePage extends StatefulWidget {
  final String deviceId;
  final Function onProfileUpdate; // Callback to notify updates

  ProfilePage({required this.deviceId, required this.onProfileUpdate});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _dbHelper = DatabaseHelper();
  bool edit = false;
  double? latitude;
  double? longitude;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String? phoneNumbershow;

  @override
  void initState() {
    super.initState();
    _loadProfileDataFromShard();
  }

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    areaController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileDataFromShard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phoneNumbershow = prefs.getString('phoneNumber') ?? 'no phone number';
      nameController.text = prefs.getString('name') ?? '';
      areaController.text = prefs.getString('area') ?? '';
      locationController.text = prefs.getString('location') ?? '';
    });
    await _fetchDeviceDataFromSql();
  }

  Future<void> _fetchDeviceDataFromSql() async {
    DeviceData? deviceData = await _dbHelper.getDeviceData(widget.deviceId);
    if (deviceData != null) {
      setState(() {
        phoneController.text = deviceData.phoneNumber;
        nameController.text = deviceData.name ?? '';
        areaController.text = deviceData.area ?? '';
        locationController.text = deviceData.location;
        latitude = deviceData.latitude;
        longitude = deviceData.longitude;
        phoneNumbershow ??= deviceData
            .phoneNumber; // Use phone number from SharedPreferences if available
      });
    }
  }

  Future<void> _fetchLocationFromShard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? savedLatitude = prefs.getDouble('latitude');
    double? savedLongitude = prefs.getDouble('longitude');

    setState(() {
      latitude = savedLatitude;
      longitude = savedLongitude;
    });
  }

  void _updateDeviceDataToTheSharedandFirebase() async {
    print(widget.deviceId + "device id ");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? savedLatitudeString = prefs.getString('latitude');
    String? savedLongitudeString = prefs.getString('longitude');
    String? deviceId = prefs.getString("deviceId");

    double? savedLatitude = savedLatitudeString != null
        ? double.tryParse(savedLatitudeString)
        : null;
    double? savedLongitude = savedLongitudeString != null
        ? double.tryParse(savedLongitudeString)
        : null;

    if (savedLatitude != null && savedLongitude != null) {
      print('Latitude: $savedLatitude');
      print('Longitude: $savedLongitude');
      print(deviceId);
    } else {
      print('No saved latitude and longitude');
    }

    final updatedData = DeviceData(
      id: 1, // Ensure this is the correct id or fetch the id dynamically
      deviceId: deviceId.toString(),
      phoneNumber: phoneNumbershow.toString(),
      latitude: savedLatitude ?? 0.0,
      longitude: savedLongitude ?? 0.0,
      name: nameController.text,
      area: areaController.text,
      location: locationController.text,
    );

    try {
      // Upload to Firestore collection 'farmers'
      await FirebaseFirestore.instance
          .collection('farmers')
          .doc(deviceId)
          .set(updatedData.toMap());

      // Save to SharedPreferences after successful upload
      await _clearPendingUpdates(prefs); // Clear pending updates
      await prefs.setString("phoneNumber", phoneNumbershow.toString());
      // await prefs.setString("latitude", savedLatitude?.toString() ?? '0.0');
      // await prefs.setString("longitude", savedLongitude?.toString() ?? '0.0');
      await prefs.setString("name", nameController.text);
      await prefs.setString("area", areaController.text);
      await prefs.setString("location", locationController.text);
      // Notify updates
      widget.onProfileUpdate(updatedData);

      setState(() {
        edit = false;
      });
      print("Successfully saved");
      //  Fluttertoast.showToast(
      //           msg: "Successfully saved online and offline",
      //           toastLength: Toast.LENGTH_SHORT,
      //           gravity: ToastGravity.BOTTOM,
      //           timeInSecForIosWeb: 1,
      //           backgroundColor: Colors.black,
      //           textColor: Colors.white,
      //           fontSize: 16.0,
      //         );
    } catch (e) {
      print("Error updating data: $e");
    }

    await _saveDataForLaterUpdate(updatedData, prefs);
  }

  void _updateDeviceDataToTheShared() async {
    print("method is called save offline ");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    String? savedLatitudeString = prefs.getString('latitude');
    String? savedLongitudeString = prefs.getString('longitude');
    String? deviceId = prefs.getString("deviceId");
    double? savedLatitude = savedLatitudeString != null
        ? double.tryParse(savedLatitudeString)
        : null;
    double? savedLongitude = savedLongitudeString != null
        ? double.tryParse(savedLongitudeString)
        : null;

    final updatedData = DeviceData(
      id: 1, // Ensure this is the correct id or fetch the id dynamically
      deviceId: deviceId.toString(),
      phoneNumber: phoneNumbershow.toString(),
      latitude: savedLatitude ?? 0.0,
      longitude: savedLongitude ?? 0.0,
      name: nameController.text,
      area: areaController.text,
      location: locationController.text,
    );

    //save to the shared prefrence
    // Save to SharedPreferences after successful upload
    await _clearPendingUpdates(prefs); // Clear pending updates
    await prefs.setString("phoneNumber", phoneNumbershow.toString());
    await prefs.setString("latitude", (savedLatitude ?? 0.0).toString());
    await prefs.setString("longitude", (savedLongitude ?? 0.0).toString());
    await prefs.setString("name", nameController.text);
    await prefs.setString("area", areaController.text);
    await prefs.setString("location", locationController.text);
    // Notify updates
    widget.onProfileUpdate(updatedData);
    await _saveDataForLaterUpdate(updatedData, prefs);
    setState(() {
      edit = false;
      //  Fluttertoast.showToast(
      //         msg: "Successfully saved",
      //         toastLength: Toast.LENGTH_SHORT,
      //         gravity: ToastGravity.BOTTOM,
      //         timeInSecForIosWeb: 1,
      //         backgroundColor: Colors.black,
      //         textColor: Colors.white,
      //         fontSize: 16.0,
      //       );
    });
  }

  Future<void> _saveDataForLaterUpdate(
      DeviceData data, SharedPreferences prefs) async {
    // Retrieve pending updates list from SharedPreferences
    List<String> pendingUpdates = prefs.getStringList('pendingUpdates') ?? [];

    // Add new update to pending updates list
    pendingUpdates.add(jsonEncode(data.toMap()));

    // Save pending updates list to SharedPreferences
    await prefs.setStringList('pendingUpdates', pendingUpdates);

    // Notify updates
    widget.onProfileUpdate(data);
  }

  Future<void> _clearPendingUpdates(SharedPreferences prefs) async {
    // Clear pending updates list from SharedPreferences
    await prefs.remove('pendingUpdates');
  }

  @override
  Widget build(BuildContext context) {
    var localizedStrings = AppLocalizations.of(context);
    String? yourProfile = localizedStrings?.getYourProfile();
    String? profile = localizedStrings?.getProfile();
    String? update = localizedStrings?.getUpdate();
    String? name = localizedStrings?.getName();
    String? area = localizedStrings?.getArea();
    String? location = localizedStrings?.getLocation();
    String? save = localizedStrings?.getSave();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(profile ?? 'Profile'),
      ),
      backgroundColor: const Color.fromARGB(255, 128, 200, 85),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(-3, 5),
                    blurRadius: 22,
                    spreadRadius: 6,
                  ),
                ],
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height / 2.6,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Stack(
                    alignment: FractionalOffset.center,
                    children: [
                      Icon(
                        shadows: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(-3, 5),
                            blurRadius: 22,
                            spreadRadius: 6,
                          ),
                        ],
                        Icons.square,
                        size: 190,
                        color: Color.fromARGB(255, 128, 200, 85),
                      ),
                      Icon(
                        Icons.person,
                        size: 120,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Text(
                    yourProfile ?? 'Your Profile',
                    style: const TextStyle(
                      fontSize: 28,
                      color: Color.fromARGB(255, 6, 47, 21),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 63),
                  Container(
  width: MediaQuery.of(context).size.width / 1.1,
  height: 55,
  child: TextFormField(
    controller: nameController,
    enabled: edit,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your name';
      }
      return null;
    },
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.person, color: Colors.grey),
      fillColor: Colors.white,
      filled: true,
      hintText: name ?? 'Name',
    ),
  ),
),
                  const SizedBox(height: 20),
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: Row(
                      children: [
                        const Icon(Icons.phone,
                            color: Colors.grey), // Add the phone icon here
                        const SizedBox(
                            width:
                                10), // Add some space between the icon and the text
                        Text(
                          phoneNumbershow != null
                              ? phoneNumbershow!
                              : "No phone number found",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: TextField(
                      controller: areaController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      enabled: edit,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.landscape_rounded,
                            color: Colors.grey),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: area ?? 'Area',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: TextField(
                      controller: locationController,
                      enabled: edit,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_on_outlined,
                            color: Colors.grey),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: location ?? 'Location',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () async {
                      if (edit) {
                        // Check internet connectivity
                        var connectivityResult =
                            await Connectivity().checkConnectivity();
                        if (connectivityResult != ConnectivityResult.none) {
                          _updateDeviceDataToTheSharedandFirebase();
                          print("connection is online");
                        } else {
                          print("connection is offline");
                          //_updateToSharedPrefrence();
                          _updateDeviceDataToTheShared();
                        }
                      } else {
                        setState(() {
                          edit = true;
                        });
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 45,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(-3, 5),
                            blurRadius: 22,
                            spreadRadius: 6,
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          edit ? save ?? 'Save' : update ?? 'Update',
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Color.fromARGB(255, 6, 47, 21),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
