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
          Card(
            color: Colors.black12,
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //card title
                  Text(
                    items[i].name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),

                  // spacer
                  const SizedBox(height: 10),

                  //card content
                  Text('Comic id: ${items[i].id}'),

                  // spacer
                  const SizedBox(height: 25),

                  //button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        onTap?.call(items[i]);
                      },
                      child: const Text('View More'),
                    ),
                  )
                ],
              ),
            ),
          )
      ],
    );
  }
}
