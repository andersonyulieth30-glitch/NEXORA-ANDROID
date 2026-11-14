import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const NexoraApp());
}

const Color azul = Color(0xFF20C8FF);
const Color morado = Color(0xFF9857FF);
const Color fondo = Color(0xFF050817);

class NexoraApp extends StatelessWidget {
  const NexoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NEXORA',
      theme: ThemeData.dark(),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animation;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  void abrirAcceso(String tipo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AccessScreen(tipo: tipo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: StarPainter()),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.2),
                      radius: 1.1,
                      colors: [
                        const Color(0xFF17234B).withOpacity(0.65),
                        fondo,
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: animation,
                            builder: (context, child) {
                              return Container(
                                padding: const EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: azul.withOpacity(
                                        0.15 + animation.value * 0.25,
                                      ),
                                      blurRadius: 25 + animation.value * 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                  border: Border.all(
                                    color: azul.withOpacity(0.5),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.change_history_rounded,
                                  color: azul,
                                  size: 43,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'NEXORA',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 7,
                              color: Colors.white,
                              shadows: [
                                Shadow(color: azul, blurRadius: 18),
                              ],
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            'TU MUNDO. TU ENTRETENIMIENTO.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFB7C7E8),
                              fontSize: 10,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 28),
                          const NexoraRobot(),
                          const SizedBox(height: 25),
                          const Text(
                            'TODO TU ENTRETENIMIENTO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 9),
                          const Text(
                            'Explora un universo de contenido',
                            style: TextStyle(
                              color: Color(0xFF9BAAC8),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 25),
                          NeonButton(
                            text: 'INICIAR SESIÓN',
                            icon: Icons.login_rounded,
                            color: azul,
                            onTap: () => abrirAcceso('Iniciar sesión'),
                          ),
                          const SizedBox(height: 14),
                          NeonButton(
                            text: 'CREAR CUENTA',
                            icon: Icons.person_add_alt_1_rounded,
                            color: morado,
                            onTap: () => abrirAcceso('Crear cuenta'),
                          ),
                          const SizedBox(height: 28),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CategoryIcon(
                                icon: Icons.movie_outlined,
                                label: 'PELÍCULAS',
                              ),
                              CategoryIcon(
                                icon: Icons.live_tv_rounded,
                                label: 'SERIES',
                              ),
                              CategoryIcon(
                                icon: Icons.sports_soccer,
                                label: 'DEPORTES',
                              ),
                              CategoryIcon(
                                icon: Icons.music_note_rounded,
                                label: 'MÚSICA',
                              ),
                            ],
                          ),
                          const SizedBox(height: 27),
                          const Text(
                            'DISFRUTA  ·  EXPLORA  ·  DESCUBRE',
                            style: TextStyle(
                              color: Color(0xFF657493),
                              fontSize: 9,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class NexoraRobot extends StatelessWidget {
  const NexoraRobot({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 165,
            height: 165,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: azul.withOpacity(0.20),
                  blurRadius: 55,
                  spreadRadius: 12,
                ),
              ],
            ),
          ),
          Positioned(
            top: 17,
            child: Container(
              width: 125,
              height: 112,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(38),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFEAF8FF),
                    Color(0xFF8BB7D9),
                    Color(0xFF344C79),
                  ],
                ),
                border: Border.all(color: azul, width: 2),
                boxShadow: const [
                  BoxShadow(color: azul, blurRadius: 17),
                ],
              ),
              child: Center(
                child: Container(
                  width: 94,
                  height: 65,
                  decoration: BoxDecoration(
                    color: const Color(0xFF07142C),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: azul, width: 1.5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RobotEye(),
                      RobotEye(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 48,
            child: Container(
              width: 23,
              height: 48,
              decoration: BoxDecoration(
                color: azul,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: azul, blurRadius: 12),
                ],
              ),
            ),
          ),
          Positioned(
            right: 15,
            top: 48,
            child: Container(
              width: 23,
              height: 48,
              decoration: BoxDecoration(
                color: morado,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: morado, blurRadius: 12),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            child: Container(
              width: 112,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  colors: [Color(0xFF263E68), Color(0xFF101B39)],
                ),
                border: Border.all(color: morado, width: 1.5),
              ),
              child: const Icon(
                Icons.headphones_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RobotEye extends StatelessWidget {
  const RobotEye({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 22,
      decoration: BoxDecoration(
        color: azul,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: azul, blurRadius: 12),
        ],
      ),
    );
  }
}

class NeonButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const NeonButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 57,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.28),
              blurRadius: 17,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, color: Colors.white),
          label: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color.withOpacity(0.85),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
              side: BorderSide(color: color, width: 1.5),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryIcon({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: azul, size: 25),
        const SizedBox(height: 7),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9BAAC8),
            fontSize: 8,
            letterSpacing: 0.7,
          ),
        ),
      ],
    );
  }
}

class AccessScreen extends StatelessWidget {
  final String tipo;

  const AccessScreen({super.key, required this.tipo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: fondo,
        title: const Text('NEXORA'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, color: azul, size: 55),
            const SizedBox(height: 20),
            Text(
              tipo,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'La conexión segura de cuentas la configuraremos en el siguiente paso.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}

class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(12);
    final paint = Paint();

    for (int i = 0; i < 110; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5 + 0.3;

      paint.color = Colors.white.withOpacity(
        random.nextDouble() * 0.55 + 0.15,
      );

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
