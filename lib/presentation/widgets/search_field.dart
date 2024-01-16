import 'package:flutter/material.dart';

var border = OutlineInputBorder(
  borderSide: const BorderSide(color: Colors.transparent, width: 0),
  borderRadius: BorderRadius.circular(4),
);

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.textController,
    this.onTextChange,
    this.onSubmit,
    this.searchBoxWidth,
    this.hintText,
    this.focusNode,
  });

  final TextEditingController? textController;
  final void Function(String)? onTextChange;
  final void Function()? onSubmit;
  final double? searchBoxWidth;
  final String? hintText;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      focusNode: focusNode,
      controller: textController,
      onChanged: onTextChange,
      onEditingComplete: onSubmit,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          size: 30,
        ),
        hintStyle: const TextStyle(color: Colors.grey),
        hintText: hintText,
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.zero,
        focusedBorder: border,
        enabledBorder: border,
        constraints: BoxConstraints(
          maxWidth: searchBoxWidth ?? MediaQuery.of(context).size.width * 0.9,
        ),
      ),
    );
  }
}
