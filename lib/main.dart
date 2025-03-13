import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const HoliSplashApp());
}

class HoliSplashApp extends StatelessWidget {
  const HoliSplashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HoliSplashScreen(),
    );
  }
}

class HoliSplashScreen extends StatefulWidget {
  const HoliSplashScreen({super.key});

  @override
  HoliSplashScreenState createState() => HoliSplashScreenState();
}

class HoliSplashScreenState extends State<HoliSplashScreen> {
  List<Widget> splashes = [];
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink
  ];
  final Random random = Random();

  void _addSplash(TapDownDetails details) {
    final color = colors[random.nextInt(colors.length)];
    final position = details.globalPosition;

    setState(() {
      splashes.add(
        Positioned(
          left: position.dx - 25,
          top: position.dy - 25,
          child: ColorSplash(color: color),
        ),
      );
    });
  }

  void _clearScreen() {
    setState(() {
      splashes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _addSplash,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFC1E3), // Light pink
                Color(0xFFAFE1AF), // Soft green
                Color(0xFFFFF5A1), // Soft yellow
                Color(0xFFBBF0FF), // Soft blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // ),
          ),
          child: Stack(
            children: splashes,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _clearScreen,
          backgroundColor: Colors.pinkAccent,
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

class ColorSplash extends StatefulWidget {
  final Color color;

  const ColorSplash({super.key, required this.color});

  @override
  ColorSplashState createState() => ColorSplashState();
}

class ColorSplashState extends State<ColorSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<Offset> _oscillationAnimation;
  late Random _random;

  late double _oscillationXSpeed;
  late double _oscillationYSpeed;

  @override
  void initState() {
    super.initState();

    _random = Random();
    _oscillationXSpeed = _random.nextDouble() * 0.5 + 0.5; // Random speed for X
    _oscillationYSpeed = _random.nextDouble() * 0.5 + 0.5; // Random speed for Y

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Oscillation duration
      upperBound: 1.0,
    )..repeat(reverse: true);

    // Size animation for initial growth of the circle.
    _sizeAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(_controller);

    // Oscillation effect: random direction and amplitude
    _oscillationAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(
        _random.nextDouble() * 40 -
            20, // Horizontal movement between -20 and 20
        _random.nextDouble() * 40 - 20, // Vertical movement between -20 and 20
      ),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Applying the oscillation effect (random movement)
        final oscillation = _oscillationAnimation.value;

        return Transform.translate(
          offset: Offset(
            oscillation.dx *
                sin(_oscillationXSpeed * _controller.value * pi * 2),
            oscillation.dy *
                sin(_oscillationYSpeed * _controller.value * pi * 2),
          ),
          child: FadeTransition(
            opacity: _sizeAnimation,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withOpacity(0.8),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
