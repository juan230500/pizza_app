import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_model.dart';

///drawer generated with the store list, uses callback to update the parent widget
class StoresDrawer extends StatelessWidget {
  final List<dynamic> stores;
  final Function callbackFunction;

  const StoresDrawer({this.stores, this.callbackFunction});

  @override
  Widget build(BuildContext context) {
    DataModel dataModel = Provider.of<DataModel>(context, listen: false);
    return Drawer(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var store = stores[index];
          return ListTile(
            leading: Icon(Icons.store),
            title: Text('${store['nombre']} - ${store['codrest']}'),
            onTap: () async {
              dataModel.currentStoreData = store;
              callbackFunction(store);
              Navigator.pop(context);
            },
          );
        },
        itemCount: stores.length,
      ),
    );
  }
}
