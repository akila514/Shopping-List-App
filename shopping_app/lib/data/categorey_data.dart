import 'package:flutter/material.dart';
import 'package:shopping_app/models/item_categorey.dart';

const categoriesList = {
  Categories.vegetable: ItemCategorey(title: 'Vegetable', color: Colors.green),
  Categories.fruit: ItemCategorey(title: 'Fruit', color: Colors.yellow),
  Categories.meat: ItemCategorey(title: 'Meat', color: Colors.redAccent),
  Categories.diary: ItemCategorey(title: 'Diary', color: Colors.grey),
  Categories.carbs: ItemCategorey(title: 'Carbs', color: Colors.amber),
};

enum Categories { vegetable, fruit, meat, diary, carbs }
