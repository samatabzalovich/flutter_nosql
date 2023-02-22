import 'package:flutter/material.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/features/widgets/custom_app_bar.dart';

import '../../../../models/order.dart';
import 'components/checkout_body.dart';

class CheckoutScreen extends StatelessWidget {
  static const String routeName = "/checkout";
  final Order order;
  const CheckoutScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height +
              SizeConfig.getProportionateScreenHeight(40)),
          child: const CustomAppBar(
            title: "Checkout",
          )),
      body: CheckoutBody(order),
    );
  }
}
