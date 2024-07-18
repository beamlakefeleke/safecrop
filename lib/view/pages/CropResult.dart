import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


import 'dart:developer' as devtools;

import 'lang/AppLocalizations.dart';

class Result extends StatefulWidget {
  const Result({
    Key? key,
    required this.image,
    required this.cropAge,
    required this.cropTemp,
    required this.cropType,
    required this.result,
    required this.confidence,
    required timestamp,
    required this.latitude,
    required this.longtiude,
    required this.deviceId, 
    required this.suggestions,
  }) : super(key: key);

  final File? image;
  final String cropType;
  final String cropAge;
  final String cropTemp;
  final String result; // Define suggestion variable
  final double confidence;
  final double latitude;
  final double longtiude;
  final String? deviceId;
  final List<String> suggestions;
  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  File? filePath;

  Future<void> imageIdentifier() async {
    setState(() {
      filePath = widget.image; // Correcting setState usage
    });
  }

  @override
  void dispose() {
    super.dispose();
    //Tflite.close();
  }

  @override
  void initState() {
    super.initState();
    //_tfLiteInit();
    imageIdentifier(); // Call imageIdentifier method
  }

  @override
  Widget build(BuildContext context) {
    var localizedStrings = AppLocalizations.of(context);
    String? detectResults = localizedStrings?.getDetectResults();
    String? suggestion = localizedStrings?.getSuggestion();
    String? cropType = localizedStrings?.getCropType();
    String? cropAge = localizedStrings?.getCropAge();
    String? cropTemp = localizedStrings?.getCropTemp();
    String? timeStamp = localizedStrings?.getTimeStamp();
    String? close = localizedStrings?.getClose();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to the previous screen
              Navigator.pop(context);
            },
        ),
        
        title:  Text('${detectResults ?? 'Detect'}'),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              padding: const EdgeInsets.only(
                left: 40,
                top: 50,
                bottom: 0,
                right: 40,
              ),
              child: Column(
                children: [
                  Container(
                    height: 230,
                    width: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage('assets/upload.jpg'),
                      ),
                    ),
                    child: widget.image != null
                        ? Image.file(
                            widget.image!,
                            fit: BoxFit.fill,
                          )
                        : const Icon(
                            Icons.image,
                            size: 150.0,
                          ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
            Container(
              height: 530,
              width: double.infinity,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(-3, 5),
                    blurRadius: 22,
                    spreadRadius: 6,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(120),
                ),
                color: Color.fromARGB(255, 128, 200, 85),
              ),
              padding: const EdgeInsets.only(
                top: 30,
                left: 50,
                bottom: 50,
                right: 50,
              ),
               child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${detectResults ?? 'Detect'}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.result.toString(), // Display suggestion
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  Text(
                    widget.suggestions.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              ),
            ),
        
          ],
        ),
      ),
    );
  }
}
