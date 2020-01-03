import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_model.dart';
import '../constants.dart';

class FormItem extends StatefulWidget {
  final String title;
  final String category;
  final List<String> extra;

  const FormItem({this.title, this.category, this.extra});

  @override
  _FormItemState createState() => _FormItemState();
}

class _FormItemState extends State<FormItem> {
  Widget getInputWidget(data) {
    Widget inputWidget;
    if (widget.category == 'string') {
      if (data[widget.title] == null) {
        data[widget.title] = "";
      }
      var textController = TextEditingController();
      textController.text = data[widget.title];
      inputWidget = TextField(
        controller: textController,
        onChanged: (value) {
          data[widget.title] = value;
        },
      );
    } else if (widget.category == 'float') {
      if (data[widget.title] == null) {
        data[widget.title] = 0;
      }
      var textController = TextEditingController();
      textController.text = data[widget.title].toString();
      inputWidget = TextField(
        controller: textController,
        onChanged: (value) {
          data[widget.title] = value;
        },
        keyboardType: TextInputType.number,
      );
    } else if (widget.category == 'list') {
      if (data[widget.title] == null) {
        data[widget.title] = widget.extra[0];
      }
      inputWidget = DropdownButton<String>(
        items: widget.extra.map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        value: data[widget.title],
        onChanged: (value) {
          setState(() {
            data[widget.title] = value;
          });
        },
      );
    } else if (widget.category == 'bool') {
      if (data[widget.title] == null) {
        data[widget.title] = false;
      }
      inputWidget = Checkbox(
        value: data[widget.title],
        onChanged: (value) {
          setState(() {
            data[widget.title] = value;
          });
        },
      );
    } else {
      inputWidget = Text('not found');
    }
    return inputWidget;
  }

  String formatTitle(String inputString) {
    String outputString = "";
    for (int i = 0; i < inputString.length; i++) {
      if (i == 0) {
        outputString += inputString[i].toUpperCase();
      } else if (inputString[i] == "_") {
        outputString += " ";
      } else {
        outputString += inputString[i];
      }
    }
    outputString += ":";
    return outputString;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = Provider.of<DataModel>(context).responses;

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              formatTitle(widget.title),
              style: kcommonTextStyle,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(child: getInputWidget(data)),
            ),
          )
        ],
      ),
    );
  }
}
