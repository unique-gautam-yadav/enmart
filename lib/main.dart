import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/state/state.dart';
import 'features/cart/services/cart_provider.dart';
import 'firebase_options.dart';
import 'routes/routes_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // setPathUrlStrategy();

  // final emulatorHost =
  //     (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
  //         ? '10.0.2.2'
  //         : 'localhost';

  // await FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
        // cupertinoOverrideTheme: const CupertinoThemeData(
        //   applyThemeToAll: true,
        //   scaffoldBackgroundColor: Color.fromARGB(255, 0, 13, 86),
        // ),
      ),

      // theme: const CupertinoThemeData(),
      // home: const MyHomePage(),
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
