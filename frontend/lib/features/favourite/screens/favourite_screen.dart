import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/features/bloc/current_user/current_user.dart';
import 'package:store/features/home/repository/home_repository.dart';
// import 'package:store/features/bloc/favorite/favorite_event.dart';
import 'package:store/features/widgets/custom_app_bar.dart';
// import 'package:store/features/bloc/favorite/favorite_bloc.dart';
import 'package:store/features/favourite/screens/no_favorite_item.dart';
// import 'package:store/features/bloc/favorite/favorite_state.dart';
import 'package:store/features/home/product_details/product_details_screen.dart';
import 'package:store/features/home/screens/search/components/item_card.dart';
import 'package:store/models/product.dart';
import 'package:store/models/user.dart';

class FavouriteScreen extends ConsumerStatefulWidget {
  static const String routeName = "/favourite";
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends ConsumerState<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
  }
  Future<List<Product>> getFavourites() async {
    UserModel currentUser = ref.read(currentUserProvider).currentUser!;
    List<Product> temp = [];
    for (var i = 0; i < currentUser.favourites!.length; i++) {
      Product? tempProduct = await ref.read(homeRepoProvider).fetchProductById(context: context, productId: currentUser.favourites![i]);
      if (tempProduct != null) {
        temp.add(tempProduct);
      }
    }
    return temp;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: "Favorites",
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getFavourites(),
          builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Align(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const NoFavorite();
              } else {
                return Center(
                    child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 15,
                          children: List.generate(
                            snapshot.data!.length,
                            (index) {
                              return ItemCard(
                                  image: snapshot.data![index].image,
                                  price:
                                      "From ${snapshot.data![index].price}",
                                  title: snapshot.data![index].title,
                                  evenItem: (index % 2 == 0) ? true : false,
                                  onTap: () => Navigator.pushNamed(
                                      context, ProductDetailsScreen.routeName,
                                      arguments:
                                          snapshot.data![index]));
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ));
              }
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
