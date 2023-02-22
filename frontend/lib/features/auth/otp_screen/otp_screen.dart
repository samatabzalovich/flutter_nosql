import 'package:flutter/material.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/common/constants/colors.dart';
import 'package:store/models/user.dart';

import 'components/otp_body.dart';

class OTPScreen extends StatelessWidget {
  static const String routeName = "/otp";
  final verifictaionId;
  final phoneNumber;
  final userModel;
  const OTPScreen({Key? key, this.verifictaionId, this.phoneNumber, this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: const Text("OTP Verification"),
      ),
      body: OTPBody(verifictaionId: verifictaionId, phoneNumber: phoneNumber, userModel: userModel,),
    );
  }
}
