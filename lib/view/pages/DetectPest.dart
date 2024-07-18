
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:safe_crop/view/pages/PestResult.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'dart:developer' as devtools;

import '../../model/pestdatabasehelper.dart';
import 'lang/AppLocalizations.dart';

class DetectPest extends StatefulWidget {
  final String deviceId;
  const DetectPest({super.key, required this.deviceId});

  @override
  State<DetectPest> createState() => _DetectPestState();
}

class _DetectPestState extends State<DetectPest> {
  final dbHelper = DatabaseHelperpest();
  final ImagePicker _picker = ImagePicker();
  File? filePath;
  String _croptype = 'Maize'; // Default selection
 
  String _croptemp = 'warm';
  String label = '';
  double confidence = 0.0;
  List<String> suggestions = [];
  DateTime now = DateTime.now();
  String timestamp = '';
  double _latitude=0.0;
  double _longitude=0.0;
 

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
      model: "assets/Pestmobile.tflite",
      labels: "assets/pestlabels.txt",
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
    String? suggestion3 = localizedStrings?.getSuggestion3();
String? suggestion3a = localizedStrings?.getSuggestion3a();
String? suggestion3b = localizedStrings?.getSuggestion3b();
String? suggestion3c = localizedStrings?.getSuggestion3c();
String? suggestion3d = localizedStrings?.getSuggestion3d();
String? suggestion3e = localizedStrings?.getSuggestion3e();
String? suggestion3f = localizedStrings?.getSuggestion3f();
String? suggestion3h = localizedStrings?.getSuggestion3h();
String? suggestion3i = localizedStrings?.getSuggestion3i();
String? suggestion3j = localizedStrings?.getSuggestion3j();
String? suggestion3k = localizedStrings?.getSuggestion3k();
String? suggestion3l = localizedStrings?.getSuggestion3l();
String? suggestion3m = localizedStrings?.getSuggestion3m();
String? suggestion4 = localizedStrings?.getSuggestion4();
String? suggestion4a = localizedStrings?.getSuggestion4a();
String? suggestion4b = localizedStrings?.getSuggestion4b();
String? suggestion4c = localizedStrings?.getSuggestion4c();
String? suggestion4d = localizedStrings?.getSuggestion4d();
String? suggestion4e = localizedStrings?.getSuggestion4e();
String? suggestion4f = localizedStrings?.getSuggestion4f();
String? suggestion4g = localizedStrings?.getSuggestion4g();
String? suggestion4h = localizedStrings?.getSuggestion4h();
String? suggestion4i = localizedStrings?.getSuggestion4i();
String? suggestion4j = localizedStrings?.getSuggestion4j();
String? suggestion4k = localizedStrings?.getSuggestion4k();
String? suggestion4l = localizedStrings?.getSuggestion4l();
String? suggestion4m = localizedStrings?.getSuggestion4m();
    switch (label) {
      case 'Grasshopper':
        return ['\n${suggestion3}\n${suggestion3a}\n${suggestion3b}\n${suggestion3c}\n${suggestion3d}\n${suggestion3e}\n${suggestion3f}\n${suggestion3h}\n${suggestion3i}\n${suggestion3j}\n${suggestion3k}\n${suggestion3l}\n${suggestion3m}'];
      case 'aphids':
        return ['\n${suggestion4}\n${suggestion4a}\n${suggestion4b}\n${suggestion4c}\n${suggestion4d}\n${suggestion4e}\n${suggestion4f}\n${suggestion4g}\n${suggestion4i}\n${suggestion4j}\n${suggestion4k}\n${suggestion4l}\n${suggestion4m}'];
      default:
        return [];
    }
  }

  void submitData() async {
    if (confidence >= 90) {
      await dbHelper.insertData(
        imagePath: filePath?.path ?? '',
        cropType: _croptype,
        cropTemp: _croptemp,
        result: label,
        confidence: confidence,
        timestamp: now.toString(),
        latitude: _latitude,
        longitude: _longitude, 
        deviceId: widget.deviceId,
        suggestions:suggestions,
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
      print('Device ID: widget.deviceId');
    }
    var localizedStrings = AppLocalizations.of(context);
    String? pestDetect = localizedStrings?.getPestDetect();
    String? detect = localizedStrings?.getDetect();

    String? maize = localizedStrings?.getMaize();
   
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
        
        title:  Text('${pestDetect ?? 'Pest Detect'}'),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: double.infinity, // Match parent width
              height: 400,
              // padding: const EdgeInsets.all(40.0), // Add padding
              //padding: const EdgeInsets.only(left: 40, bottom: 0, right: 40),
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
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
                              Text('${maize ?? 'Maize'}'),
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
                              Icon(Icons
                                  .sunny_snowing, color: Color.fromARGB(255, 128, 200, 85),), // Add icon before text
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
                              Icon(Icons
                                  .sunny_snowing, color: Color.fromARGB(255, 128, 200, 85),), // Add icon before text
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
                              Icon(Icons
                                  .sunny_snowing, color: Color.fromARGB(255, 128, 200, 85),), // Add icon before text
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
                      icon: Icon(Icons.arrow_drop_down_circle_rounded, color: Color.fromARGB(255, 128, 200, 85),), // Add dropdown icon
                      elevation: 8, // Add elevation
                      style: TextStyle(color: Colors.black), // Set text color
                      underline: Container(), // Remove underline
                      isExpanded: true, // Expand dropdown to fit content
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     submitImage();
                  //   },
                  //   child: const Text("Submit"),
                  // ),
                  Container(
                    // Make the button width fill the available space
                    child: ElevatedButton(
                      onPressed: () {
                        submitData();
                        if (confidence >= 90) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PestResult(

                                image: filePath,
                                cropType: _croptype,
                                cropTemp: _croptemp,
                                result: label, 
                                confidence: confidence,
                                timestamp: now.toString(),
                                latitude: _latitude,
                                longtiude :_longitude,
                                deviceId: widget.deviceId,
                                suggestions:suggestions,
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
                          borderRadius: BorderRadius.circular(
                              0), 
                        ),
                      ),
                      child: Text(
                        "${detect??'Detect'}",
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
