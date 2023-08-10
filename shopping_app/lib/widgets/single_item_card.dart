import 'package:flutter/material.dart';

import 'package:shopping_app/constants/colors.dart';
import '../models/item.dart';

class SingleItemCard extends StatelessWidget {
  const SingleItemCard({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: const BoxDecoration(
            color: cardColor,
            boxShadow: [
              BoxShadow(
                  color: backgroundColor,
                  offset: Offset(1, 1),
                  blurRadius: 2.0,
                  spreadRadius: 3.0),
            ],
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
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
      ),
    );
  }
}
