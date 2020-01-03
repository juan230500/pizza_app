import 'package:flutter/material.dart';
import 'package:pizza_app/components/bikes_row.dart';
import 'package:pizza_app/components/stores_drawer.dart';
import 'package:provider/provider.dart';
import '../components/form_list.dart';
import '../data_model.dart';
import '../http_helper.dart';
import 'bike_screen.dart';

///main screen, stores the bikes, fields and stores data to pass it to other widget
class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  List<dynamic> fields = [];
  List<dynamic> stores = [];
  List<dynamic> bikes = [];
  bool loadingStores = true;
  bool waitingBike = true;
  bool loadingBike = true;
  String currentStore = 'Seleccione una tienda';
  DataModel dataModel;

  ///requests and saves the fields of a generic register
  Future<void> loadFields() async {
    fields = await HttpHelper.getFormFields();
  }

  ///requests and saves the stores
  Future<void> loadStores() async {
    loadingStores = true;
    stores = await HttpHelper.getStores();
    loadingStores = false;
    setState(() {});
  }

  ///uses the flags to hide the form until bike is selected and loaded
  Widget formListValidated() {
    if (waitingBike)
      return Center(child: Text('Seleccione una moto'));
    else if (loadingBike)
      return Center(child: Text('Cargando datos'));
    else
      return FormList(fields: fields);
  }

  ///creates the bike screen if the bike is selected and loaded
  void initBikeScreen() {
    if (waitingBike || loadingBike) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BikeScreen(
          data: dataModel.currentBikeData,
        ),
      ),
    );
  }

  ///requests the initial form data for a bike and updates flags to show a message
  Future<void> selectBike() async {
    setState(() {
      waitingBike = false;
      loadingBike = true;
    });
    await dataModel.updateForm();
    loadingBike = false;
    setState(() {});
  }

  ///requests the bikes list of a selected store and updates appBar title
  Future<void> selectStore(var store) async {
    bikes = await HttpHelper.getBikes(store['codrest']);
    setState(() {
      currentStore = store['nombre'];
      waitingBike = true;
    });
  }

  Future<void> saveForm() async {
    dataModel.responses['moto'] = dataModel.currentBikeData['placa'];
    dataModel.responses['tienda'] = dataModel.currentStoreData['codrest'];
    print(dataModel.responses);
    await HttpHelper.submitForm(dataModel.responses);
  }

  ///loads the fields and the stores at the start
  @override
  void initState() {
    dataModel = Provider.of<DataModel>(context, listen: false);
    loadFields();
    loadStores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.motorcycle),
            onPressed: initBikeScreen,
          ),
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
          : StoresDrawer(
              stores: stores,
              callbackFunction: selectStore,
            ),
      body: Column(
        children: <Widget>[
          BikesRow(
            callbackFunction: selectBike,
            bikes: bikes,
          ),
          formListValidated(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveForm();
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
