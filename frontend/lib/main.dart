import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/bloc/favorite/favorite_bloc.dart';
import 'package:store/features/bloc/order/order_bloc.dart';
import 'package:store/splash/splash_screen.dart';
import 'common/constants/routes.dart';
import 'features/bloc/cart/cart_bloc.dart';
import 'features/bloc/search/search_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoriteBloc>(
          create: (_) => FavoriteBloc(),
        ),
        BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(),
        ),
        BlocProvider<OrderBloc>(
          create: (_) => OrderBloc(),
        ),
        BlocProvider<CartBloc>(
          create: (_) => CartBloc(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Your Store',
          theme: ThemeData(fontFamily: 'Raleway'),
          initialRoute: SplashScreen.routeName,
          routes: routes
      ),
    );
  }
}
