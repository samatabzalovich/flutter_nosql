import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/common/constants/colors.dart';
import 'package:store/features/bloc/search/search_event.dart';
import 'package:store/features/home/repository/home_repository.dart';
import 'package:store/models/category.dart';

class Categories extends ConsumerStatefulWidget {
  final List<Category> categories;
  Categories({
    required this.categories,
  });

  @override
  ConsumerState<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends ConsumerState<Categories> {
  // late final bloc;
  // late List<Category> categories;

  static const TextStyle selectedItemStyle = TextStyle(
    color: primaryColor,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle unSelectedItemStyle = TextStyle(
    color: secondaryColor,
  );
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 10),
          child: Builder(
            builder:
                (BuildContext context) {
              if (widget.categories.isNotEmpty) {
                return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      widget.categories.length,
                      (index) => bottomBorderContainer(
                          index: index, categories: widget.categories),
                    ));
              } else {
                return Center(
                  child: Text('No categories found'),
                );
              }
            },
          ),
        ));
  }

  AnimatedContainer bottomBorderContainer(
      {int? index, TextButton? child, required List<Category> categories}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      margin: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: (_selectedIndex == index)
                      ? primaryColor
                      : Colors.transparent,
                  width: 3))),
      child: TextButton(
          child: Text(categories[index!].title,
              style: (_selectedIndex == index)
                  ? selectedItemStyle
                  : unSelectedItemStyle),
          onPressed: () {
            // bloc.add(FetchProductByCategoryEvent(
            //     queryString: categories[index]["title"]));
            ref
                .read(homeRepoProvider)
                .changeSelectedCategory(categories[index]);
            setState(() {
              _selectedIndex = index;
            });
          }),
    );
  }
}
