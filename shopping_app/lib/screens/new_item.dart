import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/colors.dart';
import '../data/categorey_data.dart';
import '../models/item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantuty = 1;
  var _selectedCategory = categoriesList[Categories.vegetable]!;
  var isSaving = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        isSaving = true;
      });

      final url = Uri.https('flutter-prep-5b7c4-default-rtdb.firebaseio.com',
          'shopping-list.json');

      final result = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': _enteredName,
            'quantity': _enteredQuantuty,
            'itemCategorey': _selectedCategory.title,
          },
        ),
      );

      final Map<String, dynamic> resultData = json.decode(result.body);

      final item = Item(
          id: resultData['name'],
          name: _enteredName,
          quantity: _enteredQuantuty,
          itemCategorey: _selectedCategory);

      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        foregroundColor: primaryTextColor,
        backgroundColor: backgroundColor,
        title: const Text(
          'Add a Item',
          style: TextStyle(color: primaryTextColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                onSaved: (value) {
                  _enteredName = value!;
                },
                maxLength: 50,
                style: const TextStyle(
                  color: primaryTextColor,
                ),
                decoration: const InputDecoration(
                    counterStyle: TextStyle(color: primaryTextColor),
                    label: Text(
                      'Item Name',
                      style: TextStyle(color: primaryTextColor),
                    )),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length >= 50) {
                    return 'Item name must have between 1 to 50 characters ';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      onSaved: (value) {
                        _enteredQuantuty = int.parse(value!);
                      },
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: primaryTextColor),
                        labelText: 'Quantity',
                      ),
                      initialValue: _enteredQuantuty.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value.trim()) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Enter a valid positive number ';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                            label: Text(
                          'Select Category',
                          style: TextStyle(color: primaryTextColor),
                        )),
                        dropdownColor: appBarColor,
                        style: const TextStyle(color: primaryTextColor),
                        items: [
                          for (final category in categoriesList.entries)
                            DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      color: category.value.color,
                                      width: 16,
                                      height: 16,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(category.value.title)
                                  ],
                                ))
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        }),
                  )
                ],
              ),
              const SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(appBarColor)),
                    onPressed: isSaving
                        ? null
                        : () {
                            _saveItem();
                          },
                    child: isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text(
                            'Add',
                            style: TextStyle(color: primaryTextColor),
                          ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xFFeb3b5a))),
                    onPressed: isSaving
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: const Text('Reset',
                        style: TextStyle(color: primaryTextColor)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
