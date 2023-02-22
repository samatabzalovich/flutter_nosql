import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/features/home/repository/home_repository.dart';
import 'package:store/models/product.dart';
import 'package:store/common/Utilities/size_config.dart';

import 'product_card.dart';

class PopularProducts extends ConsumerStatefulWidget {
  const PopularProducts({Key? key}) : super(key: key);

  @override
  ConsumerState<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends ConsumerState<PopularProducts> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getProportionateScreenWidth(20)),
          child: TextButton(
            child: const Text("Popular Products"),
            onPressed: () {},
          ),
        ),
        SizedBox(height: SizeConfig.getProportionateScreenWidth(20)),
        Padding(
          padding: const EdgeInsets.fromLTRB(35, 10, 10, 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // child: Row(
            //   children: [
            //     ...List.generate(
            //       demoProducts.length,
            //         (index) {
            //             if(demoProducts[index].isPopular){
            //               return ProductCard(product:demoProducts[index]);
            //             }
            //             return const SizedBox.shrink();
            //         }
            //     ),
            //     SizedBox(width: SizeConfig.getProportionateScreenWidth(40)),
            //   ],
            // ),
            child: FutureBuilder(
              future: ref
                  .read(homeRepoProvider)
                  .fetchPopularProducts(context: context),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  return Row(
                    children: [
                      ...List.generate(snapshot.data!.length, (index) {
                        return ProductCard(product: snapshot.data![index]);
                      }),
                    ],
                  );
                }
                return Center(
                  child: Text('Error'),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
