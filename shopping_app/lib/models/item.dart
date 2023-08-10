import 'package:shopping_app/models/item_categorey.dart';

class Item {
  final String id;
  final String name;
  final int quantity;
  final ItemCategory itemCategorey;

  const Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.itemCategorey,
  });
}
