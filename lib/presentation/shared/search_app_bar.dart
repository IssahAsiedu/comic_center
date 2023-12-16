import 'package:comics_center/shared/utils.dart';
import 'package:flutter/material.dart';

var border = OutlineInputBorder(
  borderSide: const BorderSide(color: Colors.transparent, width: 0),
  borderRadius: BorderRadius.circular(30),
);

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String text)? onTextChange;
  final Function()? onSubmit;
  final TextEditingController textController;
  final String title;
  final String hintText;
  final double? searchBoxWidth;

  const SearchAppBar(
      {Key? key,
      this.onTextChange,
      required this.textController,
      this.title = 'Enjoy Marvel\'s Collection',
      this.hintText = 'Enter search key',
      this.searchBoxWidth,
      this.onSubmit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        Align(alignment: Alignment.topLeft, child: Text(title)),
        const SizedBox(
          height: 20,
        ),
        TextField(
          controller: textController,
          onChanged: onTextChange,
          onEditingComplete: onSubmit,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintStyle: const TextStyle(color: Colors.white24),
            hintText: hintText,
            fillColor: const Color(0x0ff00fff),
            filled: true,
            suffixIcon: OutlinedButton(
              onPressed: onSubmit,
              style: kOutlinedButtonCircleBackgroundStyle,
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
            contentPadding: EdgeInsets.zero,
            focusedBorder: border,
            enabledBorder: border,
            constraints: BoxConstraints(
              maxWidth:
                  searchBoxWidth ?? MediaQuery.of(context).size.width * 0.9,
            ),
          ),
        )
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(140);
}
