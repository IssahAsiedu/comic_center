import 'package:comics_center/shared/app_assets.dart';
import 'package:flutter/material.dart';

import '../models/Comic_price.dart';


class PricesSection extends StatelessWidget {
  final List<ComicPrice> prices;

  const PricesSection({Key? key, this.prices = const <ComicPrice>[]})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 50,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (_, i) {
            var price = prices[i];

            IconData icon = Icons.computer;

            var imgSrc = AppAssets.digitalImage;

            if (price.type.toLowerCase().contains("print")) {
              icon = Icons.print;
              imgSrc = AppAssets.paperImage;
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(imgSrc, width: 80, height: 80,),
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
