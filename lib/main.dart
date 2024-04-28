import 'package:daprot_seller/bloc/add_product_bloc/add_prodcut_bloc.dart';
import 'package:daprot_seller/bloc/app_bloc_provider.dart';
import 'package:daprot_seller/bloc/auth_bloc/auth_bloc.dart';
import 'package:daprot_seller/bloc/order_bloc/order_bloc.dart';
import 'package:daprot_seller/bloc/sh_bloc/sh_bloc.dart';
import 'package:daprot_seller/bloc/update_user_bloc/update_user_bloc.dart';
import 'package:daprot_seller/config/app.dart';
import 'package:daprot_seller/domain/fcm_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppBlocProvider.initialize();
  await AppBlocProvider.initializeGooglebloc();
  await NotificationApi.getFirebaseMessagingToken();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(0, 218, 40, 40),
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (context) => AppBlocProvider.appBloc,
        ),
        BlocProvider(
          create: (context) => ShBloc(),
        ),
        BlocProvider(
          create: (context) => ProductBloc(),
        ),
        BlocProvider(
          create: (context) => OrderBloc(),
        ),
        BlocProvider(
          create: (context) => UserUpdateBloc(),
        ),
        BlocProvider(
          create: (context) => AppBlocProvider.googlebloc,
        ),
      ],
      child: MyApp(),
    ),
  );
}
