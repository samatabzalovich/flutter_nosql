import 'package:flutter/material.dart';

class PaymentDialog extends StatefulWidget {
  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isPaymentComplete = false;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _animation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop();
        // navigate to order page
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _completePayment() async {
    setState(() {
      _isPaymentComplete = false;
    });

    // do some async work here

    setState(() {
      _isPaymentComplete = true;
    });

    await _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Payment Dialog"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _isPaymentComplete
              ? ScaleTransition(
                  scale: _animation,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 48,
                  ),
                )
              : CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(_isPaymentComplete ? "Payment Complete!" : "Processing Payment"),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: _completePayment,
          child: Text(_isPaymentComplete ? "Done" : "Pay Now"),
        ),
      ],
    );
  }
}
