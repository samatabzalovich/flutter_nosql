import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/features/auth/repository/auth_repository.dart';
import 'package:store/features/bloc/current_user/current_user.dart';
import 'package:store/features/bloc/order/order_bloc.dart';
import 'package:store/features/home/screens/home_screen.dart';
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
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider<FavoriteBloc>(
        //   create: (_) => FavoriteBloc(),
        // ),
        BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Your Store',
          theme: ThemeData(fontFamily: 'Raleway'),
          // initialRoute: SplashScreen.routeName,
          home: ref.watch(userDataAuthProvider).when(
              data: (user) {
                if (user == null) {
                  return SplashScreen();
                }
                ref.read(currentUserProvider).setUser(user, context);
                return HomeScreen();
              },
              error: (error, trace) {
                return Center(child: Text(error.toString()));
              },
              loading: () => const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )),
          routes: routes),
    );
  }
}
