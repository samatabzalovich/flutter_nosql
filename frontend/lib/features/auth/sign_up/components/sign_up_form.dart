// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:store/common/constants/colors.dart';
import 'package:store/common/constants/form_messages.dart';
import 'package:store/features/auth/complete_profile/complete_profile.dart';
import 'package:store/features/widgets/custom_button.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _mobileFormatter = MaskTextInputFormatter(
    mask: '###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberFormFieldkey = GlobalKey<FormFieldState>();
  final _passwordFormFieldKey = GlobalKey<FormFieldState>();
  final _confirmPasswordFormFieldKey = GlobalKey<FormFieldState>();
  String? phoneNumber, password, confirmedPassword;
  late FocusNode passwordFocusNode, confirmPasswordFocusNode;
  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            emailFormField(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            passwordFormField(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            confirmPasswordFormField(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            CustomButton(
              title: "Continue",
              backgroundColor: primaryColor,
              forgroundColor: Colors.white,
              width: MediaQuery.of(context).size.width * 0.85,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.pushNamed(context, CompleteProfileScreen.routeName,
                      arguments: ScreenArgs(phoneNumber: _mobileFormatter.getUnmaskedText(), password: password!));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  TextFormField emailFormField() {
    return TextFormField(
      key: _phoneNumberFormFieldkey,
      onSaved: (phoneNumber) {
        setState(() {
          phoneNumber = phoneNumber;
        });
      },
      onChanged: (phoneNumber) {
        _phoneNumberFormFieldkey.currentState!
            .validate(); // call emailFormField validator
      },
      onFieldSubmitted: (phoneNumber) {
        passwordFocusNode.requestFocus();
      },
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _mobileFormatter
      ],
      decoration: const InputDecoration(
        labelText: "Phone number",
        prefixText: '+7 (',
        hintText: '   )    -  -',
      ),
      validator: (phoneNumber) {
        if (phoneNumber!.isEmpty) {
          return kValidPhoneNumberError;
        }
        if (phoneNumber.length != 14) {
          return kValidPhoneNumberError;
        }
        return null;
      },
    );
  }

  TextFormField passwordFormField() {
    return TextFormField(
      key: _passwordFormFieldKey,
      focusNode: passwordFocusNode,
      onChanged: (newPassword) {
        _passwordFormFieldKey.currentState!
            .validate(); // call passowrd field validator
        password = newPassword;
      },
      onFieldSubmitted: (newPassword) {
        confirmPasswordFocusNode.requestFocus();
      },
      keyboardType: TextInputType.visiblePassword,
      obscureText: false,
      decoration: const InputDecoration(
          labelText: "Password",
          hintText: "Enter your password",
          suffixIcon: Icon(Icons.lock)),
      validator: (newPassword) {
        if (newPassword!.isEmpty) {
          return kPasswordNullError;
        } else if (newPassword.length < 8) {
          return kShortPasswordError;
        }
        return null;
      },
    );
  }

  TextFormField confirmPasswordFormField() {
    return TextFormField(
      key: _confirmPasswordFormFieldKey,
      focusNode: confirmPasswordFocusNode,
      onChanged: (newPassword) {
        _confirmPasswordFormFieldKey.currentState!
            .validate(); // call confirm passowrd field validator
        confirmedPassword = newPassword;
      },
      keyboardType: TextInputType.visiblePassword,
      obscureText: false,
      decoration: const InputDecoration(
          labelText: "Confrim Password",
          hintText: "Re-Enter your password",
          suffixIcon: Icon(Icons.lock)),
      validator: (newPassword) {
        if (newPassword!.isEmpty) {
          return kPasswordNullError;
        } else if (newPassword != password) {
          return kPasswordMatchError;
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }
}

class ScreenArgs {
  final String phoneNumber;
  final String password;
  const ScreenArgs({
    required this.phoneNumber,
    required this.password,
  });
}
