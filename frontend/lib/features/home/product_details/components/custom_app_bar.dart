import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/features/bloc/current_user/current_user.dart';
import 'package:store/features/home/repository/home_repository.dart';
import 'package:store/models/product.dart';
import 'custom_back_button.dart';

class CustomAppBar extends ConsumerStatefulWidget {
  final String productId;
  bool? isProductFavourite;
  CustomAppBar({
    Key? key,
    this.isProductFavourite,
    required this.productId,
  }) : super(key: key);

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    List? found = ref.read(currentUserProvider).currentUser!.favourites;
    if (found != null && found.isNotEmpty) {
      for (var element in found) {
        if (element == widget.productId) {
          widget.isProductFavourite = true;
        }
      }
    } else {
      widget.isProductFavourite = false;
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
              favoriteContainer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget favoriteContainer() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(15)),
      width: SizeConfig.getProportionateScreenWidth(64),
      decoration: BoxDecoration(
          color: widget.isProductFavourite == true &&
                  widget.isProductFavourite != null
              ? const Color(0xFFFFE6E6)
              : Colors.black12,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))),
      child: InkWell(
        onTap: ()async  {
          bool ok = await ref
                .read(homeRepoProvider)
                .addToFavourites(widget.productId, context);
            setState(()  {
            
          });
        },
        child: Icon(
          widget.isProductFavourite == true && widget.isProductFavourite != null
              ? Icons.favorite
              : Icons.favorite_border,
          color: widget.isProductFavourite == true &&
                  widget.isProductFavourite != null
              ? const Color(0xFFFF4848)
              : Colors.black,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
