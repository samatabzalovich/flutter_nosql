import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store/common/constants/text_style.dart';
import 'package:store/features/home/repository/home_repository.dart';
import 'package:store/features/home/screens/components/popular_product.dart';
import 'package:store/features/home/screens/search/search_page.dart';
import 'package:store/features/widgets/custom_bottom_navbar.dart';

import '../../../common/constants/colors.dart';
import '../../../common/constants/enums.dart';
import '../../../common/constants/form_field_styles.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../product_details/product_details_screen.dart';
import 'components/categories.dart';
import '../../widgets/search_field.dart';
import 'components/special_offer_card.dart';
import 'components/special_offers.dart';
import 'components/text_banner.dart';

class HomeContent extends ConsumerStatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<HomeContent> {
  late double xOffset, yOffset, scaleFactor;
  late bool isDrawerOpen;

  @override
  void initState() {
    super.initState();
    xOffset = yOffset = 0.0;
    scaleFactor = 1.0;
    isDrawerOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        transform: Matrix4.translationValues(xOffset, yOffset, 0.0)
          ..scale(scaleFactor),
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
            borderRadius: (isDrawerOpen)
                ? BorderRadius.circular(40)
                : BorderRadius.circular(0),
            color: Colors.white,
            boxShadow: [if (isDrawerOpen) drawerShadow]),
        child: Builder(builder: (context) {
          return ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              // Header component
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.08),
                child: Row(
                  children: [
                    isDrawerOpen
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              setState(() {
                                xOffset = 0.0;
                                yOffset = 0.0;
                                scaleFactor = 1;
                                isDrawerOpen = false;
                              });
                            },
                          )
                        : IconButton(
                            icon:
                                SvgPicture.asset("assets/icons/hamburger.svg"),
                            onPressed: () {
                              setState(() {
                                xOffset =
                                    MediaQuery.of(context).size.width * 0.55;
                                yOffset =
                                    MediaQuery.of(context).size.height * 0.2;
                                scaleFactor = 0.6;
                                isDrawerOpen = true;
                              });
                            },
                          ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                    Expanded(
                      // take the remaining space of the row
                      child: TextField(
                          readOnly: true,
                          showCursor: true,
                          // To prevent open the keyboard
                          maxLines: 1,
                          style: kSearchFieldTextStyle,
                          onTap: () {
                            Navigator.pushNamed(
                                context, SearchPage.searchRoute);
                          },
                          decoration: searchFieldInputDecoration),
                    )
                  ],
                ),
              ),
              // Banner component
              const TextBanner(),

              // Categories component
              FutureBuilder(
                  future:     ref.read(homeRepoProvider).fetchCategories(context: context),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Category>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    return Column(
                      children: [
                        Categories(
                          categories:
                              snapshot.data != null ? snapshot.data! : [],
                        ),
                        SpecialOffers(),
                        PopularProducts(),
                      ],
                    );
                  }),
              // Special Offers component
              // Popular products component
              const CustomButtomNavBar(selectedMenu: MenuState.home),
            ],
          );
        }));
  }
}
