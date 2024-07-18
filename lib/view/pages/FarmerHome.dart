// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
// import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:safe_crop/main.dart';
import 'package:safe_crop/model/account.dart';
import 'package:safe_crop/view/Pages/history.dart';
// import 'package:safe_crop/view/pages/DetectPest.dart';

// import 'package:safe_crop/view/pages/Profilepage.dart';
import 'package:safe_crop/view/pages/detectchoose.dart';
import 'package:safe_crop/view/pages/lang/AppLocalizations.dart';
import 'package:safe_crop/view/pages/newsPage.dart';
import 'package:safe_crop/view/pages/profile.dart';
import 'package:safe_crop/view/pages/showHistory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'helppage.dart';

class FarmerHomepage extends StatefulWidget {
  final String deviceId;
  final double longitude;
  final double latitude;
  FarmerHomepage({
    required this.deviceId,
    required this.longitude,
    required this.latitude,
  });

  @override
  _FarmerHomepageState createState() => _FarmerHomepageState();
}

class _FarmerHomepageState extends State<FarmerHomepage> {
  final _dbHelper = DatabaseHelper();
  String name = '';
  String area = '';
  String location = '';
  String latitude = '';
  String longitude = '';
  int newsCount = 0; // Initialize the news count


  void _onProfileUpdate(DeviceData updatedData) {
    setState(() {
      name = updatedData.name!;
      area = updatedData.area!;
      location = updatedData.location;
    });
  }
  @override
  void initState() {
    super.initState();
    _loadDataFromSharedPreferences();
    //_fetchDeviceData();
    // _loadProfileData();
   
    FirebaseFirestore.instance
        .collection('News')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        // Update the news count when the collection changes
        newsCount = snapshot.docs.length;
      });
    });
  }
   Future<void> _loadDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('name') ?? '';
      area = prefs.getString('area') ?? '';
      location = prefs.getString('location') ?? '';
      latitude = prefs.getString('latitude') ?? '';
      longitude = prefs.getString('longitude') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 128, 200, 85),
      body: Stack(
        children: [
          showprofilewidget(context),
          showGrideWidget(context, name, area, location),
          Positioned(
            top: 30, // Adjust the top position as needed
            right: 20, // Adjust the right position as needed
            child: _buildLanguageSelector(context),
          ),
          
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    String currentLanguage = 'English'; // Default language
    if (currentLocale.languageCode == 'am') {
      currentLanguage = 'Amharic';
    } else if (currentLocale.languageCode == 'or') {
      currentLanguage = 'Oromo';
    }

    return DropdownButton<Locale>(
      value: currentLocale,
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          Locale currentLocale = Localizations.localeOf(context);
          if (newLocale != currentLocale) {
            _changeLocale(context, newLocale);
          }
        }
      },
      items: [
        DropdownMenuItem(
          value: Locale('en', 'US'),
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: Locale('am', 'ET'),
          child: Text('አማርኛ'),
        ),
        DropdownMenuItem(
          value: Locale('or', 'ET'),
          child: Text('Afaan Oromo'),
        ),
        // Add other supported locales here
      ],
      // Set the hint to the currently selected language
      hint: Text(currentLanguage),
    );
  }

  void _changeLocale(BuildContext context, Locale newLocale) {
    print('Changing locale to: $newLocale');
    AppLocalizations.load(newLocale).then((appLocalization) {
      print('Locale loaded successfully');
      MyApp.setLocale(context, newLocale); // Set the locale in MyApp
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/', // Replace '/' with the route name of your home page
        (route) => false, // Remove all routes from the stack
      );
    });
  }

  Column showGrideWidget(
      BuildContext context, String name, String area, String location) {
    var localizedStrings = AppLocalizations.of(context);
    String? detect = localizedStrings?.getDetect();
    String? profile = localizedStrings?.getProfile();
    String? history = localizedStrings?.getHistory();
    String? newsHead = localizedStrings?.getnews_head();
    String? help = localizedStrings?.getHelp();
    
    return Column(
      children: [
        showheadProfilewidget(context, name, area, location),
        SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      detectchoose(deviceId: widget.deviceId)),
            );
          },
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image(
                  image: AssetImage(
                    "assets/d.png",
                  ),
                ),
                Text(
                  '${detect ?? 'Detect'}',
                  style: TextStyle(fontSize: 20),
                ),
                Icon(
                  Icons.arrow_forward_outlined,
                  size: 30,
                )
              ],
            ),
            height: 47,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 0),
                  blurRadius: 22,
                  spreadRadius: 6),
            ], color: Colors.white),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 33,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Manual()),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 3.5,
                height: MediaQuery.of(context).size.height / 7,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 0),
                      blurRadius: 22,
                      spreadRadius: 6),
                ], color: Color.fromARGB(255, 128, 200, 85)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.help_center_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${help ?? 'Help'}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewsPage(
                            latitude: widget.latitude,
                            longitude: widget.longitude,
                          )),
                );
              },
              child: Stack(
                children: [
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        height: MediaQuery.of(context).size.height / 7,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 0),
                              blurRadius: 22,
                              spreadRadius: 6,
                            ),
                          ],
                          color: Color.fromARGB(255, 128, 200, 85),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.newspaper_rounded,
                              size: 50,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${newsHead ?? 'News'}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    left: 90,
                    child: Column(
                      children: [
                        SizedBox(height: 4.0),
                        InkWell(
                          child: CircleAvatar(
                            child: Text(
                              '$newsCount',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Colors.red,
                            radius: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 33,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            deviceId: widget.deviceId,
                             onProfileUpdate: _onProfileUpdate,
                          )),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 3.5,
                height: MediaQuery.of(context).size.height / 7,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 0),
                      blurRadius: 22,
                      spreadRadius: 6),
                ], color: Color.fromARGB(255, 128, 200, 85)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_2_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${profile ?? 'Profile'}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                    
    
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShowHistory()),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 3.5,
                height: MediaQuery.of(context).size.height / 7,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 0),
                      blurRadius: 22,
                      spreadRadius: 6),
                ], color: Color.fromARGB(255, 128, 200, 85)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_toggle_off_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${history ?? 'History'}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Container showheadProfilewidget(
      BuildContext context, String name, String area, String location) {
        
    var localizedStrings = AppLocalizations.of(context);
    String? anonymous = localizedStrings?.getanonymous();
    String? unknown = localizedStrings?.getunknown();
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 3.6,
        left: 2,
      ),
      height: MediaQuery.of(context).size.height / 6,
      width: MediaQuery.of(context).size.height / 2.4,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              offset: Offset(-3, 5),
              blurRadius: 22,
              spreadRadius: 6)
        ],
        color: Color.fromARGB(255, 250, 250, 250),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person),
              backgroundColor: Colors.white,
            ),
            title: Text(
              name.isNotEmpty ? name : '${anonymous ?? 'Anonymous'}',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 6, 47, 21),
              ),
            ),
          ),
          VerticalDivider(
            // Added vertical divider
            color: Color.fromARGB(255, 6, 47, 21),
            thickness: 1,
            width: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.landscape,
                    size: 30,
                    color: Color.fromARGB(255, 6, 47, 21),
                  ),
                  Text(
                    area.isNotEmpty ? area : '${unknown ?? 'unknown'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 6, 47, 21),
                    ),
                  ),
                ],
              ),
              VerticalDivider(
                // Added vertical divider
                color: Color.fromARGB(255, 6, 47, 21),
                thickness: 1,
                width: 30,
              ),
              Column(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 30,
                    color: Color.fromARGB(255, 6, 47, 21),
                  ),
                  Text(
                    location.isNotEmpty ? location : '${unknown ?? 'unknown'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 6, 47, 21),
                    ),
                  ),
                ],
              ),
              VerticalDivider(
                // Added vertical divider
                color: Color.fromARGB(255, 6, 47, 21),
                thickness: 10,
                width: 30,
              ),
              Column(
                children: [
                  Icon(
                    Icons.countertops,
                    size: 30,
                    color: Color.fromARGB(255, 6, 47, 21),
                  ),
                  Text(
                    '$newsCount',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 6, 47, 21),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container showprofilewidget(BuildContext context) {
    var localizedStrings = AppLocalizations.of(context);
    String? safeCrop = localizedStrings?.getSafeCrop();
    return Container(
        child: Column(
      children: [
        Container(
            child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  offset: Offset(-3, 5),
                  blurRadius: 22,
                  spreadRadius: 6)
            ],
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image(
              width: 70,
              image: AssetImage(
                "assets/c.png",
              ),
            ),
            Text(
              '${safeCrop ?? 'Safe Crop'}',
              style: TextStyle(
                fontSize: 28,
                color: Color.fromARGB(255, 6, 47, 21),
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
        )),
      ],
    ));
  }
}
