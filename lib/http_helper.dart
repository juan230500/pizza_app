import 'dart:convert';
import 'package:http/http.dart' as http;

final token = 'ba864153abe79aea3fa9b6509b25fd1354b50c2f';
final url = 'http://192.168.100.12:8000/api';

///set of useful function to communicate with the RESTApi
class HttpHelper {
  ///gets the list of fields used the build the form
  static Future<List<dynamic>> getFormFields() async {
    var response = await http.get(
      '$url/form/',
      headers: {'Authorization': 'Token $token'},
    );

    List<dynamic> fields = [];
    if (response.statusCode == 200)
      fields = jsonDecode(response.body)['fields'];
    return fields;
  }

  ///gets the last register of a bike in order to pre-fill the fields
  static Future<Map<String, dynamic>> getFormLastUpdate(String placa) async {
    var response = await http.get(
      '$url/last_update/$placa',
      headers: {'Authorization': 'Token $token'},
    );
    Map<String, dynamic> data;
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    }
    return data;
  }

  ///post a new register item using the data in the form
  static Future<void> submitForm(Map<String, dynamic> data) async {
    var response = await http.post(
      '$url/registro/',
      headers: {
        'Authorization': 'Token $token',
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }

  ///gets the list of stores used to select the current store
  static Future<List<dynamic>> getStores() async {
    var response = await http.get(
      '$url/tienda/',
      headers: {'Authorization': 'Token $token'},
    );

    List<dynamic> stores = [];
    if (response.statusCode == 200) stores = jsonDecode(response.body);
    return stores;
  }

  ///get the list of bikes used to select the current bike
  static Future<List<dynamic>> getBikes(String store) async {
    var response = await http.get(
      '$url/bikes/$store',
      headers: {'Authorization': 'Token $token'},
    );

    List<dynamic> bikes = [];
    if (response.statusCode == 200) bikes = jsonDecode(response.body);
    return bikes;
  }
}
