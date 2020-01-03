import 'package:flutter/material.dart';

///shows the detail of a selected bike
class BikeScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const BikeScreen({this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de la moto'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          String key = data.keys.elementAt(index);
          return Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    key.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(data[key].toString()),
                ),
              ],
            ),
          );
        },
        itemCount: data.length,
      ),
    );
  }
}
