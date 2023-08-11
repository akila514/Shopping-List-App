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
  void onChangeForm() {}

  void _openAddNewItemOverlay() {
    showModalBottomSheet(
      backgroundColor: backgroundColor,
      isScrollControlled: true,
      context: context,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    label: Text(
                  'Item ID',
                  style: TextStyle(color: primaryTextColor),
                )),
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    label: Text(
                  'Item Name',
                  style: TextStyle(color: primaryTextColor),
                )),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: primaryTextColor),
                        labelText: 'Quantity',
                      ),
                      initialValue: '1',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
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
                        onChanged: (value) {}),
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
                      // _validateUserInput(idController.text, nameController.text,
                      //     quantityController.text, ref, context);
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
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
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

  void _validateUserInput(
      String id, String name, String qty, WidgetRef ref, BuildContext context) {
    if (id.isEmpty || name.isEmpty || qty.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter valid information'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'))
          ],
        ),
      );
      return;
    }
    Navigator.pop(context);
    ref.read(itemDataProvider.notifier).addToItemList(Item(
        id: id,
        name: name,
        quantity: int.parse(qty),
        itemCategorey: categoriesList[Categories.carbs]!));
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
      body: Column(
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
