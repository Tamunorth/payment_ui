import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payment_ui/home_page.dart';
import 'package:payment_ui/onboarding.dart';

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
        primaryColor: Color(0xff080A0B),
        scaffoldBackgroundColor: Color(0xffF5F5F5),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xff080A0B),
        ),
        cardColor: Colors.white,
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      home: OnBoardingPage(),
    );
  }
}

class SlideFadeWidget extends StatefulWidget {
  const SlideFadeWidget({super.key});

  @override
  _SlideFadeWidgetState createState() => _SlideFadeWidgetState();
}

class _SlideFadeWidgetState extends State<SlideFadeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        seconds: 2,
      ),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: 200,
              height: 200,
              color: Colors.blue,
              child: const Center(
                child: Text(
                  'Hello',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ),
        ),
        FilledButton(
          onPressed: () {
            _controller.forward();
          },
          child: const Text('TAP'),
        )
      ],
    );
  }
}
