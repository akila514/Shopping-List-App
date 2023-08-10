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

void _openAddNewItemOverlay(BuildContext context, WidgetRef ref) {
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final quantityController = TextEditingController();

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: const InputDecoration(label: Text('Item ID')),
            controller: idController,
          ),
          TextField(
            decoration: const InputDecoration(label: Text('Item Name')),
            controller: nameController,
          ),
          TextField(
            decoration: const InputDecoration(label: Text('Quantity')),
            controller: quantityController,
          ),
          const SizedBox(
            height: 30,
          ),
          DropdownMenu(
              label: const Text(
                'Select Category',
                style: TextStyle(fontSize: 12),
              ),
              dropdownMenuEntries: [
                DropdownMenuEntry(
                    value: Categories.vegetable,
                    label: Categories.vegetable.name),
                DropdownMenuEntry(
                    value: Categories.carbs, label: Categories.carbs.name),
                DropdownMenuEntry(
                    value: Categories.convenience,
                    label: Categories.convenience.name),
                DropdownMenuEntry(
                    value: Categories.dairy, label: Categories.dairy.name),
                DropdownMenuEntry(
                    value: Categories.meat, label: Categories.meat.name),
                DropdownMenuEntry(
                    value: Categories.fruit, label: Categories.fruit.name),
                DropdownMenuEntry(
                    value: Categories.hygiene, label: Categories.hygiene.name),
                DropdownMenuEntry(
                    value: Categories.spices, label: Categories.spices.name),
                DropdownMenuEntry(
                    value: Categories.sweets, label: Categories.sweets.name),
                DropdownMenuEntry(
                    value: Categories.convenience,
                    label: Categories.convenience.name),
                DropdownMenuEntry(
                    value: Categories.other, label: Categories.other.name),
              ]),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  _validateUserInput(idController.text, nameController.text,
                      quantityController.text, ref, context);
                },
                child: const Text('Add'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              )
            ],
          )
        ],
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

void _deleteItemFromList(Item item, WidgetRef ref, BuildContext context) {
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

class _HomeScreen extends ConsumerState<HomeScreen> {
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
                        _deleteItemFromList(itemList[index], ref, context);
                      },
                      key: ValueKey(itemList[index]),
                      child: SingleItemCard(item: itemList[index]),
                    )),
          ),
          Container(
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(color: appBarColor),
            child: TextButton(
              onPressed: () {
                _openAddNewItemOverlay(context, ref);
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
