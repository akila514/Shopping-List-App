import 'package:flutter/material.dart';

import 'package:shopping_app/models/item_categorey.dart';

const categoriesList = {
  Categories.vegetable: ItemCategory(title: 'Vegetable', color: Colors.green),
  Categories.fruit: ItemCategory(title: 'Fruit', color: Colors.yellow),
  Categories.meat: ItemCategory(title: 'Meat', color: Colors.redAccent),
  Categories.dairy: ItemCategory(title: 'Dairy', color: Colors.grey),
  Categories.carbs: ItemCategory(title: 'Carbs', color: Colors.amber),
  Categories.sweets: ItemCategory(title: 'Sweets', color: Colors.pink),
  Categories.spices: ItemCategory(title: 'Spices', color: Colors.red),
  Categories.convenience:
      ItemCategory(title: 'Convenience', color: Colors.blue),
  Categories.hygiene: ItemCategory(title: 'Hygiene', color: Colors.purple),
  Categories.other: ItemCategory(title: 'Other', color: Colors.brown),
};

enum Categories {
  vegetable,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}

List<String> categoriesStringList = [
  'vegetable',
  'fruit',
  'meat',
  'dairy',
  'carbs',
  'sweets',
  'spices',
  'convenience',
  'hygiene',
  'other'
];
