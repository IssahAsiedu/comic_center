import 'package:comics_center/domain/comic/comic_price.dart';
import 'package:comics_center/shared/app_assets.dart';
import 'package:flutter/material.dart';

class PricesSection extends StatelessWidget {
  final List<ComicPrice> prices;

  const PricesSection({Key? key, this.prices = const <ComicPrice>[]})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 138,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (_, i) {
            var price = prices[i];

            var imgSrc = AppAssets.digitalImage;

            if (price.type.toLowerCase().contains("print")) {
              imgSrc = AppAssets.paperImage;
            }

            return Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black87,
                border: Border.all(color: Colors.white54),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    child: Image.asset(
                      imgSrc,
                      width: 30,
                      height: 30,
                    ),
                  ),
                  const SizedBox(width: 3),
                  SizedBox(
                    width: 100,
                    child: Text(
                      price.displayString,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    "\$ ${price.price}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            );
          },
          separatorBuilder: (_, i) {
            return const SizedBox(width: 20);
          },
          itemCount: prices.length),
    );
  }
}
