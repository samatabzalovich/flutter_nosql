import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/features/auth/repository/auth_repository.dart';
import 'package:store/features/bloc/current_user/current_user.dart';
import 'package:store/features/home/repository/home_repository.dart';
import 'package:store/features/widgets/circle.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/common/constants/colors.dart';
import 'package:store/domain/entites/drawer_item.dart';
import 'package:store/features/auth/sign_in/sign_in_screen.dart';

import 'drawer_menu_item.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends ConsumerState<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    var user = ref.read(currentUserProvider).currentUser;

    return Container(
      color: primaryColor,
      child: ListView(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Stack(
            children: [
              Positioned(
                  top: SizeConfig.getProportionateScreenHeight(100),
                  right: SizeConfig.getProportionateScreenWidth(40),
                  child: Circle(
                    width: SizeConfig.getProportionateScreenWidth(27),
                    height: SizeConfig.getProportionateScreenHeight(27),
                    borderWidth: 6,
                  )),
              Positioned(
                  top: SizeConfig.getProportionateScreenHeight(-50),
                  right: SizeConfig.getProportionateScreenWidth(50),
                  child: Circle(
                    width: SizeConfig.getProportionateScreenWidth(125),
                    height: SizeConfig.getProportionateScreenHeight(125),
                    color: circleColor,
                  ))
            ],
          ),
        ),

        // Second Container that contains drawer items and takes 30 percentage of the screen's height
        Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  children: [
                    Column(
                        children: drawerItems
                            .map(
                              (drawerItem) => DrawerMenuItem(
                                title: drawerItem.title,
                                icon: drawerItem.icon,
                                lastItem: drawerItem.lastItem,
                                pageUrl: drawerItem.pageUrl,
                              ),
                            )
                            .toList()),
                    if (user!.type == 'seller')
                      Column(
                        children: drawerAddProductItems
                            .map(
                              (drawerItem) => DrawerMenuItem(
                                title: drawerItem.title,
                                icon: drawerItem.icon,
                                lastItem: drawerItem.lastItem,
                                pageUrl: drawerItem.pageUrl,
                              ),
                            )
                            .toList(),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
        // Third Container that contains two circles and one drawer item items and takes 20 percentage of the screen's height
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Stack(
            children: [
              Positioned(
                  left: SizeConfig.getProportionateScreenWidth(150),
                  child: Circle(
                    width: SizeConfig.getProportionateScreenWidth(27),
                    height: SizeConfig.getProportionateScreenHeight(27),
                    borderWidth: 6,
                  )),
              Positioned(
                  top: SizeConfig.getProportionateScreenHeight(50),
                  left: SizeConfig.getProportionateScreenWidth(30),
                  child: Circle(
                    width: SizeConfig.getProportionateScreenWidth(80),
                    height: SizeConfig.getProportionateScreenHeight(80),
                    color: circleColor,
                  )),
              Positioned.fill(
                top: SizeConfig.getProportionateScreenHeight(16),
                left: SizeConfig.getProportionateScreenWidth(5),
                child: DrawerMenuItem(
                  title: "Sign out",
                  icon: Icons.logout,
                  lastItem: true,
                  pageUrl: SignInScreen.routeName,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
