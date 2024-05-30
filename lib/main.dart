import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_ui/pages/home_page.dart';
import 'package:payment_ui/pages/onboarding.dart';

const videoUrl =
    'https://cdn.pixabay.com/video/2024/03/06/203253-920308107_large.mp4';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xff080A0B),
        hintColor: const Color(0xff939494),
        scaffoldBackgroundColor: const Color(0xffF5F5F5),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xff080A0B),
        ),
        cardColor: Colors.white,
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      home: const OnBoardingPage(),
    );
  }
}
