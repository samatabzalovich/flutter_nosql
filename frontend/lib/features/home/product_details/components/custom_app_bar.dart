import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/features/bloc/current_user/current_user.dart';
import 'package:store/features/edit_product/screens/edit_product_screen.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/features/bloc/current_user/current_user.dart';
import 'package:store/features/home/repository/home_repository.dart';
import 'package:store/models/product.dart';
import 'package:store/models/user.dart';
import 'custom_back_button.dart';

class CustomAppBar extends ConsumerStatefulWidget {
  final String productId;
  final Product product;
  bool? isProductFavourite;
  CustomAppBar(
      {Key? key,
      this.isProductFavourite,
      required this.productId,
      required this.product})
      : super(key: key);

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    List? found = ref.read(currentUserProvider).currentUser!.favourites;
    UserModel currentUser = ref.read(currentUserProvider).currentUser!;
    widget.isProductFavourite = false;
    if (found != null && found.isNotEmpty) {
      for (var element in found) {
        if (element == widget.productId) {
          widget.isProductFavourite = true;
        }
      }
    }
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.getProportionateScreenWidth(15),
          ),
          Row(
            children: [
              const CustomBackButton(),
              const Spacer(),
              favoriteContainer(currentUser, context, widget.product),
            ],
          ),
        ],
      ),
    );
  }

  Widget favoriteContainer(
      UserModel currentUser, BuildContext context, Product product) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(15)),
      width: currentUser.type == 'seller'
          ? SizeConfig.getProportionateScreenWidth(140)
          : SizeConfig.getProportionateScreenWidth(64),
      decoration: BoxDecoration(
          color: widget.isProductFavourite == true &&
                  widget.isProductFavourite != null
              ? const Color(0xFFFFE6E6)
              : Colors.black12,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (currentUser.type == 'seller')
            InkWell(
              onTap: () {
                setState(() async {
                  await ref.read(homeRepoProvider).deleteProduct(
                      id: product.id,
                      context: context,
                      ownerId: product.owner,
                      userId: currentUser.id);
                });
              },
              child: Icon(
                Icons.delete_outline_outlined,
                color: Colors.black,
              ),
            ),
          if (currentUser.type == 'seller')
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, EditProduct.editProduct,
                    arguments: product);
                setState(() {
                  // widget.isProductFavourite = demoProducts
                  //     .where((product) => (product.id == widget.productId))
                  //     .first.isFavourite;
                });
              },
              child: Icon(
                Icons.mode_edit_outline_outlined,
                color: Colors.black,
              ),
            ),
          InkWell(
            onTap: () async {
              bool ok = await ref
                  .read(homeRepoProvider)
                  .addToFavourites(widget.productId, context);
              setState(() {});
            },
            child: Icon(
              widget.isProductFavourite == true &&
                      widget.isProductFavourite != null
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: widget.isProductFavourite == true &&
                      widget.isProductFavourite != null
                  ? const Color(0xFFFF4848)
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
