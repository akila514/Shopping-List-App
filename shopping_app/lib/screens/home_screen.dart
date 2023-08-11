import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:shopping_app/constants/colors.dart';
import 'package:shopping_app/data/categorey_data.dart';
import 'package:shopping_app/models/item.dart';
import 'package:shopping_app/provider/item_data_provider.dart';
import 'package:shopping_app/screens/new_item.dart';
import 'package:shopping_app/widgets/single_item_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends ConsumerState<HomeScreen> {
  List<Item> savedList = [];
  var isLoading = true;

  void _loadDataFromDataBase() async {
    final url = Uri.https(
        'flutter-prep-5b7c4-default-rtdb.firebaseio.com', 'shopping-list.json');

    final response = await http.read(url);
    final Map<String, dynamic> savedItemList = json.decode(response);
    List<Item> loadedItems = [];

    for (final item in savedItemList.entries) {
      final category = categoriesList.entries
          .firstWhere(
              (itemData) => itemData.value.title == item.value['itemCategorey'])
          .value;
      loadedItems.add(
        Item(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            itemCategorey: category),
      );
    }

    setState(() {
      savedList = loadedItems;
      isLoading = false;
    });
  }

  void navigatToNewItem() async {
    final newItem = await Navigator.push<Item>(
      context,
      MaterialPageRoute(
        builder: (context) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    } else {
      setState(() {
        savedList.add(newItem);
      });
    }
  }

  @override
  void initState() {
    _loadDataFromDataBase();
    super.initState();
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
    var content = Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Shopping App',
          style: TextStyle(color: primaryTextColor),
        ),
        backgroundColor: appBarColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: savedList.length,
                itemBuilder: (context, index) => Dismissible(
                      onDismissed: (direction) {
                        _deleteItemFromList(savedList[index]);
                      },
                      key: ValueKey(savedList[index]),
                      child: SingleItemCard(item: savedList[index]),
                    )),
          ),
          Container(
            width: double.infinity,
            height: 70,
            decoration: const BoxDecoration(color: appBarColor),
            child: TextButton(
              onPressed: () {
                navigatToNewItem();
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

    if (savedList.isEmpty) {
      content = Scaffold(
        appBar: AppBar(
          title: const Text(
            'Shopping App',
            style: TextStyle(color: primaryTextColor),
          ),
          backgroundColor: appBarColor,
        ),
        body: Column(
          children: [
            const Center(
              child: Text(
                'Add a item to view...',
                style: TextStyle(color: primaryTextColor),
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              height: 70,
              decoration: const BoxDecoration(color: appBarColor),
              child: TextButton(
                onPressed: () {
                  navigatToNewItem();
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

    if (isLoading) {
      content = Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text(
            'Shopping App',
            style: TextStyle(color: primaryTextColor),
          ),
          backgroundColor: appBarColor,
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: primaryTextColor,
          ),
        ),
      );
    }

    return content;
  }
}
