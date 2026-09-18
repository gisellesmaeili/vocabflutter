import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VocabApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      // Tell MaterialApp to use our router instead of a fixed home screen.
      // initialRoute is the first screen shown when the app opens.
      initialRoute: AppRouter.welcome,

      // onGenerateRoute is called every time we navigate somewhere.
      // It hands off to our AppRouter to decide which screen to show.
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}