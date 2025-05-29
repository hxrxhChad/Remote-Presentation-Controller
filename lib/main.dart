import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projecto/components/slides/slide_cubit.dart';
import 'package:projecto/core/config/injection.dart';
import 'package:projecto/core/config/routes.dart';
import 'package:projecto/core/config/secrets.dart';
import 'package:projecto/core/config/theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: AppSecrets.apiKey,
      authDomain: AppSecrets.authDomain,
      projectId: AppSecrets.projectId,
      storageBucket: AppSecrets.storageBucket,
      messagingSenderId: AppSecrets.messagingSenderId,
      appId: AppSecrets.appId,
    ),
  );
  await Injections.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SlideCubit>(create: (_) => Injections.get<SlideCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(1912, 1000),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            themeMode: ThemeMode.light,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
