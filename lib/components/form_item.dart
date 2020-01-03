import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_model.dart';
import '../constants.dart';

///item of the form, the input widget depends of the category
class FormItem extends StatefulWidget {
  final String title;
  final String category;
  final List<String> extra;

  const FormItem({this.title, this.category, this.extra});

  @override
  _FormItemState createState() => _FormItemState();
}

class _FormItemState extends State<FormItem> {
  Map<String, dynamic> responses;

  ///Uses the category attribute to generated a specific widget
  ///and links its value to the a element in the provider global responses
  Widget getInputWidget() {
    Widget inputWidget;
    if (widget.category == 'string') {
      if (responses[widget.title] == null) {
        responses[widget.title] = "";
      }
      var textController = TextEditingController();
      textController.text = responses[widget.title];
      inputWidget = TextField(
        controller: textController,
        onChanged: (value) {
          responses[widget.title] = value;
        },
      );
    } else if (widget.category == 'float') {
      if (responses[widget.title] == null) {
        responses[widget.title] = 0;
      }
      var textController = TextEditingController();
      textController.text = responses[widget.title].toString();
      inputWidget = TextField(
        controller: textController,
        onChanged: (value) {
          responses[widget.title] = value;
        },
        keyboardType: TextInputType.number,
      );
    } else if (widget.category == 'list') {
      if (responses[widget.title] == null) {
        responses[widget.title] = widget.extra[0];
      }
      inputWidget = DropdownButton<String>(
        items: widget.extra.map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        value: responses[widget.title],
        onChanged: (value) {
          setState(() {
            responses[widget.title] = value;
          });
        },
      );
    } else if (widget.category == 'bool') {
      if (responses[widget.title] == null) {
        responses[widget.title] = false;
      }
      inputWidget = Checkbox(
        value: responses[widget.title],
        onChanged: (value) {
          setState(() {
            responses[widget.title] = value;
          });
        },
      );
    } else {
      inputWidget = Text('not found');
    }
    return inputWidget;
  }

  ///Takes a snake_case string and converts it in a capitalized sentence
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
    responses = Provider.of<DataModel>(context).responses;

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
              child: Center(child: getInputWidget()),
            ),
          )
        ],
      ),
    );
  }
}
