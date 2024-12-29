import 'package:expense_tracker/features/authentication/screens/balance_input_screen.dart';
import 'package:expense_tracker/features/categories/screens/categories_screen.dart';
import 'package:expense_tracker/firebase_options.dart';
import 'package:expense_tracker/features/tabs/navigation_menu.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => ApplicationState(),
        builder: ((context, child) => const MyApp()),
      ),
    );
  });
}

Widget _handleNavigation(BuildContext context, ApplicationState appState) {
  if (appState.isCheckingOnboarding) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  if (!appState.loggedIn) {
    return SignInScreen(
      actions: [
        ForgotPasswordAction(((context, email) {
          final uri = Uri(
            path: '/sign-in/forgot-password',
            queryParameters: <String, String?>{
              'email': email,
            },
          );
          context.push(uri.toString());
        })),
        AuthStateChangeAction(((context, state) {
          final user = switch (state) {
            SignedIn state => state.user,
            UserCreated state => state.credential.user,
            _ => null
          };
          if (user == null) {
            return;
          }
          if (state is UserCreated) {
            user.updateDisplayName(user.email!.split('@')[0]);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) context.go('/onboarding/balance');
            });
          } else {
            if (!user.emailVerified) {
              user.sendEmailVerification();
              const snackBar = SnackBar(content: Text('Please check your email to verify your email address'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
        })),
      ],
    );
  }

  switch (appState.onboardingStatus) {
    case OnboardingStatus.notStarted:
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/onboarding/balance');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    case OnboardingStatus.balanceSet:
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/onboarding/categories');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    case OnboardingStatus.categoriesSet:
    case OnboardingStatus.completed:
      return const SafeArea(child: NavigationMenu());
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => Consumer<ApplicationState>(
        builder: (context, appState, _) => _handleNavigation(context, appState),
      ),
      routes: [
        GoRoute(
          path: 'onboarding/balance',
          builder: (context, state) => const BalanceInputScreen(),
        ),
        GoRoute(
          path: 'onboarding/categories',
          builder: (context, state) => const CategoriesScreen(),
        ),
        GoRoute(
          path: 'sign-in/forgot-password',
          builder: (context, state) {
            final arguments = state.uri.queryParameters;
            return ForgotPasswordScreen(
              email: arguments['email'],
              headerMaxExtent: 200,
            );
          },
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            return ProfileScreen(
              providers: const [],
              actions: [
                SignedOutAction((context) {
                  context.go('/');
                }),
              ],
            );
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _updateAppbar();
    super.initState();
  }

  void _updateAppbar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.surface,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        // systemStatusBarContrastEnforced: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Expenses App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          onPrimary: AppColors.surface,
          secondary: AppColors.gray,
          onSecondary: AppColors.surface,
          error: Colors.red,
          onError: AppColors.surface,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
        ),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      routerConfig: _router,
    );
  }
}
