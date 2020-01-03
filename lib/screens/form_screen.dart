import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/form_list.dart';
import '../data_model.dart';
import '../http_helper.dart';
import 'bike_screen.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  List<dynamic> fields = [];
  List<dynamic> stores = [];
  bool loadingStores = true;
  bool waitingBike = true;
  bool loadingBike = true;
  String currentStore = 'Seleccione una tienda';
  Map<String, dynamic> currentBikeData;
  List<dynamic> bikes = [];

  Future<void> loadFields() async {
    fields = await HttpHelper.getFormFields();
  }

  Future<void> loadStores() async {
    loadingStores = true;
    stores = await HttpHelper.getStores();
    loadingStores = false;
    setState(() {});
  }

  Widget bikesRowBuilder(DataModel dataModel) {
    List<Widget> bikeList = [];
    for (int i = 0; i < bikes.length; i++) {
      Widget newBike = GestureDetector(
        onTap: () async {
          currentBikeData = bikes[i];
          dataModel.currentBike = currentBikeData['placa'];
          dataModel.firstUpdate = true;
          setState(() {
            waitingBike = false;
            loadingBike = true;
          });
          await dataModel.updateForm();
          loadingBike = false;
          setState(() {});
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

  Widget formListValidated() {
    if (waitingBike)
      return Center(child: Text('Seleccione una moto'));
    else if (loadingBike)
      return Center(child: Text('Cargando datos'));
    else
      return FormList(fields: fields);
  }

  @override
  void initState() {
    loadFields();
    loadStores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataModel dataModel = Provider.of<DataModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.motorcycle),
              onPressed: () {
                if (waitingBike || loadingBike) {
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BikeScreen(
                      data: currentBikeData,
                    ),
                  ),
                );
              }),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.store),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text('$currentStore'),
      ),
      drawer: loadingStores
          ? null
          : Drawer(
              child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                var store = stores[index];
                return ListTile(
                  leading: Icon(Icons.store),
                  title: Text('${store['nombre']} - ${store['codrest']}'),
                  onTap: () async {
                    dataModel.currentStore = store['codrest'];
                    bikes = await HttpHelper.getBikes(store['codrest']);
                    Navigator.pop(context);
                    setState(() {
                      currentStore = store['nombre'];
                      waitingBike = true;
                    });
                  },
                );
              },
              itemCount: stores.length,
            )),
      body: Column(
        children: <Widget>[
          bikesRowBuilder(dataModel),
          formListValidated(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          dataModel.responses['moto'] = dataModel.currentBike;
          dataModel.responses['tienda'] = dataModel.currentStore;
          print(dataModel.responses);
          bool valid = await HttpHelper.submitForm(
              dataModel.responses, dataModel.firstUpdate);
          if (valid) dataModel.firstUpdate = false;
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
