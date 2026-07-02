import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/search/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF5B3DB8);
    const fontFamily = 'AppSans';

    return MaterialApp(
      title: 'GlamBook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: fontFamily,
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: fontFamily,
              bodyColor: const Color(0xFF17121F),
              displayColor: const Color(0xFF17121F),
            ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: const Color(0xFF008F7A),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF7FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAF7FC),
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Color(0xFF17121F),
          titleTextStyle: TextStyle(
            fontFamily: fontFamily,
            color: Color(0xFF17121F),
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: const TextStyle(
              fontFamily: fontFamily,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            side: BorderSide(color: primary.withValues(alpha: 0.35)),
            textStyle: const TextStyle(
              fontFamily: fontFamily,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
