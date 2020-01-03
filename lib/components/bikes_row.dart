import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_model.dart';

class BikesRow extends StatelessWidget {
  final Function callbackFunction;
  final List<dynamic> bikes;

  const BikesRow({this.callbackFunction, this.bikes});

  @override
  Widget build(BuildContext context) {
    DataModel dataModel = Provider.of<DataModel>(context, listen: false);

    List<Widget> bikeList = [];
    for (int i = 0; i < bikes.length; i++) {
      Widget newBike = GestureDetector(
        onTap: () async {
          dataModel.currentBikeData = bikes[i];
          callbackFunction();
        },
        child: CircleAvatar(
          child: Text('M$i'),
        ),
      );
      bikeList.add(newBike);
    }
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: bikeList,
      ),
    );
  }
}
