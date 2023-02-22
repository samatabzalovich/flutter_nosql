import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/features/bloc/current_user/current_user.dart';
import 'package:store/models/user.dart';

class ProfilePicture extends ConsumerWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel user = ref.watch(currentUserProvider).currentUser!;
    return SizedBox(
      height: SizeConfig.getProportionateScreenHeight(150),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 25),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Text(
                  user.firstName + user.lastName,
                  style: TextStyle(
                      color: Colors.black, fontSize: 15, fontFamily: "Serif"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:  [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                    user.address,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // To add rounded image
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 56,
              width: 56,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: (user.profilePic == null) ? AssetImage(
                  "assets/images/fashion.jpg",
                ) : NetworkImage(user.profilePic!) as ImageProvider,
              ),
            ),
          )
        ],
      ),
    );
  }
}
