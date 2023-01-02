import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/features/auth/repository/auth_repository.dart';
import 'package:store/models/user.dart';
import 'package:store/common/constants/colors.dart';
import 'package:store/features/widgets/custom_page_transition.dart';
import 'package:store/features/widgets/custom_suffix_icon.dart';
import 'package:store/features/widgets/default_button.dart';
import 'package:store/features/widgets/form_errors.dart';
import 'package:store/common/Utilities/size_config.dart';
import 'package:store/common/Utilities/sqfilte_helper.dart';
import 'package:store/common/constants/form_messages.dart';
import 'package:store/features/auth/otp_screen/otp_screen.dart';
import 'package:store/features/auth/sign_up/components/sign_up_form.dart';

class CompleteProfileForm extends ConsumerStatefulWidget {
  final ScreenArgs userData;
  const CompleteProfileForm({Key? key, required this.userData})
      : super(key: key);

  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends ConsumerState<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameFormFieldKey = GlobalKey<FormFieldState>();
  final _emailFormFieldKey = GlobalKey<FormFieldState>();
  final _lastNameFormFieldKey = GlobalKey<FormFieldState>();
  final _addressFormFieldKey = GlobalKey<FormFieldState>();
  late FocusNode lastNameNode, phoneNode, addressNode;
  String? firstName;
  String? lastName;
  String? address;
  late String? email;
  List<String?> errors = [];

  @override
  void initState() {
    super.initState();
    lastNameNode = FocusNode();
    phoneNode = FocusNode();
    addressNode = FocusNode();
  }

  void signingUp() {
    ref.read(authRepositoryProvider).verifyPhoneNumber(
        context,
        widget.userData.phoneNumber,
        firstName!,
        lastName!,
        widget.userData.password,
        address!,
        email!);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            firstNameFormField(),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(30)),
            lastNameFormField(),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(30)),
            emailFormField(),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(30)),
            addressFormField(),
            FormError(errors: errors),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(40)),
            DefaultButton(
              text: "continue",
              backgroundColor: primaryColor,
              forgroundColor: Colors.white,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  try {
                    // bool result = await _sqliteDbHelper.checkEmail(
                    //     phoneNumber: widget.userData.phoneNumber);
                    signingUp();
                  } on Exception {}
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  TextFormField addressFormField() {
    return TextFormField(
      key: _addressFormFieldKey,
      onSaved: (newAddress) => address = newAddress,
      onChanged: (newAddress) {
        _addressFormFieldKey.currentState!.validate();
        address = newAddress;
      },
      focusNode: addressNode,
      validator: (newAddress) {
        if (newAddress!.isEmpty) {
          return kAddressNullError;
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Address",
        hintText: "Enter your address",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon:
            CustomSuffixIcon(svgIconPath: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField firstNameFormField() {
    return TextFormField(
      key: _firstNameFormFieldKey,
      autofocus: true,
      onFieldSubmitted: (value) {
        lastNameNode.requestFocus();
      },
      onSaved: (newFirstName) => firstName = newFirstName,
      onChanged: (newFirstName) {
        _firstNameFormFieldKey.currentState!.validate();
        firstName = newFirstName;
      },
      validator: (newFirstName) {
        if (newFirstName!.isEmpty) {
          return kFirstNameNullError;
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "First Name",
        hintText: "Enter your first name",
        suffixIcon: CustomSuffixIcon(svgIconPath: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField lastNameFormField() {
    return TextFormField(
      key: _lastNameFormFieldKey,
      onFieldSubmitted: (value) {
        phoneNode.requestFocus();
      },
      onSaved: (newLastName) => lastName = newLastName,
      onChanged: (newLastName) {
        _lastNameFormFieldKey.currentState!.validate();
        lastName = newLastName;
      },
      focusNode: lastNameNode,
      validator: (newLastName) {
        if (newLastName!.isEmpty) {
          return kLastNameNullError;
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Last Name",
        hintText: "Enter your last name",
        suffixIcon: CustomSuffixIcon(svgIconPath: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField emailFormField() {
    return TextFormField(
      key: _emailFormFieldKey,
      onSaved: (newEmail) => email = newEmail,
      onChanged: (newEmail) {
        _emailFormFieldKey.currentState!.validate();
        email = newEmail;
      },
      validator: (email) {
        if (email!.isEmpty) {
          return kEmailNullError;
        }
        if (!emailValidatorRegExp.hasMatch(email)) {
          return kInvalidEmailError;
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "email",
        hintText: "Enter your email",
        suffixIcon: CustomSuffixIcon(svgIconPath: "assets/icons/User.svg"),
      ),
    );
  }

  @override
  void dispose() {
    lastNameNode.dispose();
    phoneNode.dispose();
    addressNode.dispose();
    super.dispose();
  }
}
