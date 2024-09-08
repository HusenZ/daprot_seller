import 'package:gozip_seller/bloc/auth_bloc/auth_bloc.dart';
import 'package:gozip_seller/bloc/google_auth_bloc/googe_auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBlocProvider {
  static late AppBloc _appBloc;
  static late GoogleSignInBloc _googleSignInBloc;
  static AppBloc get appBloc => _appBloc;
  static GoogleSignInBloc get googlebloc => _googleSignInBloc;

  static Future<void> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    _appBloc = AppBloc(preferences);
  }

  static Future<void> initializeGooglebloc() async {
    final preferences = await SharedPreferences.getInstance();
    _googleSignInBloc = GoogleSignInBloc(preferences);
  }
}
