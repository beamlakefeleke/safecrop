// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FarmerHome.dart';
import 'wellCome.dart';

class SplashScreen extends StatefulWidget {
  final String deviceId;
  final double longitude;
  final double latitude;

  SplashScreen({
    required this.deviceId,
    required this.longitude,
    required this.latitude,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnWelcomePageSeen();
  }

  Future<void> _navigateBasedOnWelcomePageSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenWelcomePage = prefs.getBool('hasSeenWelcomePage') ?? false;

    if (hasSeenWelcomePage) {
      _navigateToHomePage();
    } else {
      _showSplashThenWelcome();
    }
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FarmerHomepage(
          deviceId: widget.deviceId,
          longitude: widget.longitude,
          latitude: widget.latitude,
        ),
      ),
    );
  }

  void _showSplashThenWelcome() {
    Timer(Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenWelcomePage', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WellComePage(
            deviceId: widget.deviceId,
            longitude: widget.longitude,
            latitude: widget.latitude,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 128, 200, 85),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              width: 90,
              image: AssetImage("assets/a.png"),
            ),
            SizedBox(height: 8),
            Text(
              'Safe Crop',
              style: TextStyle(
                fontSize: 32,
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
