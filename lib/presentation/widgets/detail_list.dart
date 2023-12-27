import 'package:comics_center/domain/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailList<T extends Item> extends StatelessWidget {
  final String title;
  final List<T> items;
  final void Function(T t)? onTap;

  const DetailList({
    Key? key,
    required this.items,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.ant_circle,
            color: Colors.redAccent,
            size: 70,
          ),
          Text("No $title available")
        ],
      );
    }

    const headerStyle = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontFamily: 'Bangers',
      decoration: TextDecoration.underline,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //header
        Text(
          title,
          style: headerStyle,
        ),

        //content
        for (var i = 0; i < items.length; i++)
          InkWell(
            onTap: () {
              onTap?.call(items[i]);
            },
            child: Container(
              constraints: const BoxConstraints(minHeight: 50),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    '${i + 1}.',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(items[i].name))
                ],
              ),
            ),
          )
      ],
    );
  }
}
