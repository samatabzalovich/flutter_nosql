import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:store/features/bloc/current_user/current_user.dart';

import '../../models/user.dart';

class DrawerItem {
  late String title;
  late IconData icon;
  late String pageUrl;
  late bool lastItem;

  DrawerItem(
      {required this.title,
      required this.icon,
      required this.pageUrl,
      required this.lastItem});
}

List<DrawerItem> drawerItems = [
  DrawerItem(
      title: "Profile",
      icon: FontAwesomeIcons.user,
      pageUrl: "/profile",
      lastItem: false),
  DrawerItem(
      title: "My Orders",
      icon: Icons.shopping_cart_outlined,
      pageUrl: "/order",
      lastItem: false),
  DrawerItem(
      title: "Favorites",
      icon: Icons.favorite_outline_outlined,
      pageUrl: "/favourite",
      lastItem: false),
];
List<DrawerItem> drawerAddProductItems = [
  DrawerItem(
      title: "Add Product",
      icon: Icons.add_sharp,
      pageUrl: "/add_product",
      lastItem: true)
];
