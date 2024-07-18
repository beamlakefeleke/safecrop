
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;
  late Timer _uploadTimer;

  DatabaseHelper._internal() {
    // Initialize upload timer to 24 hours
    _uploadTimer = Timer.periodic(Duration(hours: 2), (timer) {
      print("updating datas........................");
      checkAndUploadData();
    });
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'main.db');
    return await openDatabase(path, version: 2, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS cropdata (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          deviceId TEXT,
          imagePath TEXT,
          cropType TEXT,
          cropAge TEXT,
          cropTemp TEXT,
          result TEXT,
          confidence REAL,
          timestamp TEXT,
          latitude REAL,
          longitude REAL,
          uploaded_to_firebase INTEGER DEFAULT 0
        )
      ''');
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      if (oldVersion < 2) {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS cropdata_new (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            deviceId TEXT,
            imagePath TEXT,
            cropType TEXT,
            cropAge TEXT,
            cropTemp TEXT,
            result TEXT,
            confidence REAL,
            timestamp TEXT,
            latitude REAL,
            longitude REAL,
            uploaded_to_firebase INTEGER DEFAULT 0
          )
        ''');
        await db.execute('''
          INSERT INTO cropdata_new (deviceId, imagePath, cropType, cropAge, cropTemp, result, confidence, timestamp, latitude, longitude)
          SELECT deviceId, imagePath, cropType, cropAge, cropTemp, result, confidence, timestamp, latitude, longitude FROM cropdata
        ''');
        await db.execute('DROP TABLE cropdata');
        await db.execute('ALTER TABLE cropdata_new RENAME TO cropdata');
      }
    });
  }

  Future<int> insertData({
    required String imagePath,
    required String cropType,
    required String cropAge,
    required String cropTemp,
    required String result,
    required double confidence,
    required String timestamp,
    required double latitude,
    required double longitude,
    required String? deviceId, 
    required List<String> suggestions,
  }) async {
    Database db = await database;
    int id = await db.insert('cropdata', {
      'deviceId': deviceId,
      'imagePath': imagePath,
      'cropType': cropType,
      'cropAge': cropAge,
      'cropTemp': cropTemp,
      'result': result,
      'confidence': confidence,
      'timestamp': timestamp,
      'latitude': latitude,
      'longitude': longitude,
      'uploaded_to_firebase': 0,
    });

    return id;
  }

  Future<void> checkAndUploadData() async {
    bool hasConnection = await InternetConnectionChecker().hasConnection;
    if (hasConnection) {
      List<Map<String, dynamic>> pendingData = await _getPendingDataFromSQLite();
      for (var data in pendingData) {
        await _uploadDataToFirebase(data);
      }
    }
  }

  Future<List<Map<String, dynamic>>> _getPendingDataFromSQLite() async {
    Database db = await database;
    return await db.query('cropdata', where: 'uploaded_to_firebase = ?', whereArgs: [0]);
  }

  Future<void> _uploadDataToFirebase(Map<String, dynamic> data) async {
    try {

      //....................add new file 
      // final String fileName = _image!.name;
      // final Reference storageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
      // final UploadTask uploadTask = storageRef.putFile(File(_image!.path));

      // // Wait for the upload to complete
      // final TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

      // // Get the download URL
      // final String downloadUrl = await snapshot.ref.getDownloadURL();
      // ................... end of addn= new file 
      //final firebaseStorageRef = FirebaseStorage.instance.ref();
      //final imageFileRef = firebaseStorageRef.child('Detection_images/${Uuid().v4()}.jpg');
      //await imageFileRef.putFile(File(data['imagePath']));

     // final imageUrl = await imageFileRef.getDownloadURL();
      
     // data['image_url'] = imageUrl;

      final firestoreInstance = FirebaseFirestore.instance;
      await firestoreInstance.collection('Detection').add(data);

      // Update the local SQLite database after a successful upload
      Database db = await database;
      await db.update('cropdata', {'uploaded_to_firebase': 1}, where: 'id = ?', whereArgs: [data['id']]);

      print('Data uploaded to Firebase Firestore');
    } catch (error) {
      print('Error uploading data to Firebase: $error');
    }
  }
   
// Future<void> _uploadDataToFirebase11(Map<String, dynamic> data) async {
//   try {
//     // Ensure the user is authenticated
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       await FirebaseAuth.instance.signInAnonymously();
//       user = FirebaseAuth.instance.currentUser;
//     }

//     // Get the image path from the data
//     final String? imagePath = data['imagePath'];

//     if (imagePath != null && imagePath.isNotEmpty) {
//       // Convert the image path to a File
//       File imageFile = File(imagePath);

//       // Create a reference to Firebase Storage
//       final String fileName = Uuid().v4(); // Unique file name
//       final Reference storageRef = FirebaseStorage.instance.ref().child('uploads/$fileName.jpg');

//       // Upload the file to Firebase Storage
//       final UploadTask uploadTask = storageRef.putFile(imageFile);
//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         switch (snapshot.state) {
//           case TaskState.running:
//             print('Upload is running');
//             break;
//           case TaskState.paused:
//             print('Upload is paused');
//             break;
//           case TaskState.success:
//             print('Upload completed');
//             break;
//           case TaskState.canceled:
//             print('Upload canceled');
//             break;
//           case TaskState.error:
//             print('Upload error');
//             break;
//         }
//       });

//       // Wait for the upload to complete
//       final TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

//       if (snapshot.state == TaskState.success) {
//         // Get the download URL of the uploaded file
//         final String downloadUrl = await snapshot.ref.getDownloadURL();
//         data['image_url'] = downloadUrl;

//         // Add data to Firestore
//         final firestoreInstance = FirebaseFirestore.instance;
//         await firestoreInstance.collection('Detection').add(data);

//         // Update the local SQLite database after a successful upload
//         final Directory directory = await getApplicationDocumentsDirectory();
//         final String path = join(directory.path, 'crop_database.db');
//         Database db = await openDatabase(path);

//         await db.update('cropdata', {'uploaded_to_firebase': 1}, where: 'id = ?', whereArgs: [data['id']]);

//         print('Data uploaded to Firebase Firestore');
//       } else {
//         print('Upload failed with state: ${snapshot.state}');
//       }
//     }
//   } catch (error) {
//     print('Error uploading data to Firebase: $error');
//   }
// }
Future<int> deleteCropData(int id) async {
  final db = await database;
  return await db.delete(
    'cropdata', // Use the correct table name
    where: 'id = ?',
    whereArgs: [id],
  );
}

  Future<List<Map<String, dynamic>>> getCropData() async {
    Database db = await database;
    return await db.query('cropdata');
  }
}
