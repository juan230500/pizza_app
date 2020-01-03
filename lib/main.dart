import 'package:flutter/material.dart';
import 'package:pizza_app/screens/form_screen.dart';
import 'package:provider/provider.dart';

import 'data_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: MaterialApp(
        home: FormScreen(),
      ),
      create: (BuildContext context) {
        return DataModel();
      },
    );
  }
}
