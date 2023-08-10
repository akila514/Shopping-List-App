import 'package:flutter/material.dart';
import 'package:shopping_app/constants/colors.dart';

import '../models/item.dart';

class SingleItemCard extends StatelessWidget {
  const SingleItemCard({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.square,
            color: item.itemCategorey.color,
          ),
          const SizedBox(
            width: 40,
          ),
          Text(
            item.name,
            style: const TextStyle(color: primaryTextColor, fontSize: 16),
          ),
          const Spacer(),
          Text(
            item.quantity.toString(),
            style: const TextStyle(color: primaryTextColor, fontSize: 16),
          )
        ],
      ),
    );
  }
}
