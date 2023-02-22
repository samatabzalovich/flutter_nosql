import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/common/constants/colors.dart';
import 'package:store/features/home/repository/home_repository.dart';

class SearchProductCart extends ConsumerWidget {
  final String? category, image, title;
  final double price;
  final GestureTapCallback onTap;

  const SearchProductCart(
      {Key? key,
      this.category,
      required this.image,
      required this.onTap,
      required this.title,
      required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String categoryName = (ref
        .read(homeRepoProvider)
        .fetchedCategories!
        .firstWhere((element) => element.id == category)).title;

    return Padding(
        padding: EdgeInsets.only(
            left: SizeConfig.getProportionateScreenWidth(20),
            right: SizeConfig.getProportionateScreenWidth(20),
            top: SizeConfig.getProportionateScreenWidth(10),
            bottom: SizeConfig.getProportionateScreenWidth(10)),
        child: productCard(categoryName));
  }

  Widget productCard(String categoryName) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: SizeConfig.getProportionateScreenWidth(400),
        height: SizeConfig.getProportionateScreenWidth(200),
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                child: Container(
                    width: SizeConfig.getProportionateScreenWidth(400),
                    height: SizeConfig.getProportionateScreenWidth(200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [primaryShadow],
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: SizeConfig.getProportionateScreenHeight(150),
                          width: SizeConfig.getProportionateScreenHeight(150),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontFamily: "Raleway",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            if (category != null)
                              Text(
                                categoryName!,
                                style: const TextStyle(
                                  color: Color(0xff858585),
                                  fontSize: 16,
                                  fontFamily: "Raleway",
                                ),
                              ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "\$$price",
                              style: const TextStyle(
                                color: Color(0xff5956e9),
                                fontSize: 17,
                                fontFamily: "Raleway",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
            Positioned.fill(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: SizeConfig.getProportionateScreenWidth(20)),
                    width: SizeConfig.getProportionateScreenWidth(180),
                    height: SizeConfig.getProportionateScreenHeight(180),
                    decoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        boxShadow: [primaryShadow]),
                    child: image!.substring(0, 5) == 'https'
                        ? Image.network(
                            image!,
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            image!,
                            fit: BoxFit.contain,
                          ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}