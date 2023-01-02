import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/common/constants/colors.dart';
import 'package:store/common/constants/form_field_styles.dart';
import 'package:store/features/auth/repository/auth_repository.dart';
import 'package:store/features/bloc/current_user/current_user.dart';
import 'package:store/features/widgets/custom_button.dart';
import 'package:store/features/home/screens/home_screen.dart';
import 'package:store/models/user.dart';

class OTPForm extends ConsumerStatefulWidget {
  final String verifictaionId;
  final String phoneNumber;
  final UserModel userModel;
  const OTPForm(
      {Key? key,
      required this.verifictaionId,
      required this.phoneNumber,
      required this.userModel})
      : super(key: key);

  @override
  ConsumerState<OTPForm> createState() => _OTPFormState();
}

class _OTPFormState extends ConsumerState<OTPForm> {
  late final TextEditingController pin1Controller,
      pin2Controller,
      pin3Controller,
      pin4Controller,
      pin5Controller,
      pin6Controller;

  @override
  void initState() {
    super.initState();
    pin1Controller = TextEditingController();
    pin2Controller = TextEditingController();
    pin3Controller = TextEditingController();
    pin4Controller = TextEditingController();
    pin5Controller = TextEditingController();
    pin6Controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildOTPField(
                  firstNode: true, lastNode: false, controller: pin1Controller),
              buildOTPField(
                  firstNode: false,
                  lastNode: false,
                  controller: pin2Controller),
              buildOTPField(
                  firstNode: false,
                  lastNode: false,
                  controller: pin3Controller),
              buildOTPField(
                  firstNode: false,
                  lastNode: false,
                  controller: pin4Controller),
              buildOTPField(
                  firstNode: false,
                  lastNode: false,
                  controller: pin5Controller),
              buildOTPField(
                  firstNode: false, lastNode: true, controller: pin6Controller)
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.13, // 13% of the screen's height
          ),
          CustomButton(
            title: "Continue",
            backgroundColor: primaryColor,
            forgroundColor: Colors.white,
            onPressed: () async {
              String pinCode = pin1Controller.text +
                  pin2Controller.text +
                  pin3Controller.text +
                  pin4Controller.text +
                  pin5Controller.text +
                  pin6Controller.text;
              // print(widget.verifictaionId);

              // We are here
              final auth = ref.read(authRepositoryProvider);
              auth.verifyOTP(
                  context: context,
                  verificationId: widget.verifictaionId,
                  userOTP: pinCode);
              String? result =
                  await auth.signUpWithPhoneNumber(context, widget.userModel);
              if (result != null) {
                UserModel user = UserModel.fromJson(result);
                ref.read(currentUserProvider).setUser(user, context);
                Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.routeName, (route) => false);
              }
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.10,
          ),
          TextButton(
            child: const Text(
              "Resend OTP code",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w200),
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget buildOTPField(
      {required TextEditingController controller,
      bool firstNode = false,
      bool lastNode = false}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.16,
      child: TextFormField(
        autofocus: true,
        obscureText: true,
        controller: controller,
        style: const TextStyle(fontSize: 24),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: otpInputDecoration,
        maxLength: 1,
        onChanged: (value) {
          if (value.isNotEmpty && lastNode == false) {
            // move forward
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && firstNode == false) {
            // return back
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    pin1Controller.dispose();
    pin2Controller.dispose();
    pin3Controller.dispose();
    pin4Controller.dispose();
    pin5Controller.dispose();
    pin6Controller.dispose();
    super.dispose();
  }
}
