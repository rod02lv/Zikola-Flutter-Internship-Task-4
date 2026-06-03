import 'package:go_router/go_router.dart';
import 'package:zikola_project/features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/logic/auth_cubit/auth_cubit.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/startup/screens/onboarding_screen.dart';
import '../../features/startup/screens/splash_screen.dart';
import '../dependency_injection.dart';
import 'route_names.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    // ✅ بعد
    // GoRoute(
    //   path: RouteNames.home,
    //   name: 'home',
    //   builder: (context, state) => BlocProvider(
    //     create: (_) => getIt<WorkspaceCubit>(),
    //     child: const HomeScreen(),
    //   ),
    // ),
    //  Login
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<AuthCubit>(),
        child: SignInScreen(
          onSwitchToSignUp: () {
            context.go(RouteNames.register);
          },
        ),
      ),
    ),

//     //  Register
    GoRoute(
      path: RouteNames.register,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<AuthCubit>(),
        child: SignUpScreen(
          onSwitchToSignIn: () {
            context.go(RouteNames.login);
          },
        ),
      ),
    )
   ]
);

