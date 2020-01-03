import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_model.dart';
import '../http_helper.dart';
import 'form_item.dart';

class FormList extends StatelessWidget {
  const FormList({
    @required this.fields,
  });

  final List fields;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          Provider.of<DataModel>(context, listen: false).updateForm();
        },
        child: ListView.builder(
          itemBuilder: (context, index) {
            dynamic field = fields[index];

            return FormItem(
              title: field['title'],
              extra: field['extra'] != null
                  ? List<String>.from(field['extra'])
                  : null,
              category: field['category'],
            );
          },
          itemCount: fields.length,
        ),
      ),
    );
  }
}
