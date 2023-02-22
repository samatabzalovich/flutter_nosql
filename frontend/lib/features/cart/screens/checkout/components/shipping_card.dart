import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:store/features/bloc/current_user/current_user.dart';
import 'package:store/models/user.dart';

class ShippingCard extends ConsumerWidget {
  const ShippingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel currentUser = ref.read(currentUserProvider).currentUser!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     const Text(
        //       "Shipping information",
        //       style: TextStyle(
        //         color: Colors.black,
        //         fontSize: 17,
        //         fontWeight: FontWeight.w600,
        //       ),
        //     ),
        //     TextButton(
        //         onPressed: () {},
        //         child: const Text(
        //           "change",
        //           style: TextStyle(
        //             color: Color(0xff5956e9),
        //             fontSize: 15,
        //             fontWeight: FontWeight.w600,
        //           ),
        //         ))
        //   ],
        // ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children:  [
                    SizedBox(
                      width: 18,
                    ),
                    Icon(
                      FontAwesomeIcons.user,
                      color: Colors.black,
                      size: 20,
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    Text(
                      currentUser.firstName + " "+ currentUser.lastName,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: "Serif"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children:  [
                    SizedBox(
                      width: 12,
                    ),
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        currentUser.address,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: "Serif",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children:  [
                    SizedBox(
                      width: 12,
                    ),
                    Icon(
                      Icons.phone_in_talk_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "+7"+currentUser.phoneNumber,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Serif",
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
