import 'package:comics_center/domain/item.dart';
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
            Icons.how_to_vote,
            color: Colors.white,
            size: 150,
          ),
          Text("No $title available")
        ],
      );
    }

    return DataTable(
      dividerThickness: 1,
      showBottomBorder: true,
      columns: [
        DataColumn(
            label: Expanded(
                child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Bangers',
            decoration: TextDecoration.underline,
          ),
        )))
      ],
      rows: items
          .map((e) => DataRow(cells: [
                DataCell(
                  Text(e.name),
                  onTap: () {
                    onTap?.call(e);
                  },
                )
              ]))
          .toList(),
    );
  }
}
