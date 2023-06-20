import 'package:flutter/material.dart';

import '../models/Comic_price.dart';


class PricesSection extends StatelessWidget {
  final List<ComicPrice> prices;

  const PricesSection({Key? key, this.prices = const <ComicPrice>[]})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white24,
      height: 50,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (_, i) {
            var price = prices[i];

            IconData icon = Icons.computer;

            if (price.type.toLowerCase().contains("print")) {
              icon = Icons.print;
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text("${price.displayString}: "),
                Text("\$ ${price.price}")
              ],
            );
          },
          separatorBuilder: (_, i) {
            return const SizedBox(
              width: 20,
            );
          },
          itemCount: prices.length),
    );
  }
}
