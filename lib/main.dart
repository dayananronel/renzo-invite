import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const InvitationWeb());
}

class InvitationWeb extends StatelessWidget {
  const InvitationWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baptism Invitation',
      debugShowCheckedModeBanner: false,
      home: const InvitationPage(),
    );
  }
}

class InvitationPage extends StatelessWidget {
  const InvitationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // light sky blue
      body: Stack(
        children: [
          // Top-left cloud
          const Positioned(
            top: -50,
            left: -50,
            child: Cloud(size: 200),
          ),
          // Top-right cloud
          const Positioned(
            top: -40,
            right: -40,
            child: Cloud(size: 180),
          ),
          // Bottom-left cloud
          const Positioned(
            bottom: -40,
            left: -30,
            child: Cloud(size: 150),
          ),
          // Bottom-right cloud
          const Positioned(
            bottom: -60,
            right: -20,
            child: Cloud(size: 220),
          ),
          // Left balloon
          const Positioned(
            left: 20,
            top: 200,
            child: HotAirBalloon(),
          ),
          // Right balloon
          const Positioned(
            right: 20,
            top: 250,
            child: HotAirBalloon(),
          ),
          // Invitation card
          Center(
            child: Container(
              width: 350,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Join us for the',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Baptism of',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Flower-shaped baby photo
                  ClipPath(
                    clipper: FlowerClipper(),
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/renzo.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Renzo',
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Pacifico',
                      color: Color(0xFF1565C0),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'June 7, 2025 • 8:00 AM',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF546E7A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'At St.Archangel Parish Church \nPoblacion Norte, Clarin, Bohol',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF546E7A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple cloud using overlapping circles
class Cloud extends StatelessWidget {
  final double size;
  const Cloud({Key? key, this.size = 100}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.6,
      child: Stack(
        children: [
          Positioned(
            left: size * 0.2,
            child: _Circle(size * 0.6),
          ),
          Positioned(
            left: size * 0.4,
            child: _Circle(size * 0.7),
          ),
          Positioned(
            right: size * 0.2,
            child: _Circle(size * 0.5),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: size,
              height: size * 0.4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size * 0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final double diameter;
  const _Circle(this.diameter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

// Simple hot-air balloon
class HotAirBalloon extends StatelessWidget {
  const HotAirBalloon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFBBDEFB), Color(0xFF64B5F6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(child: Text('')),
        ),
        Container(
          width: 20,
          height: 14,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF8D6E63),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

// Clipper to draw a simple flower shape
class FlowerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final petalCount = 8;
    final radius = size.width / 2;
    final center = Offset(radius, radius);
    for (int i = 0; i < petalCount; i++) {
      final theta = (2 * 3.1415926 / petalCount) * i;
      final petalCenter = Offset(
        center.dx + radius * 0.6 * cos(theta),
        center.dy + radius * 0.6 * sin(theta),
      );
      path.addOval(
        Rect.fromCircle(center: petalCenter, radius: radius * 0.4),
      );
    }
    // Draw center overlap circle
    path.addOval(
      Rect.fromCircle(center: center, radius: radius * 0.6),
    );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
