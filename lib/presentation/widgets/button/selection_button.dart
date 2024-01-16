import 'package:flutter/material.dart';

class SelectionButton extends StatelessWidget {
  const SelectionButton({
    super.key,
    required this.text,
    this.iconData,
    this.selected = false,
    this.onTap,
  });

  final String text;
  final IconData? iconData;
  final bool selected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          constraints: const BoxConstraints(minHeight: 40, minWidth: 50),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: selected ? Colors.blue.shade700 : Colors.transparent,
            border: Border.all(
              color: selected ? Colors.transparent : Colors.white,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconData != null) Icon(iconData),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )),
    );
  }
}
