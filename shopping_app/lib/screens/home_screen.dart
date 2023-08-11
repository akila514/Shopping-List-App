import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/constants/colors.dart';
import 'package:shopping_app/data/categorey_data.dart';
import 'package:shopping_app/models/item.dart';
import 'package:shopping_app/provider/item_data_provider.dart';
import 'package:shopping_app/widgets/single_item_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends ConsumerState<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantuty = 1;
  var _selectedCategory = categoriesList[Categories.vegetable]!;

  void _openAddNewItemOverlay() {
    showModalBottomSheet(
      backgroundColor: backgroundColor,
      isScrollControlled: true,
      context: context,
      useSafeArea: true,
      builder: (context) => Padding(
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
                    onPressed: () {
                      _saveItem();
                    },
                    child: const Text(
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
                    onPressed: () {
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

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Navigator.pop(context);
      ref.read(itemDataProvider.notifier).addToItemList(
            Item(
                id: Random(1000).toString(),
                name: _enteredName,
                quantity: _enteredQuantuty,
                itemCategorey: _selectedCategory),
          );
    }
  }

  void _deleteItemFromList(Item item) {
    final itemListNotifier = ref.watch(itemDataProvider.notifier);
    final previousItemList = ref.watch(itemDataProvider);

    ref.watch(itemDataProvider.notifier).deleteFromItemList(item);

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$item deleted from the list.'),
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            itemListNotifier.insertToItemList(previousItemList);
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    List itemList = ref.watch(itemDataProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Shopping App',
          style: TextStyle(color: primaryTextColor),
        ),
        backgroundColor: appBarColor,
      ),
      body: itemList.isEmpty
          ? const Center(
              child: Text(
                'Add a item to view...',
                style: TextStyle(color: primaryTextColor),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: itemList.length,
                      itemBuilder: (context, index) => Dismissible(
                            onDismissed: (direction) {
                              _deleteItemFromList(itemList[index]);
                            },
                            key: ValueKey(itemList[index]),
                            child: SingleItemCard(item: itemList[index]),
                          )),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: const BoxDecoration(color: appBarColor),
                  child: TextButton(
                    onPressed: () {
                      _openAddNewItemOverlay();
                    },
                    child: const Text(
                      'Add a new Item',
                      style: TextStyle(color: primaryTextColor, fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
