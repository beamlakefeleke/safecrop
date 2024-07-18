import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_crop/view/pages/CropResult.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'dart:developer' as devtools;

import '../../model/DatabaseHelper.dart';
import 'lang/AppLocalizations.dart';

class Detect extends StatefulWidget {
  final String deviceId;
  Detect({required this.deviceId});

  @override
  State<Detect> createState() => _DetectState();
}

class _DetectState extends State<Detect> {
  final dbHelper = DatabaseHelper();
  final ImagePicker _picker = ImagePicker();
  File? filePath;
  String _croptype = 'Maize'; // Default selection
  String _cropage = '1 to 5 week';
  String _croptemp = 'warm';
  String label = '';
  double confidence = 0.0;
  List<String> suggestions = [];
  DateTime now = DateTime.now();
  String timestamp = '';
  double _latitude = 0.0;
  double _longitude = 0.0;

  Future<void> _getCurrentLocation() async {
    // Check if location permissions are granted
    if (await Permission.location.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium);
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
        });
      } catch (e) {
        print("Error getting location: $e");
      }
    } else {
      // Request location permissions
      await _requestLocationPermission();
    }
  }

// Method to request location permissions
  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      // Permission granted, try getting location again
      _getCurrentLocation();
    } else {
      // Permission denied, handle accordingly
      print('Location permission denied');
    }
  }

  Future<void> _tfLteInit() async {
    String? res = await Tflite.loadModel(
      model: "assets/MaizedetectionV4.tflite",
      labels: "assets/labels.txt",
      numThreads: 1, // defaults to 1
      isAsset:
          true, // defaults to true, set to false to load resources outside assets
      useGpuDelegate:
          false, // defaults to false, set to true to use GPU delegate
    );
  }

  void chooseImages() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });

    var recognitions = await Tflite.runModelOnImage(
      path: image.path, // required
      imageMean: 0.0, // defaults to 117.0
      imageStd: 255.0, // defaults to 1.0
      numResults: 2, // defaults to 5
      threshold: 0.2, // defaults to 0.1
      asynch: true, // defaults to true
    );

    if (recognitions == null) {
      devtools.log("recognitions is Null");
      return;
    }

    setState(() {
      double confidence = recognitions[0]['confidence'] * 100;
      if (confidence >= 90) {
        label = recognitions[0]['label'].toString();
        suggestions = getLabelSuggestions(label);
        this.confidence = confidence;
      } else {
        label = "Invalid image. Please send a clear image.";
        suggestions = [];
        this.confidence = 0.0;
      }
    });
  }

  void captureImages() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });

    var recognitions = await Tflite.runModelOnImage(
      path: image.path, // required
      imageMean: 0.0, // defaults to 117.0
      imageStd: 255.0, // defaults to 1.0
      numResults: 2, // defaults to 5
      threshold: 0.2, // defaults to 0.1
      asynch: true, // defaults to true
    );

    if (recognitions == null) {
      devtools.log("recognitions is Null");
      return;
    }

    setState(() {
      double confidence = recognitions[0]['confidence'] * 100;
      if (confidence >= 90) {
        label = recognitions[0]['label'].toString();
        suggestions = getLabelSuggestions(label);
        this.confidence = confidence;
      } else {
        label = "Invalid image. Please send a clear image.";
        suggestions = [];
        this.confidence = confidence;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  void initState() {
    super.initState();
    _tfLteInit();
    _getCurrentLocation();
  }

  List<String> getLabelSuggestions(String label) {
    var localizedStrings = AppLocalizations.of(context);
    String? suggestion1 = localizedStrings?.getSuggestion1();
    String? suggestion1a = localizedStrings?.getSuggestion1a();
    String? suggestion1b = localizedStrings?.getSuggestion1b();
    String? suggestion1c = localizedStrings?.getSuggestion1c();
    String? suggestion1d = localizedStrings?.getSuggestion1d();
    String? suggestion1e = localizedStrings?.getSuggestion1e();
    String? suggestion1f = localizedStrings?.getSuggestion1f();
    String? suggestion1g = localizedStrings?.getSuggestion1g();
    String? suggestion1h = localizedStrings?.getSuggestion1h();
    String? suggestion1i = localizedStrings?.getSuggestion1i();
    String? suggestion1j = localizedStrings?.getSuggestion1j();
    String? suggestion1k = localizedStrings?.getSuggestion1k();
    String? suggestion1l = localizedStrings?.getSuggestion1l();
    String? suggestion1m = localizedStrings?.getSuggestion1m();
    String? suggestion1n = localizedStrings?.getSuggestion1n();
    String? suggestion1o = localizedStrings?.getSuggestion1o();
    String? suggestion1p = localizedStrings?.getSuggestion1p();
    String? suggestion2 = localizedStrings?.getSuggestion2();
    String? suggestion2a = localizedStrings?.getSuggestion2a();
    String? suggestion2b = localizedStrings?.getSuggestion2b();
    String? suggestion2c = localizedStrings?.getSuggestion2c();
    String? suggestion2d = localizedStrings?.getSuggestion2d();
    String? suggestion2e = localizedStrings?.getSuggestion2e();
    String? suggestion2f = localizedStrings?.getSuggestion2f();
    String? suggestion2g = localizedStrings?.getSuggestion2g();
    String? suggestion2h = localizedStrings?.getSuggestion2h();
    String? suggestion2i = localizedStrings?.getSuggestion2i();
    String? suggestion2j = localizedStrings?.getSuggestion2j();
    String? suggestion2k = localizedStrings?.getSuggestion2k();
    String? suggestion2l = localizedStrings?.getSuggestion2l();
    String? suggestion2m = localizedStrings?.getSuggestion2m();
    String? suggestion2n = localizedStrings?.getSuggestion2n();
    String? suggestion5 = localizedStrings?.getSuggestion5();
    String? suggestion5a = localizedStrings?.getSuggestion5a();
    String? suggestion5b = localizedStrings?.getSuggestion5b();
    String? suggestion5c = localizedStrings?.getSuggestion5c();
    String? suggestion5d = localizedStrings?.getSuggestion5d();
    String? suggestion5e = localizedStrings?.getSuggestion5e();
    String? suggestion5f = localizedStrings?.getSuggestion5f();
    String? suggestion5g = localizedStrings?.getSuggestion5g();
    String? suggestion5h = localizedStrings?.getSuggestion5h();
    String? suggestion5i = localizedStrings?.getSuggestion5i();
    String? suggestion5j = localizedStrings?.getSuggestion5j();

    switch (label) {
      case 'Maize Streak Virus':
        return [
          '${suggestion1}\n${suggestion1a}\n${suggestion1b}\n${suggestion1c}\n\t${suggestion1d}\n\t${suggestion1e}\n${suggestion1f}\n${suggestion1g}\n${suggestion1h}\n${suggestion1i}\n\t${suggestion1j}\n\t${suggestion1k}\n${suggestion1l}\n\t${suggestion1m}\n\t${suggestion1n}\n\t${suggestion1o}\n\t${suggestion1p}'
        ];
      case 'Maize Leaf Blight':
        return [
          '${suggestion2}\n${suggestion2a}\n${suggestion2b}\n${suggestion2c}\n${suggestion2d}\n${suggestion2e}\n${suggestion2f}\n${suggestion2g}\n${suggestion2h}\n${suggestion2i}\n${suggestion2j}\n${suggestion2k}\n${suggestion2l}\n${suggestion2m}\n${suggestion2n}'
        ];
      case 'Maize Healthy':
        return ['${suggestion5}\n${suggestion5a}\n${suggestion5b}\n${suggestion5c}\n${suggestion5d}\n${suggestion5e}\n${suggestion5f}\n${suggestion5g}\n${suggestion5h}\n${suggestion5i}\n${suggestion5j}'];
      default:
        return [];
    }
  }

  void submitData() async {
    if (confidence >= 90) {
      await dbHelper.insertData(
        imagePath: filePath?.path ?? '',
        cropType: _croptype,
        cropAge: _cropage,
        cropTemp: _croptemp,
        result: label,
        confidence: confidence,
        timestamp: now.toString(),
        latitude: _latitude,
        longitude: _longitude,
        deviceId: widget.deviceId,
        suggestions: suggestions,
      );
    }
    setState(() {
      filePath = null;
    });
  }

  void _showImageOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var localizedStrings = AppLocalizations.of(context);

        String? selectImage = localizedStrings?.getSelectImage();
        String? chooseImage = localizedStrings?.getChooseImage();
        String? captureImage = localizedStrings?.getCaptureImage();
        return AlertDialog(
          title: Text('${selectImage ?? 'Select Image'}'),
          content: SingleChildScrollView(
            child: Row(
              children: [
                Padding(padding: EdgeInsets.all(8.0)),
                Column(
                  children: [
                    GestureDetector(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image,
                            color: Color.fromARGB(255, 128, 200, 85),
                          ),
                          SizedBox(height: 8),
                          Text('${chooseImage ?? 'choose Image'}'),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        chooseImages();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    GestureDetector(
                      child: Column(
                        children: [
                          Icon(Icons.camera_alt,
                              color: Color.fromARGB(255, 128, 200, 85)),
                          SizedBox(height: 8),
                          Text('${captureImage ?? 'Capture Image'}'),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        captureImages();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // _fetchDeviceId();
    if (kDebugMode) {
      print('Device ID: ${widget.deviceId}');
    }
    var localizedStrings = AppLocalizations.of(context);
    String? detect = localizedStrings?.getDetect();
    String? Maize = localizedStrings?.getMaize();
    String? oneTofiveWeek = localizedStrings?.get1To5Week();
    String? sixTotenWeek = localizedStrings?.get6To10Week();
    String? elevenTofiftenWeek = localizedStrings?.get11To15Week();
    String? warm = localizedStrings?.getWarm();
    String? rainy = localizedStrings?.getRainy();
    String? windy = localizedStrings?.getWindy();
    String? error = localizedStrings?.getError();
    String? theImageIsValid = localizedStrings?.getTheImageIsValid();
    String? ok = localizedStrings?.getOk();
    String? wheat = localizedStrings?.getWheat();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.pop(context);
          },
        ),
        title: Text('${detect ?? 'Detect'}'),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: double.infinity, // Match parent width
              height: 400,
              // padding: const EdgeInsets.all(40.0), // Add padding
              padding: const EdgeInsets.only(top: 50),
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: _showImageOptionsDialog,
                      child: Container(
                        height: 280,
                        width: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          image: DecorationImage(
                            image: AssetImage('assets/mobile-camera-icon.png'),
                          ),
                        ),
                        child: filePath == null
                            ? const Text('')
                            : Image.file(
                                filePath!,
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 450,
              width: double.infinity,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Adjust shadow color as needed
                    offset: Offset(
                      -3,
                      5,
                    ), // Modify x and y offsets for shadow position
                    blurRadius: 22, // Control shadow blur
                    spreadRadius: 6, // Adjust shadow spread
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(120), // Curved bottom left corner
                ),
                color: Color.fromARGB(
                    255, 128, 200, 85), // Set container background color
              ),
              padding: const EdgeInsets.only(
                  top: 70, left: 50, bottom: 50, right: 50),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(-3, 5),
                          blurRadius: 22,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: _croptype,

                      items: [
                        DropdownMenuItem<String>(
                          value: 'Maize',
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.energy_savings_leaf_rounded,
                                color: Color.fromARGB(255, 128, 200, 85),
                              ), // Add icon before text
                              SizedBox(
                                  width:
                                      8), // Add some space between icon and text
                              Text('${Maize ?? 'Maize'}'),
                            ],
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Wheat',
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.energy_savings_leaf_rounded,
                                color: Color.fromARGB(255, 128, 200, 85),
                              ), // Add icon before text
                              SizedBox(
                                  width:
                                      8), // Add some space between icon and text
                              Text('${wheat ?? 'Wheat'}'),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (String? type) {
                        setState(() {
                          _croptype = type ?? ''; // Set default if null
                        });
                      },
                      dropdownColor:
                          Colors.white, // Set dropdown background color
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        color: Color.fromARGB(255, 128, 200, 85),
                      ), // Add dropdown icon
                      elevation: 8, // Add elevation
                      style: TextStyle(color: Colors.black), // Set text color
                      underline: Container(), // Remove underline
                      isExpanded: true, // Expand dropdown to fit content
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(-3, 5),
                          blurRadius: 22,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: _cropage,
                      items: [
                        DropdownMenuItem<String>(
                          value: '1 to 5 week',
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.calendar_month,
                                color: Color.fromARGB(255, 128, 200, 85),
                              ), // Add icon before text
                              SizedBox(
                                  width:
                                      8), // Add some space between icon and text
                              Text('${oneTofiveWeek ?? '1 to 5 week'}'),
                            ],
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: '6 to 10 week',
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.calendar_month,
                                  color: Color.fromARGB(255, 128, 200,
                                      85)), // Add icon before text
                              SizedBox(
                                  width:
                                      8), // Add some space between icon and text
                              Text('${sixTotenWeek ?? '6 to 10 week'}'),
                            ],
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: '11 to 15 week',
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.calendar_month,
                                  color: Color.fromARGB(255, 128, 200,
                                      85)), // Add icon before text
                              SizedBox(
                                  width:
                                      8), // Add some space between icon and text
                              Text('${elevenTofiftenWeek ?? '11 to 15 week'}'),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (String? age) {
                        setState(() {
                          _cropage = age ?? ''; // Set default if null
                        });
                      },
                      dropdownColor:
                          Colors.white, // Set dropdown background color
                      icon: Icon(
                        Icons.arrow_drop_down_circle_rounded,
                        color: Color.fromARGB(255, 128, 200, 85),
                      ), // Add dropdown icon
                      elevation: 8, // Add elevation
                      style: TextStyle(color: Colors.black), // Set text color
                      underline: Container(), // Remove underline
                      isExpanded: true, // Expand dropdown to fit content
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(-3, 5),
                          blurRadius: 22,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: _croptemp,
                      items: [
                        DropdownMenuItem<String>(
                          value: 'warm',
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.sunny_snowing,
                                color: Color.fromARGB(255, 128, 200, 85),
                              ), // Add icon before text
                              SizedBox(
                                  width:
                                      8), // Add some space between icon and text
                              Text('${warm ?? 'warm'}'),
                            ],
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'rainy',
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.sunny_snowing,
                                color: Color.fromARGB(255, 128, 200, 85),
                              ), // Add icon before text
                              SizedBox(
                                  width:
                                      8), // Add some space between icon and text
                              Text('${rainy ?? 'rainy'}'),
                            ],
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'windy',
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.sunny_snowing,
                                color: Color.fromARGB(255, 128, 200, 85),
                              ), // Add icon before text
                              SizedBox(
                                  width:
                                      8), // Add some space between icon and text
                              Text('${windy ?? 'windy'}'),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (String? temp) {
                        setState(() {
                          _croptemp = temp ?? ''; // Set default if null
                        });
                      },
                      dropdownColor:
                          Colors.white, // Set dropdown background color
                      icon: Icon(
                        Icons.arrow_drop_down_circle_rounded,
                        color: Color.fromARGB(255, 128, 200, 85),
                      ), // Add dropdown icon
                      elevation: 8, // Add elevation
                      style: TextStyle(color: Colors.black), // Set text color
                      underline: Container(), // Remove underline
                      isExpanded: true, // Expand dropdown to fit content
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    // Make the button width fill the available space
                    child: ElevatedButton(
                      onPressed: () {
                        submitData();
                        if (confidence >= 90) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Result(
                                image: filePath,
                                cropType: _croptype,
                                cropAge: _cropage,
                                cropTemp: _croptemp,
                                result: label,
                                confidence: confidence,
                                timestamp: now.toString(),
                                latitude: _latitude,
                                longtiude: _longitude,
                                deviceId: widget.deviceId,
                                suggestions: suggestions,
                              ),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('${error ?? 'Error'}'),
                                content: Text(
                                    '${theImageIsValid ?? 'The image is invalid. Please recapture the image.'}'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('${ok ?? 'OK'}'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: Text(
                        "${detect ?? 'Detect'}",
                        style: TextStyle(
                            fontSize: 20, // Adjust the font size as needed
                            fontWeight: FontWeight.bold, // Add bold font weight
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
