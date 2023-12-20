import 'package:comics_center/shared/utils.dart';
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
    return Stack(
      children: [
        TextField(
          focusNode: focusNode,
          controller: textController,
          onChanged: onTextChange,
          onEditingComplete: onSubmit,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.black),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintStyle: const TextStyle(color: Colors.white24),
            hintText: hintText,
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.zero,
            focusedBorder: border,
            enabledBorder: border,
            constraints: BoxConstraints(
              maxWidth:
                  searchBoxWidth ?? MediaQuery.of(context).size.width * 0.9,
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: OutlinedButton(
            onPressed: onSubmit,
            style: kOutlinedButtonCircleBackgroundStyle,
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
