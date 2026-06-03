import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/dependency_injection.dart';
import 'package:flutter/services.dart';

import 'config/routes/app_routers.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/logic/auth_cubit/auth_cubit.dart';
import 'features/startup/screens/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencyInjection();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const StylishApp());
}

class StylishApp extends StatelessWidget {
  const StylishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt<AuthCubit>(),
          ),
        ],
      child: MaterialApp.router(
      title: 'Stylish',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    ));
  }
}
