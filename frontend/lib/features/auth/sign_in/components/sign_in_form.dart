import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:store/common/Utilities/keyboard_util.dart';
import 'package:store/common/Utilities/sqfilte_helper.dart';
import 'package:store/common/constants/colors.dart';
import 'package:store/common/constants/form_messages.dart';
import 'package:store/features/auth/forgot_password/forgot_password_screen.dart';
import 'package:store/features/auth/repository/auth_repository.dart';
import 'package:store/features/home/screens/home_screen.dart';
import 'package:store/features/auth/sign_up/sign_up_screen.dart';
import 'package:store/features/widgets/custom_button.dart';
import 'package:store/features/widgets/custom_page_transition.dart';

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberFormFieldKey = GlobalKey<FormFieldState>();
  final _passwordFormFieldKey = GlobalKey<FormFieldState>();
  String? number, password;
  late FocusNode passwordFocusNode;
  String paswordFieldSuffixText = "Show";
  bool _obscureText = true;
  final _mobileFormatter = MaskTextInputFormatter(
    mask: '###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  @override
  void initState() {
    super.initState();
    passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text("Login",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ),
          Form(
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        CustomScaleTransition(
                            nextPageUrl: ForgotPasswordScreen.routeName,
                            nextPage: const ForgotPasswordScreen())),
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: primaryColor,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                CustomButton(
                  title: "Login",
                  backgroundColor: primaryColor,
                  forgroundColor: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.85,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Check user Identity

                      bool result = await ref
                          .read(authRepositoryProvider)
                          .signInUser(
                              context: context,
                              phoneNumber: _mobileFormatter.getUnmaskedText(),
                              password:
                                  password!); //qwfwqwwwwwwwwwwwwwwwwwwwwwwwwwwwww
                      if (result) {
                        KeyboardUtil.hideKeyboard(context);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          HomeScreen.routeName,
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              "Please check your phone number or password"),
                          backgroundColor: Colors.black38,
                        ));
                      }
                    }
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      CustomScaleTransition(
                          nextPageUrl: SignUpScreen.routeName,
                          nextPage: const SignUpScreen())),
                  child: const Text(
                    "Create an account?",
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  TextFormField emailFormField() {
    return TextFormField(
      key: _phoneNumberFormFieldKey,
      onSaved: (phoneNumber) {
        setState(() {
          number = phoneNumber;
        });
      },
      onChanged: (phoneNumber) {
        _phoneNumberFormFieldKey.currentState!
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
      onSaved: (newPassword) {
        setState(() {
          password = newPassword;
        });
      },
      onChanged: (newPassword) {
        _passwordFormFieldKey.currentState!
            .validate(); // call passowrd field validator
      },
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscureText,
      decoration: InputDecoration(
          labelText: "Password",
          hintText: "Enter your password",
          suffixIcon: TextButton(
            child: Text(
              paswordFieldSuffixText,
              style: const TextStyle(color: primaryColor),
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
                paswordFieldSuffixText =
                    (paswordFieldSuffixText == "Show") ? "Hide" : "Show";
              });
            },
          )),
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

  @override
  void dispose() {
    passwordFocusNode.dispose();
    super.dispose();
  }
}

class ScreenArgs {
  final String number;
  final String password;
  const ScreenArgs({required this.number, required this.password});
}
