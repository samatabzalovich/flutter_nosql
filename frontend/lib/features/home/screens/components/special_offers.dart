import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/common/constants/text_style.dart';
// import 'package:store/features/bloc/search/search_bloc.dart';
// import 'package:store/features/bloc/search/search_state.dart';
import 'package:store/features/home/product_details/product_details_screen.dart';
import 'package:store/features/home/repository/home_repository.dart';
import 'package:store/models/product.dart';

import '../../../../models/category.dart';
import 'special_offer_card.dart';

class SpecialOffers extends ConsumerWidget {
  const SpecialOffers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Category? category = ref.watch(homeRepoProvider).selectedCategory;
    if (category == null) {
      List<Category>? categories =
          ref.read(homeRepoProvider).fetchedCategories;
      category = categories![0];
    }
    return SizedBox(
      height: 425,
      child: Column(
        // shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getProportionateScreenWidth(10),
              vertical: SizeConfig.getProportionateScreenWidth(10),
            ),
            child: TextButton(
              child: const Text(
                "Special For you!",
              ),
              onPressed: () {},
            ),
          ),
          FutureBuilder(
              future: ref.read(homeRepoProvider).fetchProductByCategory(
                  context: context, categoryId: category.id),
              // initialData: InitialData,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                  if (snapshot.data!.isEmpty) {
                    return SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          child: const Center(
                            child: Text("There are no elements"),
                          ),
                        );
                  }
                      else {
                        return Column(
                          children: [
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                    snapshot.data!.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: SpecialOfferCard(
                                          category: snapshot
                                              .data![index].category[0],
                                          image: snapshot.data![index].image,
                                          price: snapshot.data![index].price,
                                          title: snapshot.data![index].title,
                                          onTap: () => Navigator.pushNamed(
                                              context,
                                              ProductDetailsScreen.routeName,
                                              arguments:
                                                  snapshot.data![index])),
                                    ),
                                  ),
                                )),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              color: Colors.transparent,
                              child: GestureDetector(
                                onTap: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text("See more", style: textStyle),
                                    SizedBox(
                                      width: SizeConfig
                                          .getProportionateScreenHeight(5),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_outlined,
                                      color: Color(0xff5956e9),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                
                // else {
                //   return Expanded(
                //     child: Center(
                //   child: Text('something went wrong'),
                // ));
                // }
              })
        ],
      ),
    );
  }
}
