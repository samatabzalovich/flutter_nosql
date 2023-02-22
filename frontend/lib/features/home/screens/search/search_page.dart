import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/common/constants/form_field_styles.dart';
import 'package:store/common/constants/text_style.dart';
import 'package:store/features/favourite/screens/favourite_screen.dart';
import 'package:store/features/home/screens/home_screen.dart';
import 'package:store/features/home/screens/search/components/searchProductCard.dart';
import 'package:store/features/widgets/custom_bottom_navbar.dart';

import '../../../../common/constants/colors.dart';
import '../../../../common/constants/enums.dart';
import '../../../../models/category.dart';
import '../../../../models/product.dart';
import '../../../cart/screens/cart_screen.dart';
import '../../../profile/screens/profile_screen.dart';
import '../../../widgets/custom_page_transition.dart';
import '../../product_details/product_details_screen.dart';
import '../../repository/home_repository.dart';
import '../components/categories.dart';
import '../components/special_offer_card.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({
    super.key,
  });

  static String searchRoute = '/search_route';

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPRiceController = TextEditingController();
  List<Product> _searchedProduct = [];
  MenuState? selectedMenu;
  int? _catValue = 0;
  int? _filValue = 0;
  String? _category;
  String _filterName = 'title';
  bool _refresh = false;

  Future fetchSearchedProduct() async {
    if (_minPriceController.text.isEmpty) {
      _minPriceController.text = '0';
    }
    if (_maxPRiceController.text.isEmpty) {
      _maxPRiceController.text = '0';
    }
    if (_searchController.text.isEmpty) {
      _searchController.text = ' ';
    }

    if (_catValue == 0)
      _searchedProduct = await ref.read(homeRepoProvider).fetchSearchedProduct(
          context: context,
          searchQuery: _searchController.text,
          filterQuery: _filterName,
          minPrice: int.parse(_minPriceController.text),
          maxPrice: int.parse(_maxPRiceController.text));

    if (_catValue != 0)
      _searchedProduct = await ref.read(homeRepoProvider).fetchSearchedProduct(
          context: context,
          searchQuery: _searchController.text,
          categoryQuery: _category,
          filterQuery: _filterName,
          minPrice: int.parse(_minPriceController.text),
          maxPrice: int.parse(_maxPRiceController.text));

    print(_searchedProduct.length);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPRiceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.08),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                Expanded(
                  // take the remaining space of the row
                  child: TextField(
                      controller: _searchController,
                      showCursor: true,
                      autofocus: true,
                      // To prevent open the keyboard
                      maxLines: 1,
                      style: kSearchFieldTextStyle,
                      onTap: () {},
                      onChanged: (value) async {
                        await fetchSearchedProduct();
                      },
                      decoration: searchFieldInputDecoration),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.001,
                ),
              ],
            ),
          ),
          Flexible(
            child: RefreshIndicator(
              onRefresh: fetchSearchedProduct,
              child: ListView.builder(
                itemCount: _searchedProduct.length,
                itemBuilder: (context, index) {
                  return SearchProductCart(
                      category: _searchedProduct[index].category[0],
                      image: _searchedProduct[index].image,
                      price: _searchedProduct[index].price,
                      title: _searchedProduct[index].title,
                      onTap: () => Navigator.pushNamed(
                          context, ProductDetailsScreen.routeName,
                          arguments: _searchedProduct[index]));
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.getProportionateScreenHeight(4)),
            color: Colors.grey[100],
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: SizeConfig.getProportionateScreenWidth(180),
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey[200])),
                      child: Text(
                        "Category",
                        style: TextStyle(
                            fontSize: 16,
                            color: selectedMenu == MenuState.category
                                ? primaryColor
                                : inActiveIconColor),
                      ),
                      onPressed: () async {
                        selectedMenu = MenuState.category;
                        await showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  padding: EdgeInsets.all(20),
                                  child: Column(children: [
                                    Text(
                                      "Search by category",
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Flexible(
                                      child: FutureBuilder(
                                          future: ref
                                              .read(homeRepoProvider)
                                              .fetchCategories(
                                                  context: context),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<List<Category>>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            }
                                            List<Category>? categories =
                                                snapshot.data;
                                            return ListView.builder(
                                              itemCount: categories!.length + 1,
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: [
                                                    Radio(
                                                        activeColor:
                                                            primaryColor,
                                                        value: index,
                                                        groupValue: _catValue,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _catValue = index;
                                                            if (index != 0) {
                                                              _category =
                                                                  categories[
                                                                          index -
                                                                              1]
                                                                      .title;
                                                            } else {
                                                              _category = '';
                                                            }
                                                          });
                                                        }),
                                                    if (index == 0)
                                                      Text(
                                                        'All categories',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: index ==
                                                                    _catValue
                                                                ? primaryColor
                                                                : inActiveIconColor),
                                                      ),
                                                    if (index != 0)
                                                      Text(
                                                          '${categories[index - 1].title}',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: index ==
                                                                      _catValue
                                                                  ? primaryColor
                                                                  : inActiveIconColor)),
                                                  ],
                                                );
                                              },
                                            );
                                          }),
                                    ),
                                  ]),
                                );
                              });
                            });
                        fetchSearchedProduct();
                      },
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.getProportionateScreenWidth(0),
                  ),
                  Container(
                    width: SizeConfig.getProportionateScreenWidth(180),
                    child: TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey[200])),
                        child: Text(
                          'Filters',
                          style: TextStyle(
                              fontSize: 16,
                              color: selectedMenu == MenuState.filter
                                  ? primaryColor
                                  : inActiveIconColor),
                        ),
                        onPressed: () async {
                          selectedMenu = MenuState.filter;

                          await showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    padding: EdgeInsets.all(20),
                                    child: Column(children: [
                                      Text(
                                        "Search by filters",
                                        style: TextStyle(
                                            color: primaryColor, fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Flexible(
                                        child: ListView.builder(
                                            itemCount: 2,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                children: [
                                                  Radio(
                                                      activeColor: primaryColor,
                                                      value: index,
                                                      groupValue: _filValue,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _filValue = index;
                                                          if (index == 0) {
                                                            _filterName =
                                                                'title';
                                                          } else {
                                                            _filterName =
                                                                'price';
                                                          }
                                                        });
                                                      }),
                                                  Text(
                                                      index == 0
                                                          ? 'Title'
                                                          : 'Price',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: index ==
                                                                  _filValue
                                                              ? primaryColor
                                                              : inActiveIconColor)),
                                                ],
                                              );
                                            }),
                                      ),
                                      if (_filValue == 1)
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        child: Text('Min Price',
                                                            style: TextStyle(
                                                                color:
                                                                    inActiveIconColor,
                                                                fontSize: 16))),
                                                    Expanded(
                                                        child: TextFormField(
                                                      onChanged: ((value) {
                                                        print(
                                                            _minPriceController
                                                                .text);
                                                      }),
                                                      decoration:
                                                          InputDecoration(
                                                              constraints:
                                                                  BoxConstraints(
                                                                      maxWidth:
                                                                          40)),
                                                      controller:
                                                          _minPriceController,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        child: Text(
                                                      'Max Price',
                                                      style: TextStyle(
                                                          color:
                                                              inActiveIconColor,
                                                          fontSize: 16),
                                                    )),
                                                    Expanded(
                                                        child: TextFormField(
                                                      onChanged: ((value) {
                                                        print(
                                                            _maxPRiceController
                                                                .text);
                                                      }),
                                                      decoration:
                                                          InputDecoration(
                                                              constraints:
                                                                  BoxConstraints(
                                                                      maxWidth:
                                                                          40)),
                                                      controller:
                                                          _maxPRiceController,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (_filValue == 1)
                                        Container(
                                            child: TextButton(
                                          style: ButtonStyle(
                                              padding: MaterialStatePropertyAll(
                                                  EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 80)),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      primaryColor)),
                                          child: Text(
                                            "Find",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            setState(
                                              () {
                                                fetchSearchedProduct();
                                              },
                                            );
                                          },
                                        ))
                                    ]),
                                  );
                                });
                              });
                          fetchSearchedProduct();

                          // Navigator.push(
                          //   context,
                          // CustomScaleTransition(
                          //     nextPageUrl: FavouriteScreen.routeName,
                        }),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
