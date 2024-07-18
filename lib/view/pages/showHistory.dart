import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:safe_crop/model/DatabaseHelper.dart';
import 'package:safe_crop/model/pestdatabasehelper.dart';
import 'package:safe_crop/view/pages/lang/AppLocalizations.dart';

class ShowHistory extends StatefulWidget {
  const ShowHistory({Key? key}) : super(key: key);

  @override
  State<ShowHistory> createState() => _ShowHistoryState();
}

class _ShowHistoryState extends State<ShowHistory> with SingleTickerProviderStateMixin {
  
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
          title:  Text('${history ?? 'History'}'),
      ),
      body: Column(
        children: [
           Center(
            child: Text(
              '${scanHistory ?? 'Scan Historyy'}',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          TabBar(
            controller: _tabController,
            tabs:  [
           Tab(text: '${crophistory??'Crop History'}'),
              Tab(text: '${pesthistory??'Pest History'}'),
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
              padding: const EdgeInsets.all(30),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHistoryList(_cropData),
                  _buildHistoryList(_pestData),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(Future<List<Map<String, dynamic>>> data) {
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
                        ),
                        elevation: 4,
                        primary: Colors.white,
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
                        trailing: Text(
                          item['uploaded_to_firebase'] == 1 ? "updated" : "update",
                          style: TextStyle(color: Colors.red),
                        ),
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
            child: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
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
