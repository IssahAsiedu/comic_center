import 'package:flutter/material.dart';

class PagedErrorIndicator extends StatelessWidget {
  const PagedErrorIndicator({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.running_with_errors,
          color: Colors.white,
        ),
        const SizedBox(height: 10),
        const Text('An error occurred'),
        const SizedBox(height: 18),
        InkWell(
          onTap: onTap,
          child: const Text(
            'RETRY',
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
