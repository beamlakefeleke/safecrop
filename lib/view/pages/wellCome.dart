import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_crop/view/pages/FarmerHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WellComePage extends StatefulWidget {
  final String deviceId;
  final double longitude;
  final double latitude;
  WellComePage(
      {required this.deviceId,
      required this.longitude,
      required this.latitude});
  @override
  _WellComePageState createState() => _WellComePageState();
}

class _WellComePageState extends State<WellComePage> {
  // bool _hasSeenWelcomePage = false;

  @override
  void initState() {
    super.initState();
    // _checkWelcomePageSeen();
  }

  // Future<void> _checkWelcomePageSeen() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool hasSeenWelcomePage = prefs.getBool('hasSeenWelcomePage') ?? false;

  //   if (hasSeenWelcomePage) {
  //     // Navigate directly to FarmerHomepage
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => FarmerHomepage(
  //               deviceId: widget.deviceId,
  //               longitude: widget.longitude,
  //               latitude: widget.latitude)),
  //     );
  //   } else {
  //     // Update state to show welcome page
  //     setState(() {
  //       _hasSeenWelcomePage = hasSeenWelcomePage;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // While the check is being done, show a loading indicator
    // if (_hasSeenWelcomePage) {
    //   return Container(
    //     color: Colors.white,
    //     child: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 128, 200, 85),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 128, 200, 85),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(top: 200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Transform.scale(
                        scale: 5,
                        child: Image(
                          width: 70,
                          image: AssetImage(
                            "assets/b.png",
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          right: 39,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                right: 1,
                              ),
                              child: Image(
                                width: 60,
                                image: AssetImage(
                                  "assets/a.png",
                                ),
                              ),
                            ),
                            Text(
                              'Safe Crop',
                              style: TextStyle(
                                fontSize: 25,
                                color: Color.fromARGB(255, 6, 47, 21),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 100),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(5, -3),
                      blurRadius: 22,
                      spreadRadius: 6)
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(100),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Wellcome to safe crop',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: 20, bottom: 30, left: 30, right: 30),
                    child: Text(
                      'Use this app to classify crop disease and get treatment instructions ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      // SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();
                      // await prefs.setBool('hasSeenWelcomePage', true);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FarmerHomepage(
                                deviceId: widget.deviceId,
                                longitude: widget.longitude,
                                latitude: widget.latitude)),
                      );
                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontFamily: 'Bauhaus 93'),
                        ),
                      ),
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 3),
                              blurRadius: 22,
                              spreadRadius: 6)
                        ],
                        color: Color.fromARGB(255, 86, 144, 51),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
