import 'package:flutter/material.dart';

class ReportsModel extends ChangeNotifier {
  ReportsModel();

  late int _userId;
  late String _code;
  late List<int> _fightIds;

  int get userId => _userId;
  String get code => _code;
  List<int> get fightIds => _fightIds;

  void setUserId(int id) {
    _userId = id;
  }

  void setReportCode(String code) {
    _code = code;
  }

  void setFightIds(List<int> fightIds) {
    _fightIds = fightIds;
  }
}