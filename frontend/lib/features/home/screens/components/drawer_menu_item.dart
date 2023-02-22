import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/common/constants/colors.dart';
import 'package:store/common/constants/text_style.dart';
import 'package:store/features/auth/sign_in/sign_in_screen.dart';
import 'package:store/features/bloc/current_user/current_user.dart';

class DrawerMenuItem extends ConsumerWidget {
  final String title;
  final IconData icon;
  final bool lastItem;
  final String pageUrl;

  const DrawerMenuItem(
      {Key? key,
      required this.title,
      required this.icon,
      required this.lastItem,
      required this.pageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          // await ref.read(currentUserProvider).signOut();
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //     pageUrl, (Route<dynamic> route) => false);
          print(pageUrl);
          await Navigator.pushNamed(context, pageUrl);
        },
        child: Align(
            alignment: Alignment.centerLeft,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 18,
                    ),
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    Text(
                      title,
                      style: drawerItemTextStyle,
                    ),
                  ],
                ),
              ),
              if (!lastItem)
                Container(
                  margin: EdgeInsets.only(
                      right: SizeConfig.getProportionateScreenWidth(150),
                      top: 8),
                  height: 1,
                  width: SizeConfig.getProportionateScreenWidth(100),
                  color: secondaryColor,
                )
            ])),
      ),
    );
  }
}
