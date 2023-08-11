import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shopping_app/data/categorey_data.dart';
import 'package:shopping_app/models/item.dart';

class ItemDataNotifier extends StateNotifier<List<Item>> {
  ItemDataNotifier()
      : super([
          Item(
              id: 'u1',
              name: 'Milk',
              quantity: 2,
              itemCategorey: categoriesList[Categories.dairy]!),
          Item(
              id: 'u1',
              name: 'Banana',
              quantity: 10,
              itemCategorey: categoriesList[Categories.fruit]!),
          Item(
              id: 'u1',
              name: 'Beef Steak',
              quantity: 5,
              itemCategorey: categoriesList[Categories.meat]!),
        ]);

  void addToItemList(Item item) {
    state = [...state, item];
  }

  void replaceItemList(List<Item> itemList) {
    state = itemList;
  }

  void insertToItemList(List<Item> previousItemList) {
    state = previousItemList;
  }

  void deleteFromItemList(Item item) {
    state = state.where((i) => i.id != item.id).toList();
  }
}

final itemDataProvider = StateNotifierProvider<ItemDataNotifier, List<Item>>(
    (ref) => ItemDataNotifier());
