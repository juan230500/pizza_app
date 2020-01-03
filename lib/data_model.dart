import 'package:flutter/cupertino.dart';

import 'http_helper.dart';

///stores global variables of the app
class DataModel extends ChangeNotifier {
  Map<String, dynamic> responses = {};
  Map<String, dynamic> currentStoreData;
  Map<String, dynamic> currentBikeData;

  ///sends a request to get the last register data of the current bike
  Future<void> updateForm() async {
    Map<String, dynamic> update =
        await HttpHelper.getFormLastUpdate(currentBikeData['placa']);
    loadData(update['data']);
  }

  ///uses the new data as a map to fill the global responses
  void loadData(Map<String, dynamic> newData) {
    newData.forEach((k, v) {
      responses[k] = v;
    });
  }
}
