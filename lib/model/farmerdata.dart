import 'package:flutter/material.dart';

class FarmerData extends ChangeNotifier {
  String name = '';
  String phoneNumber = '';
  String area = '';

  void updateData({required String name, required String phoneNumber, required String area}) {
    this.name = name;
    this.phoneNumber = phoneNumber;
    this.area = area;
    notifyListeners(); // Notify listeners of data changes
  }
}
