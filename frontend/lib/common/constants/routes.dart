import 'package:flutter/material.dart';
import 'package:store/features/cart/screens/cart_screen.dart';
import 'package:store/features/cart/screens/checkout/checkout_screen.dart';
import 'package:store/features/auth/complete_profile/complete_profile.dart';
import 'package:store/features/favourite/screens/favourite_screen.dart';
import 'package:store/features/auth/forgot_password/forgot_password_screen.dart';
import 'package:store/features/home/screens/home_screen.dart';
import 'package:store/features/orders/screens/orders_screen.dart';
import 'package:store/features/auth/otp_screen/otp_screen.dart';
import 'package:store/features/home/product_details/product_details_screen.dart';
import 'package:store/features/profile/screens/profile_screen.dart';
import 'package:store/features/auth/sign_in/sign_in_screen.dart';
import 'package:store/features/auth/sign_up/sign_up_screen.dart';
import 'package:store/splash/splash_screen.dart';

String uri = 'http://192.168.1.66:3000';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => const HomeScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  ProductDetailsScreen.routeName: (context) => const ProductDetailsScreen(),
  CartScreen.routeName: (context) => const CartScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  OTPScreen.routeName: (context) => const OTPScreen(),
  // CheckoutScreen.routeName: (context)  {
  //   CheckoutScreen(order: order,)
  // },
  FavouriteScreen.routeName: (context) => const FavouriteScreen(),
  OrderScreen.routeName: (context) => const OrderScreen()
};
