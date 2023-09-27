import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/logger/logger_modules/devtools_logger_module.dart';
import 'core/logger/my_logger.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/ui/login.dart';
import 'features/dashboard/bloc/dashboard_bloc.dart';
import 'features/dashboard/ui/mt_dashboard.dart';
import 'firebase_options.dart';

final dio = Dio();
late final SharedPreferences sharedPref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MyLogger.createInstance([DevToolsLoggerModule()]);
  sharedPref = await SharedPreferences.getInstance();
  // test command
  // FirebaseCRUDApiService.createDoc();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Money Tracker';

  @override
  Widget build(BuildContext context) {
    final id = sharedPref.getString('id');
    // log(id ?? 'no id');
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => DashboardBloc(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.green,
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        title: _title,
        home: id != null ? const MtDashboard() : const AuthPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
