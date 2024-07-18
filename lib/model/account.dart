import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class DatabaseHelper {
  static Database? _database;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'my_database.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE device_data(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            deviceId TEXT,
            phoneNumber TEXT,
            latitude REAL,
            longitude REAL,
            name TEXT,
            area TEXT,
            location TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertDeviceData(DeviceData deviceData) async {
    final db = await database;
    try {
      await db.insert('device_data', deviceData.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print("Error inserting data: $e");
    }
  }

  Future<void> updateDeviceData(DeviceData deviceData) async {
    final db = await database;
    try {
      await db.update(
        'device_data',
        deviceData.toMap(),
        where: 'id = ?',
        whereArgs: [deviceData.id],
      );
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  // Future<DeviceData?> getDeviceData(String deviceId) async {
  //   print('calling this method...');
  //   final db = await database;
  //   try {
  //     final List<Map<String, dynamic>> maps =
  //         await db.query('device_data', where: 'deviceId = ?', whereArgs: [deviceId]);
  //     if (maps.isNotEmpty) {
  //       return DeviceData.fromMap(maps.first);
  //     }
  //   } catch (e) {
  //     print("Error retrieving data: $e");
  //   }
  //   return null;
  // }
  Future<DeviceData?> getDeviceData(String deviceId) async {
  print('Calling getDeviceData with deviceId: $deviceId...');
  final db = await database;
  try {
    final List<Map<String, dynamic>> maps = await db.query(
      'device_data',
      where: 'deviceId = ?',
      whereArgs: [deviceId],
    );

    if (maps.isNotEmpty) {
      print('Device data found: ${maps.first}');
      return DeviceData.fromMap(maps.first);
    } else {
      print('No device data found for deviceId: $deviceId');
    }
  } catch (e) {
    print("Error retrieving data: $e");
  }
  return null;
}


  Future<List<DeviceData>> getAllDeviceData() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('device_data');
      return List.generate(maps.length, (i) {
        return DeviceData.fromMap(maps[i]);
      });
    } catch (e) {
      print("Error retrieving data: $e");
      return [];
    }
  }

  Future<void> closeDatabase() async {
    final db = await database;
    db.close();
  }

  Future<void> uploadDataToFirebase() async {
    final List<DeviceData> deviceDataList = await getAllDeviceData();
    for (DeviceData deviceData in deviceDataList) {
      try {
        await _firestore.collection('account').add(deviceData.toMap());
        print('Data uploaded successfully for device: ${deviceData.deviceId}');
      } catch (e) {
        print('Error uploading data: $e');
      }
    }
  }

  void startUploadTask() {
    Timer.periodic(Duration(minutes: 2), (timer) async {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        await uploadDataToFirebase();
      } else {
        print('No internet connection');
      }
    });
  }
}

class DeviceData {
  final int? id;  // id is nullable to allow auto-increment
  final String deviceId;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final String? name;
  final String? area;
  final String location;

  DeviceData({
    this.id,
    required this.deviceId,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    this.name,
    this.area,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deviceId': deviceId,
      'phoneNumber': phoneNumber,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'area': area,
      'location': location,
    };
  }

  factory DeviceData.fromMap(Map<String, dynamic> map) {
    return DeviceData(
      id: map['id'],
      deviceId: map['deviceId'],
      phoneNumber: map['phoneNumber'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      name: map['name'],
      area: map['area'],
      location: map['location'],
    );
  }
}
