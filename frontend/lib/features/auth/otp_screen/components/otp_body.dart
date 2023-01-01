import 'package:flutter/material.dart';
import 'package:store/features/widgets/horizontal_timer.dart';
import 'package:store/models/user.dart';

import 'otp_form.dart';

class OTPBody extends StatelessWidget {
  final verifictaionId;
  final phoneNumber;
  final UserModel userModel;
  const OTPBody(
      {Key? key,
      required this.verifictaionId,
      required this.phoneNumber,
      required this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Text(
              "OTP Verification",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.07,
                  color: Colors.black,
                  letterSpacing: 2),
            ),
            Text("We sent your code to $phoneNumber"),
            const HorizontalTimer(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            OTPForm(verifictaionId: verifictaionId,userModel: userModel, phoneNumber: phoneNumber,)
          ],
        ),
      ),
    );
  }
}
