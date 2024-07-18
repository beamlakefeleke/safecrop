import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safe_crop/model/DatabaseHelper.dart';
import 'package:safe_crop/model/pestdatabasehelper.dart';
import 'package:sqflite/sqflite.dart';

import 'lang/AppLocalizations.dart';

class CropHistoryPage extends StatefulWidget {
  const CropHistoryPage({Key? key}) : super(key: key);

  @override
  State<CropHistoryPage> createState() => _CropHistoryPageState();
}

class _CropHistoryPageState extends State<CropHistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Map<String, dynamic>>> _cropData;
  late Future<List<Map<String, dynamic>>> _pestData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _cropData = _getDataFromDatabase('crop');
    _pestData = _getDataFromDatabase('pest');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _getDataFromDatabase(String dataType) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    DatabaseHelperpest dbHelperpest = DatabaseHelperpest();
    if (dataType == 'crop') {
      return dbHelper.getCropData();
    } else if (dataType == 'pest') {
      return dbHelperpest.getPestData();
    } else {
      return [];
    }
  }

  Future<Uint8List?> _loadImage(String? imagePath) async {
    if (imagePath == null) return null;
    File imageFile = File(imagePath);
    if (await imageFile.exists()) {
      return await imageFile.readAsBytes();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var localizedStrings = AppLocalizations.of(context);

    String? history = localizedStrings?.getHistory();
    String? scanHistory = localizedStrings?.getScanHistory();
    String? crophistory = localizedStrings?.getCropHistory();
    String? pesthistory = localizedStrings?.getPestHistory();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 50), // Set the height of the AppBar
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('${history ?? 'History'}'),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/d.png',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 10),
                Text(
                  '${scanHistory ?? 'Scan History'}',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: '${crophistory ?? 'Crop History'}'),
              Tab(text: '${pesthistory ?? 'Pest History'}'),
            ],
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(-3, 5),
                    blurRadius: 70,
                    spreadRadius: 6,
                  ),
                ],
                color: Color.fromARGB(255, 128, 200, 85),
              ),
              padding: const EdgeInsets.only(
                top: 30,
                left: 30,
                bottom: 50,
                right: 30,
              ),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHistoryList(_cropData, 'crop'),
                  _buildHistoryList(_pestData, 'pest'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(Future<List<Map<String, dynamic>>> data, String dataType) {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: data,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        List<Map<String, dynamic>> dataList = snapshot.data ?? [];
        return ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> item = dataList[index];
            return FutureBuilder<Uint8List?>(
              future: _loadImage(item['imagePath']),
              builder: (context, imageSnapshot) {
                Uint8List? imageBytes = imageSnapshot.data;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) {
                            return DetailPage(data: item);
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ), backgroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: Colors.black26,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: imageBytes != null
                          ? MemoryImage(imageBytes)
                          : AssetImage('assets/4.png') as ImageProvider,
                      ),
                      title: Text(item['cropType'] ?? 'Unknown Crop Type'),
                      subtitle: Text(item['timestamp'] ?? 'Unknown Timestamp'),
                      trailing: item['uploaded_to_firebase'] == 1
                        ? IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteData(item['id'], dataType);
                            },
                          )
                        : Text("update"),
                    ),
                  ),
                );
              },
            );
          },
        );
      }
    },
  );
}


  void _deleteData(int id, String dataType) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    DatabaseHelperpest dbHelperpest = DatabaseHelperpest();
    if (dataType == 'crop') {
      await dbHelper.deleteCropData(id);
      setState(() {
        _cropData = _getDataFromDatabase('crop');
      });
    } else if (dataType == 'pest') {
      await dbHelperpest.deletePestData(id);
      setState(() {
        _pestData = _getDataFromDatabase('pest');
      });
    }
  }
}

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Card(
          elevation: 6,
          child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            height: 300,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder<Uint8List?>(
                    future: _loadImage(data['imagePath']),
                    builder: (context, imageSnapshot) {
                      Uint8List? imageBytes = imageSnapshot.data;
                      return imageBytes != null
                          ? Image.memory(imageBytes, width: 100, height: 100)
                          : Text('No image available');
                    },
                  ),
                  Text('Crop Type: ${data['cropType'] ?? 'N/A'}'),
                  Text('Crop Age: ${data['cropAge'] ?? 'N/A'}'),
                  Text('Crop Temp: ${data['cropTemp'] ?? 'N/A'}'),
                  Text('Suggestion: ${data['suggestion'] ?? 'N/A'}'),
                  Text('Confidence: ${data['result'] ?? 'N/A'}'),
                  Text('Timestamp: ${data['timestamp'] ?? 'N/A'}'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Uint8List?> _loadImage(String? imagePath) async {
    if (imagePath == null) return null;
    File imageFile = File(imagePath);
    if (await imageFile.exists()) {
      return await imageFile.readAsBytes();
    }
    return null;
  }
}
