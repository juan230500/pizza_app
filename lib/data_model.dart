import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'http_helper.dart';

class DataModel extends ChangeNotifier {
  Map<String, dynamic> responses = {};
  bool _firstUpdate = true;
  String _currentStore = '';
  String _currentBike = '';

  Future<void> updateForm() async {
    Map<String, dynamic> update =
        await HttpHelper.getFormLastUpdate(currentBike);
    loadData(update['data']);
    firstUpdate = update['first'];
    print(responses);
  }

  void loadData(Map<String, dynamic> newData) {
    newData.forEach((k, v) {
      responses[k] = v;
    });
  }

  String get currentBike => _currentBike;

  set currentBike(String value) {
    _currentBike = value;
  }

  String get currentStore => _currentStore;

  set currentStore(String value) {
    _currentStore = value;
  }

  bool get firstUpdate => _firstUpdate;

  set firstUpdate(bool value) {
    _firstUpdate = value;
  }
}
