import 'package:daprot_seller/bloc/auth_bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBlocProvider {
  static late AppBloc _appBloc;

  static AppBloc get appBloc => _appBloc;

  static Future<void> initialize() async {
    final preferences = await SharedPreferences.getInstance();

    _appBloc = AppBloc(preferences);
  }
}
