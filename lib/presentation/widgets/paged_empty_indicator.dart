import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PagedEmptyIndicator extends StatelessWidget {
  const PagedEmptyIndicator({
    super.key,
    this.onRetry,
  });

  final Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // icons
        const Icon(
          CupertinoIcons.ant,
          size: 100,
          color: Colors.white,
        ),

        // spacer
        const SizedBox(height: 20),

        //empty text
        const Text('The list is Empty'),

        // button
        GestureDetector(
          onTap: onRetry,
          child: const Text(
            'REFRESH',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        )
      ],
    );
  }
}
