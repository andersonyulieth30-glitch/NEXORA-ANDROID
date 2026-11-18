
import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const NexoraApp());
}

const Color azul = Color(0xFF20C8FF);
const Color morado = Color(0xFF9857FF);
const Color fondo = Color(0xFF050817);
const Color panel = Color(0xFF111A30);

class NexoraApp extends StatelessWidget {
  const NexoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NEXORA',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: fondo,
        colorScheme: const ColorScheme.dark(
          primary: azul,
          secondary: morado,
          surface: panel,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: fondo,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: panel,
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.07)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: azul, width: 1.4),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF0B1224),
          indicatorColor: azul.withOpacity(0.16),
          height: 70,
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            final selected = states.contains(MaterialState.selected);
            return TextStyle(
              color: selected ? azul : Colors.white54,
              fontSize: 11,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
            );
          }),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            return IconThemeData(
              color: states.contains(MaterialState.selected)
                  ? azul
                  : Colors.white54,
              size: 23,
            );
          }),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF1B2945),
          contentTextStyle: const TextStyle(color: Colors.white),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        chipTheme: ThemeData.dark().chipTheme.copyWith(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          side: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: fondo,
            body: Center(child: CircularProgressIndicator(color: azul)),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const MainScreen();
        }

        return const WelcomeScreen();
      },
    );
  }
}

// PORTADA NEXORA

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
      duration: const Duration(seconds: 3),
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
      MaterialPageRoute(builder: (_) => AccessScreen(tipo: tipo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight < 760;
          final mascotHeight = compact ? 225.0 : 295.0;
          return Stack(
            children: [
              const Positioned.fill(child: CustomPaint(painter: StarPainter())),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.12),
                      radius: 1.15,
                      colors: [
                        const Color(0xFF123D83).withOpacity(0.78),
                        const Color(0xFF171044).withOpacity(0.86),
                        const Color(0xFF030615),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(22, compact ? 8 : 13, 22, 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - (compact ? 28 : 33),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0x66101836),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white24),
                              ),
                              child: IconButton(
                                tooltip: 'Configuración',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Configuración próximamente.'),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.settings_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: compact ? 0 : 4),
                        Column(
                          children: [
                            AnimatedBuilder(
                              animation: animation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: 1 + animation.value * 0.035,
                                  child: child,
                                );
                              },
                              child: const NexoraLogo(size: 88),
                            ),
                            const SizedBox(height: 3),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.white, Color(0xFFBBD8FF), azul, morado],
                              ).createShader(bounds),
                              child: Text(
                                'NEXORA',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: compact ? 39 : 46,
                                  height: 1,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 4.2,
                                  shadows: const [Shadow(color: azul, blurRadius: 25)],
                                ),
                              ),
                            ),
                            const SizedBox(height: 9),
                            const Text(
                              'Tu mundo. Tu entretenimiento.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 0.4,
                                shadows: [Shadow(color: morado, blurRadius: 12)],
                              ),
                            ),
                            const SizedBox(height: 13),
                            Container(
                              width: 190,
                              height: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: const LinearGradient(colors: [azul, morado]),
                                boxShadow: const [BoxShadow(color: azul, blurRadius: 12)],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: compact ? 0 : 7),
                        SizedBox(
                          height: mascotHeight,
                          child: const WelcomeMascot(),
                        ),
                        Column(
                          children: [
                            NeonButton(
                              text: 'Iniciar Sesión',
                              icon: Icons.person_rounded,
                              color: azul,
                              onTap: () => abrirAcceso('Iniciar sesión'),
                            ),
                            const SizedBox(height: 13),
                            NeonButton(
                              text: 'Crear Cuenta',
                              icon: Icons.person_add_alt_1_rounded,
                              color: morado,
                              onTap: () => abrirAcceso('Crear cuenta'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xCC080F27),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: azul.withOpacity(0.45), width: 1.2),
                            boxShadow: [
                              BoxShadow(color: azul.withOpacity(0.12), blurRadius: 18),
                            ],
                          ),
                          child: const Row(
                            children: [
                              WelcomeCategory(icon: Icons.movie_creation_rounded, label: 'Películas'),
                              WelcomeDivider(),
                              WelcomeCategory(icon: Icons.live_tv_rounded, label: 'Series'),
                              WelcomeDivider(),
                              WelcomeCategory(icon: Icons.sports_esports_rounded, label: 'Juegos'),
                              WelcomeDivider(),
                              WelcomeCategory(icon: Icons.star_rounded, label: 'Y mucho más...'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 17),
                        Row(
                          children: [
                            const Expanded(child: NeonLine()),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'DISFRUTA  ·  EXPLORA  ·  DESCUBRE',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: azul,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ),
                            const Expanded(child: NeonLine()),
                          ],
                        ),
                      ],
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

class NexoraLogo extends StatelessWidget {
  final double size;

  const NexoraLogo({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: -0.55,
            child: Container(
              width: size * 0.94,
              height: size * 0.36,
              decoration: BoxDecoration(
                border: Border.all(color: azul, width: 4),
                borderRadius: BorderRadius.circular(100),
                boxShadow: const [
                  BoxShadow(color: azul, blurRadius: 13),
                ],
              ),
            ),
          ),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [azul, Colors.white, morado],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Icon(
              Icons.change_history_rounded,
              size: size * 0.88,
              color: Colors.white,
            ),
          ),
          Icon(
            Icons.play_arrow_rounded,
            size: size * 0.35,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class WelcomeMascot extends StatelessWidget {
  const WelcomeMascot({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 285,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 7,
            child: Container(
              width: 235,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: azul.withOpacity(0.45),
                    blurRadius: 42,
                    spreadRadius: 9,
                  ),
                  BoxShadow(
                    color: morado.withOpacity(0.35),
                    blurRadius: 55,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 45,
            child: Transform.rotate(
              angle: -0.15,
              child: const Icon(
                Icons.movie_filter_rounded,
                color: Color(0xFF9D7BFF),
                size: 76,
                shadows: [Shadow(color: morado, blurRadius: 18)],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 75,
            child: Transform.rotate(
              angle: 0.12,
              child: Container(
                width: 72,
                height: 62,
                decoration: BoxDecoration(
                  color: const Color(0xFF111B42),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: morado, width: 2),
                  boxShadow: const [
                    BoxShadow(color: morado, blurRadius: 15),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: azul,
                  size: 49,
                ),
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: 5,
            child: const Icon(
              Icons.local_movies_rounded,
              color: Color(0xFFFFB6DC),
              size: 57,
              shadows: [Shadow(color: morado, blurRadius: 15)],
            ),
          ),
          Positioned(
            left: 5,
            top: 18,
            child: Icon(
              Icons.star,
              color: azul.withOpacity(0.9),
              size: 18,
              shadows: const [Shadow(color: azul, blurRadius: 12)],
            ),
          ),
          Positioned(
            right: 25,
            top: 18,
            child: Icon(
              Icons.auto_awesome,
              color: morado.withOpacity(0.95),
              size: 22,
              shadows: const [Shadow(color: morado, blurRadius: 12)],
            ),
          ),
          const Positioned(
            bottom: 0,
            child: NexoraRobot(),
          ),
        ],
      ),
    );
  }
}

class NexoraRobot extends StatelessWidget {
  const NexoraRobot({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 225,
      height: 265,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 52,
            child: Container(
              width: 178,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: azul.withOpacity(0.18),
                    blurRadius: 45,
                    spreadRadius: 12,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 150,
              height: 105,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(60),
                  bottom: Radius.circular(25),
                ),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF172C50),
                    Color(0xFF070F25),
                  ],
                ),
                border: Border.all(color: azul, width: 2),
                boxShadow: const [
                  BoxShadow(color: azul, blurRadius: 17),
                ],
              ),
              child: const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 17),
                  child: Text(
                    'N',
                    style: TextStyle(
                      color: azul,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      shadows: [Shadow(color: azul, blurRadius: 16)],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 43,
            child: Container(
              width: 153,
              height: 137,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(47),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF1FAFF),
                    Color(0xFF9DBDD9),
                    Color(0xFF334C78),
                  ],
                ),
                border: Border.all(color: azul, width: 2.5),
                boxShadow: const [
                  BoxShadow(color: azul, blurRadius: 20),
                ],
              ),
              child: Center(
                child: Container(
                  width: 119,
                  height: 83,
                  decoration: BoxDecoration(
                    color: const Color(0xFF07132B),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: azul, width: 2),
                    boxShadow: const [
                      BoxShadow(color: azul, blurRadius: 12),
                    ],
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
            top: 8,
            child: Container(
              width: 150,
              height: 57,
              decoration: BoxDecoration(
                color: const Color(0xFF090F28),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(65),
                  bottom: Radius.circular(15),
                ),
                border: Border.all(color: azul, width: 2),
                boxShadow: const [
                  BoxShadow(color: morado, blurRadius: 12),
                ],
              ),
              child: const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Text(
                    'N',
                    style: TextStyle(
                      color: azul,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 80,
            child: _robotEar(azul),
          ),
          Positioned(
            right: 15,
            top: 80,
            child: _robotEar(morado),
          ),
          Positioned(
            right: 7,
            bottom: 78,
            child: Transform.rotate(
              angle: -0.65,
              child: Container(
                width: 43,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFB8D8F2),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: azul, width: 2),
                  boxShadow: const [
                    BoxShadow(color: azul, blurRadius: 13),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _robotEar(Color color) {
    return Container(
      width: 34,
      height: 68,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF172B50), Color(0xFF050B1D)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color, width: 2.5),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.85), blurRadius: 17),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.9), width: 2),
          color: color.withOpacity(0.16),
        ),
      ),
    );
  }
}

class RobotEye extends StatelessWidget {
  const RobotEye({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 29,
      decoration: BoxDecoration(
        color: azul,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: azul, blurRadius: 15),
        ],
      ),
    );
  }
}

class WelcomeCategory extends StatelessWidget {
  final IconData icon;
  final String label;

  const WelcomeCategory({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: azul, size: 27),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomeDivider extends StatelessWidget {
  const WelcomeDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      width: 1,
      color: morado.withOpacity(0.65),
    );
  }
}

class NeonLine extends StatelessWidget {
  const NeonLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.transparent, azul],
        ),
        boxShadow: [
          BoxShadow(color: azul.withOpacity(0.5), blurRadius: 8),
        ],
      ),
    );
  }
}

// BOTONES

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
      height: 66,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.38),
              blurRadius: 19,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            backgroundColor: color == azul
                ? const Color(0xFF0879D9)
                : const Color(0xFF8500D7),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
              side: BorderSide(color: color, width: 2),
            ),
            elevation: 0,
          ),
          child: Row(
            children: [
              Icon(icon, size: 31),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 31),
            ],
          ),
        ),
      ),
    );
  }
}

// ACCESO FIREBASE

class AccessScreen extends StatefulWidget {
  final String tipo;

  const AccessScreen({super.key, required this.tipo});

  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool cargando = false;
  bool ocultarPassword = true;

  bool get esRegistro => widget.tipo == 'Crear cuenta';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String mensajeError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'El correo electrónico no es válido.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos.';
      case 'email-already-in-use':
        return 'Este correo ya tiene una cuenta.';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres.';
      case 'network-request-failed':
        return 'Revisa tu conexión a internet.';
      case 'too-many-requests':
        return 'Demasiados intentos. Inténtalo más tarde.';
      default:
        return 'No se pudo completar la operación. Inténtalo nuevamente.';
    }
  }

  Future<void> continuar() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => cargando = true);

    try {
      if (esRegistro) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
      }

      if (mounted) Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensajeError(e))),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ocurrió un error. Inténtalo nuevamente.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  Future<void> recuperarPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escribe tu correo para recuperar la contraseña.'),
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Te enviamos un enlace para recuperar tu contraseña.',
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensajeError(e))),
        );
      }
    }
  }

  void cambiarTipo() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AccessScreen(
          tipo: esRegistro ? 'Iniciar sesión' : 'Crear cuenta',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = esRegistro ? morado : azul;
    return Scaffold(
      backgroundColor: fondo,
      body: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: StarPainter())),
          Positioned(
            top: -110,
            right: -90,
            child: _AmbientGlow(color: accent.withOpacity(0.32), size: 250),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                          tooltip: 'Volver',
                        ),
                        const Spacer(),
                        const Text('NEXORA', style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                        )),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accent.withOpacity(0.12),
                        border: Border.all(color: accent.withOpacity(0.6)),
                        boxShadow: [BoxShadow(color: accent.withOpacity(0.18), blurRadius: 28)],
                      ),
                      child: NexoraLogo(size: 76),
                    )),
                    const SizedBox(height: 24),
                    Text(
                      esRegistro ? 'ÚNETE A NEXORA' : 'QUÉ BUENO TENERTE DE VUELTA',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900, letterSpacing: 0.7),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      esRegistro ? 'Crea tu cuenta y comienza a descubrir.' : 'Inicia sesión para entrar a tu universo de entretenimiento.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white60, fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xCC101A32),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: accent.withOpacity(0.28)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('CORREO ELECTRÓNICO', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.3)),
                          const SizedBox(height: 9),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            decoration: const InputDecoration(hintText: 'tu correo electrónico', prefixIcon: Icon(Icons.email_outlined)),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) return 'Escribe tu correo electrónico.';
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value.trim())) return 'Escribe un correo válido.';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text('CONTRASEÑA', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.3)),
                          const SizedBox(height: 9),
                          TextFormField(
                            controller: passwordController,
                            obscureText: ocultarPassword,
                            decoration: InputDecoration(
                              hintText: 'Tu contraseña',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => ocultarPassword = !ocultarPassword),
                                icon: Icon(ocultarPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Escribe tu contraseña.';
                              if (esRegistro && value.length < 6) return 'Usa al menos 6 caracteres.';
                              return null;
                            },
                          ),
                          if (!esRegistro)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(onPressed: recuperarPassword, child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(color: azul))),
                            )
                          else
                            const SizedBox(height: 18),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: cargando ? null : continuar,
                              icon: cargando ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Icon(esRegistro ? Icons.person_add_alt_1_rounded : Icons.login_rounded),
                              label: Text(esRegistro ? 'CREAR MI CUENTA' : 'ENTRAR A NEXORA', style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accent == azul ? const Color(0xFF0879D9) : const Color(0xFF7628C8),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: accent, width: 1.2)),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: cambiarTipo,
                      child: Text(
                        esRegistro ? '¿Ya tienes cuenta? Inicia sesión' : '¿Aún no tienes cuenta? Regístrate',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: accent, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_user_rounded, color: Colors.white38, size: 15),
                        SizedBox(width: 7),
                        Text('Acceso protegido mediante Firebase', style: TextStyle(color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// MENÚ PRINCIPAL

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selected = 0;

  final pages = const [
    HomePage(),
    MoviesPage(),
    ExplorePage(),
    LibraryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: Stack(
        children: [
          const Positioned(
            top: -130,
            right: -110,
            child: _AmbientGlow(color: Color(0x3320C8FF), size: 260),
          ),
          IndexedStack(index: selected, children: pages),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xF20B1224),
            borderRadius: BorderRadius.circular(23),
            border: Border.all(color: azul.withOpacity(0.22)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 22, offset: const Offset(0, 7))],
          ),
          child: Row(
            children: [
              _NavItem(icon: Icons.home_rounded, label: 'Inicio', selected: selected == 0, onTap: () => setState(() => selected = 0)),
              _NavItem(icon: Icons.movie_rounded, label: 'Películas', selected: selected == 1, onTap: () => setState(() => selected = 1)),
              _NavItem(icon: Icons.explore_rounded, label: 'Explorar', selected: selected == 2, onTap: () => setState(() => selected = 2)),
              _NavItem(icon: Icons.bookmark_rounded, label: 'Biblioteca', selected: selected == 3, onTap: () => setState(() => selected = 3)),
              _NavItem(icon: Icons.person_rounded, label: 'Perfil', selected: selected == 4, onTap: () => setState(() => selected = 4)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          decoration: BoxDecoration(
            color: selected ? azul.withOpacity(0.13) : Colors.transparent,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: selected ? azul : Colors.white54, size: 22),
              const SizedBox(height: 4),
              Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: selected ? azul : Colors.white54, fontSize: 9, fontWeight: selected ? FontWeight.w900 : FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  final Color color;
  final double size;

  const _AmbientGlow({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.01),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 35)],
        ),
      ),
    );
  }
}

// PELÍCULAS DE DEMOSTRACIÓN

class MovieData {
  final String title;
  final String category;
  final String year;
  final String description;
  final String duration;
  final String image;

  const MovieData({
    required this.title,
    required this.category,
    required this.year,
    required this.description,
    required this.duration,
    required this.image,
  });
}

const List<MovieData> movies = [
  MovieData(
    title: 'Universo desconocido',
    category: 'Ciencia ficción',
    year: '2025',
    description:
        'Una expedición se adentra en los misterios del universo para descubrir mundos y secretos que cambiarán su destino.',
    duration: '1 h 48 min',
    image:
        'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=900',
  ),
  MovieData(
    title: 'Mundo salvaje',
    category: 'Aventura',
    year: '2024',
    description:
        'Un viaje por paisajes extraordinarios donde la naturaleza revela toda su fuerza y belleza.',
    duration: '1 h 35 min',
    image:
        'https://images.unsplash.com/photo-1511497584788-876760111969?w=900',
  ),
  MovieData(
    title: 'La gran aventura',
    category: 'Acción',
    year: '2023',
    description:
        'Una aventura llena de desafíos, descubrimientos y decisiones que pondrán a prueba a sus protagonistas.',
    duration: '2 h 05 min',
    image:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=900',
  ),
  MovieData(
    title: 'Más allá del espacio',
    category: 'Fantasía',
    year: '2025',
    description:
        'Una travesía imaginaria hacia lugares sorprendentes más allá de las estrellas.',
    duration: '1 h 52 min',
    image:
        'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=900',
  ),
  MovieData(
    title: 'Horizonte azul',
    category: 'Drama',
    year: '2022',
    description:
        'Una historia sobre nuevos comienzos, esperanza y la fuerza para seguir adelante.',
    duration: '1 h 41 min',
    image:
        'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?w=900',
  ),
  MovieData(
    title: 'Noche estelar',
    category: 'Ciencia ficción',
    year: '2024',
    description:
        'Un misterio en el espacio lleva a un grupo de exploradores a enfrentar lo desconocido.',
    duration: '1 h 56 min',
    image:
        'https://images.unsplash.com/photo-1500534623283-312aade485b7?w=900',
  ),
  MovieData(
    title: 'El planeta azul',
    category: 'Documental',
    year: '2023',
    description:
        'Un recorrido visual por algunos de los paisajes más fascinantes de nuestro planeta.',
    duration: '1 h 20 min',
    image:
        'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=900',
  ),
  MovieData(
    title: 'Camino a la cima',
    category: 'Aventura',
    year: '2025',
    description:
        'Una aventura de superación en la que cada paso acerca a los protagonistas a su objetivo.',
    duration: '1 h 44 min',
    image:
        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=900',
  ),
];

const List<String> movieGenres = [
  'Todas',
  'Acción',
  'Aventura',
  'Ciencia ficción',
  'Fantasía',
  'Drama',
  'Documental',
];

// CATÁLOGO REAL DE SERIES - TVMAZE (CC BY-SA, CON ATRIBUCIÓN)

class SeriesData {
  final int id;
  final String title;
  final String genre;
  final String synopsis;
  final String year;
  final String image;
  final String status;

  const SeriesData({
    required this.id,
    required this.title,
    required this.genre,
    required this.synopsis,
    required this.year,
    required this.image,
    required this.status,
  });

  factory SeriesData.fromJson(Map<String, dynamic> json) {
    final premiered = (json['premiered'] ?? '').toString();
    final imageData = json['image'] is Map ? json['image'] as Map : null;
    final genresData = json['genres'];
    final genres = genresData is List
        ? genresData.map((item) => item.toString()).where((item) => item.isNotEmpty).join(' · ')
        : '';
    final rawSummary = (json['summary'] ?? 'Sin sinopsis disponible.').toString();
    final cleanSummary = rawSummary
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();

    return SeriesData(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['name'] ?? 'Serie sin título').toString(),
      genre: genres.isEmpty ? 'Series' : genres,
      synopsis: cleanSummary.isEmpty ? 'Sin sinopsis disponible.' : cleanSummary,
      year: premiered.length >= 4 ? premiered.substring(0, 4) : 'Año no disponible',
      image: (imageData?['original'] ?? imageData?['medium'] ?? '').toString(),
      status: (json['status'] ?? 'Información no disponible').toString(),
    );
  }
}

Future<List<SeriesData>> searchTvMazeShows(String query) async {
  final client = HttpClient();
  try {
    final uri = Uri.https('api.tvmaze.com', '/search/shows', {'q': query});
    final request = await client.getUrl(uri).timeout(const Duration(seconds: 15));
    request.headers.set(HttpHeaders.userAgentHeader, 'NEXORA-Android/1.0');
    final response = await request.close().timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('No fue posible consultar el catálogo (${response.statusCode}).');
    }
    final body = await response.transform(utf8.decoder).join();
    final decoded = jsonDecode(body);
    if (decoded is! List) return [];
    return decoded
        .where((item) => item is Map && item['show'] is Map)
        .map((item) => SeriesData.fromJson(Map<String, dynamic>.from(item['show'] as Map)))
        .where((show) => show.id > 0)
        .toList();
  } finally {
    client.close(force: true);
  }
}

Future<List<Map<String, dynamic>>> loadTvMazeEpisodes(int showId) async {
  final client = HttpClient();
  try {
    final uri = Uri.https('api.tvmaze.com', '/shows/$showId/episodes');
    final request = await client.getUrl(uri).timeout(const Duration(seconds: 15));
    request.headers.set(HttpHeaders.userAgentHeader, 'NEXORA-Android/1.0');
    final response = await request.close().timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('No fue posible cargar los episodios.');
    }
    final body = await response.transform(utf8.decoder).join();
    final decoded = jsonDecode(body);
    if (decoded is! List) return [];
    return decoded.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
  } finally {
    client.close(force: true);
  }
}

class SeriesPage extends StatefulWidget {
  const SeriesPage({super.key});

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  final TextEditingController searchController = TextEditingController(text: 'the');
  List<SeriesData> results = [];
  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _search('the');
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    final term = query.trim();
    if (term.isEmpty) {
      setState(() {
        results = [];
        loading = false;
        errorMessage = 'Escribe el nombre de una serie para buscar.';
      });
      return;
    }
    setState(() {
      loading = true;
      errorMessage = null;
    });
    try {
      final found = await searchTvMazeShows(term);
      if (!mounted) return;
      setState(() {
        results = found;
        loading = false;
        if (found.isEmpty) errorMessage = 'No encontramos series con esa búsqueda.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        loading = false;
        errorMessage = 'No se pudo conectar al catálogo. Revisa tu internet e inténtalo de nuevo.';
      });
    }
  }

  void _showDetails(BuildContext context, SeriesData series) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF101A30),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(5)))),
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: series.image.isEmpty
                      ? Container(height: 175, width: double.infinity, color: panel, child: const Icon(Icons.live_tv_rounded, color: azul, size: 55))
                      : Image.network(series.image, height: 175, width: double.infinity, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(height: 175, color: panel, child: const Icon(Icons.live_tv_rounded, color: azul, size: 55))),
                ),
                const SizedBox(height: 16),
                Text(series.title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text('${series.genre}  ·  ${series.year}  ·  ${series.status}', style: const TextStyle(color: azul, fontSize: 11, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Text(series.synopsis, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
                const SizedBox(height: 18),
                const Text('EPISODIOS DISPONIBLES EN TVMAZE', style: TextStyle(color: azul, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                const SizedBox(height: 9),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: loadTvMazeEpisodes(series.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(padding: EdgeInsets.all(18), child: Center(child: CircularProgressIndicator(color: azul)));
                    }
                    if (snapshot.hasError) {
                      return const Text('No se pudieron cargar los episodios.', style: TextStyle(color: Colors.white54, fontSize: 12));
                    }
                    final episodes = snapshot.data ?? [];
                    if (episodes.isEmpty) {
                      return const Text('No hay episodios publicados en el catálogo.', style: TextStyle(color: Colors.white54, fontSize: 12));
                    }
                    return Column(
                      children: episodes.take(12).map((episode) {
                        final season = episode['season'] ?? '?';
                        final number = episode['number'] ?? '?';
                        final name = (episode['name'] ?? 'Episodio').toString();
                        return Container(
                          margin: const EdgeInsets.only(bottom: 7),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(12)),
                          child: Row(children: [
                            const Icon(Icons.play_circle_outline_rounded, color: azul, size: 23),
                            const SizedBox(width: 10),
                            Expanded(child: Text('T$season · E$number  —  $name', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))),
                          ]),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, height: 48, child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlayerScreen(title: '${series.title} · Video de prueba')));
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('PROBAR REPRODUCTOR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
                  style: ElevatedButton.styleFrom(backgroundColor: azul, foregroundColor: fondo, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
                )),
                const SizedBox(height: 8),
                const Text('Los datos de series y episodios provienen de TVmaze. El botón reproduce un video de demostración; TVmaze no proporciona videos ni derechos de reproducción.', style: TextStyle(color: Colors.white38, fontSize: 10, height: 1.4)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(title: const Row(children: [Icon(Icons.live_tv_rounded, color: azul), SizedBox(width: 9), Text('SERIES NEXORA')])),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('DESCUBRE SERIES REALES', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
                const SizedBox(height: 5),
                const Text('Busca títulos, consulta temporadas y conoce sus episodios.', style: TextStyle(color: Colors.white60, fontSize: 11)),
                const SizedBox(height: 14),
                TextField(
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _search,
                  decoration: InputDecoration(
                    hintText: 'Buscar una serie...',
                    prefixIcon: const Icon(Icons.search_rounded, color: azul),
                    suffixIcon: IconButton(icon: const Icon(Icons.arrow_forward_rounded, color: azul), onPressed: () => _search(searchController.text)),
                    filled: true,
                    fillColor: panel,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Catálogo de series: TVmaze · tvmaze.com', style: TextStyle(color: Colors.white38, fontSize: 10)),
              ]),
            ),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator(color: azul))
                  : errorMessage != null
                      ? Center(child: Padding(padding: const EdgeInsets.all(25), child: Column(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.cloud_off_rounded, color: Colors.white38, size: 38),
                          const SizedBox(height: 12),
                          Text(errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                          const SizedBox(height: 12),
                          OutlinedButton(onPressed: () => _search(searchController.text), child: const Text('REINTENTAR')),
                        ])))
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(18, 4, 18, 25),
                          itemCount: results.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 13, mainAxisSpacing: 17, childAspectRatio: 0.62),
                          itemBuilder: (context, index) {
                            final series = results[index];
                            return InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => _showDetails(context, series),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Expanded(child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: morado.withOpacity(0.3))),
                                  child: ClipRRect(borderRadius: BorderRadius.circular(14), child: series.image.isEmpty
                                      ? Container(color: panel, child: const Icon(Icons.live_tv_rounded, color: morado, size: 45))
                                      : Image.network(series.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: panel, child: const Icon(Icons.live_tv_rounded, color: morado, size: 45)))),
                                )),
                                const SizedBox(height: 8),
                                Text(series.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                                const SizedBox(height: 3),
                                Text('${series.genre} · ${series.year}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54, fontSize: 9)),
                                Text(series.status, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: morado, fontSize: 9, fontWeight: FontWeight.w700)),
                              ]),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// INICIO ESTILO PLATAFORMA DE STREAMING

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<CategoryData> categories = [
    CategoryData('Películas', Icons.movie_rounded),
    CategoryData('Series', Icons.live_tv_rounded),
    CategoryData('TV en vivo', Icons.tv_rounded),
    CategoryData('Deportes', Icons.sports_soccer_rounded),
    CategoryData('Música', Icons.music_note_rounded),
    CategoryData('Videos', Icons.video_library_rounded),
    CategoryData('Documentales', Icons.public_rounded),
    CategoryData('Educación', Icons.school_rounded),
  ];

  void openMovies(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const MoviesPage()));
  }

  @override
  Widget build(BuildContext context) {
    final featured = movies[0];
    final trending = movies.take(5).toList();
    final adventures = movies.where((m) => m.category == 'Aventura').toList();
    final sciFi = movies.where((m) => m.category == 'Ciencia ficción').toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
        children: [
          Row(
            children: [
              const NexoraLogo(size: 39),
              const SizedBox(width: 9),
              const Text('NEXORA', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 2.4, shadows: [Shadow(color: azul, blurRadius: 12)])),
              const Spacer(),
              IconButton(
                tooltip: 'Buscar contenido',
                onPressed: () => openMovies(context),
                icon: const Icon(Icons.search_rounded, color: Colors.white, size: 27),
              ),
              IconButton(
                tooltip: 'Mi perfil',
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
                icon: const Icon(Icons.account_circle_rounded, color: azul, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Text('HOLA, BIENVENIDO', style: TextStyle(color: azul, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFF14243F), borderRadius: BorderRadius.circular(20), border: Border.all(color: azul.withOpacity(0.25))),
                child: const Row(children: [Icon(Icons.circle, color: Color(0xFF39E6A5), size: 7), SizedBox(width: 6), Text('TU UNIVERSO', style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1))]),
              ),
            ],
          ),
          const SizedBox(height: 9),
          const Text('¿QUÉ VAMOS A VER HOY?', style: TextStyle(fontSize: 25, height: 1.08, fontWeight: FontWeight.w900, letterSpacing: 0.2)),
          const SizedBox(height: 7),
          const Text('Encuentra tu próxima historia favorita.', style: TextStyle(color: Color(0xFF9BAAC8), fontSize: 12)),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: Container(
              height: 285,
              decoration: BoxDecoration(border: Border.all(color: azul.withOpacity(0.38)), borderRadius: BorderRadius.circular(23), boxShadow: [BoxShadow(color: azul.withOpacity(0.12), blurRadius: 24)]),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(featured.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF183C70), Color(0xFF321B59), fondo])), child: Center(child: Icon(Icons.movie_filter_rounded, color: azul, size: 76)))),
                  const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x11000000), Color(0xDD050817), Color(0xFF050817)]))),
                  Positioned(left: 17, right: 17, bottom: 17, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: azul.withOpacity(0.18), borderRadius: BorderRadius.circular(20), border: Border.all(color: azul.withOpacity(0.8))), child: const Text('NEXORA  ·  DESTACADO', style: TextStyle(color: azul, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.2))),
                    const SizedBox(height: 10),
                    Text(featured.title.toUpperCase(), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 25, height: 1.05, fontWeight: FontWeight.w900, shadows: [Shadow(color: Colors.black, blurRadius: 12)])),
                    const SizedBox(height: 6),
                    Text(featured.category + '  ·  ' + featured.duration, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 13),
                    Row(children: [
                      ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailPage(movie: featured))), icon: const Icon(Icons.play_arrow_rounded, size: 20), label: const Text('VER AHORA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.7)), style: ElevatedButton.styleFrom(backgroundColor: azul, foregroundColor: fondo, padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                      const SizedBox(width: 9),
                      OutlinedButton.icon(onPressed: () => openMovies(context), icon: const Icon(Icons.explore_rounded, size: 17), label: const Text('EXPLORAR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withOpacity(0.45)), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                    ]),
                  ])),
                ],
              ),
            ),
          ),
          const SizedBox(height: 27),
          const SectionHeader(title: 'TENDENCIAS EN NEXORA', subtitle: 'Lo que no te puedes perder'),
          const SizedBox(height: 13),
          SizedBox(height: 205, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: trending.length, separatorBuilder: (_, __) => const SizedBox(width: 13), itemBuilder: (context, index) => MediaCard(media: trending[index]))),
          const SizedBox(height: 27),
          const SectionHeader(title: 'AVENTURAS PARA DESCUBRIR', subtitle: 'Historias que te llevan más lejos'),
          const SizedBox(height: 13),
          SizedBox(height: 205, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: adventures.length, separatorBuilder: (_, __) => const SizedBox(width: 13), itemBuilder: (context, index) => MediaCard(media: adventures[index]))),
          const SizedBox(height: 27),
          const SectionHeader(title: 'MÁS ALLÁ DEL UNIVERSO', subtitle: 'Explora ciencia ficción y mundos increíbles'),
          const SizedBox(height: 13),
          SizedBox(height: 205, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: sciFi.length, separatorBuilder: (_, __) => const SizedBox(width: 13), itemBuilder: (context, index) => MediaCard(media: sciFi[index]))),
          const SizedBox(height: 28),
          const SectionHeader(title: 'EXPLORA POR CATEGORÍA', subtitle: 'Elige lo que te apetece disfrutar'),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.55),
            itemBuilder: (context, index) {
              final item = categories[index];
              return InkWell(
                borderRadius: BorderRadius.circular(17),
                onTap: () {
                  if (item.name == 'Películas') {
                    openMovies(context);
                  } else if (item.name == 'Series') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SeriesPage()));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryPage(title: item.name)));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(17), gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF192C4B), Color(0xFF211A40)]), border: Border.all(color: azul.withOpacity(0.25))),
                  padding: const EdgeInsets.all(13),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Icon(item.icon, color: azul, size: 29), const SizedBox(height: 9), Text(item.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))]),
                ),
              );
            },
          ),
          const SizedBox(height: 25),
          Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), gradient: LinearGradient(colors: [azul.withOpacity(0.15), morado.withOpacity(0.15)]), border: Border.all(color: azul.withOpacity(0.25))), child: const Row(children: [Icon(Icons.auto_awesome, color: azul, size: 30), SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('EL UNIVERSO NEXORA', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)), SizedBox(height: 5), Text('Disfruta, explora y descubre nuevas experiencias.', style: TextStyle(color: Colors.white70, fontSize: 11))]))])),
        ],
      ),
    );
  }
}

// CATÁLOGO

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  final searchController = TextEditingController();
  List<MovieData> archiveMovies = [];
  bool loading = true;
  String? loadError;

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    if (mounted) {
      setState(() {
        loading = true;
        loadError = null;
      });
    }
    try {
      final uri = Uri.https('archive.org', '/advancedsearch.php', {
        'q': 'mediatype:movies AND collection:feature_films',
        'fl[]': 'identifier,title,year,description',
        'rows': '48',
        'page': '1',
        'output': 'json',
        'sort[]': 'downloads desc',
      });
      final response = await http.get(uri).timeout(const Duration(seconds: 25));
      if (response.statusCode != 200) {
        throw Exception('No se pudo consultar el catálogo (${response.statusCode}).');
      }
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final responseData = decoded['response'] as Map<String, dynamic>?;
      final docs = responseData?['docs'] as List<dynamic>? ?? [];
      final found = <MovieData>[];
      for (final item in docs) {
        if (item is! Map<String, dynamic>) continue;
        final identifier = (item['identifier'] ?? '').toString();
        final title = (item['title'] ?? '').toString().trim();
        if (identifier.isEmpty || title.isEmpty) continue;
        var description = item['description'];
        if (description is List) description = description.join(' ');
        description = (description ?? 'Consulta la ficha original para conocer más detalles.').toString();
        description = description.replaceAll(RegExp(r'<[^>]*>'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
        if (description.length > 650) description = '${description.substring(0, 647)}...';
        found.add(MovieData(
          title: title,
          category: 'Cine clásico',
          year: (item['year'] ?? 'Año no disponible').toString(),
          description: description,
          duration: 'Duración no disponible',
          image: 'https://archive.org/services/img/$identifier',
        ));
      }
      if (!mounted) return;
      setState(() {
        archiveMovies = found;
        loading = false;
        if (found.isEmpty) loadError = 'No encontramos títulos en esta colección. Intenta actualizar.';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        loading = false;
        loadError = 'No fue posible cargar las películas. Revisa tu conexión e inténtalo de nuevo.';
      });
    }
  }

  List<MovieData> get filteredMovies {
    final query = searchController.text.toLowerCase().trim();
    return archiveMovies.where((movie) =>
      movie.title.toLowerCase().contains(query) ||
      movie.description.toLowerCase().contains(query) ||
      movie.year.toLowerCase().contains(query)).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredMovies;
    final featured = results.isNotEmpty ? results.first : null;
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: fondo,
        title: const Row(children: [
          Icon(Icons.movie_filter_rounded, color: azul, size: 23),
          SizedBox(width: 9),
          Text('CINE NEXORA', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.6)),
        ]),
        iconTheme: const IconThemeData(color: azul),
        actions: [IconButton(onPressed: loading ? null : loadMovies,
          icon: const Icon(Icons.refresh_rounded, color: azul), tooltip: 'Actualizar catálogo')],
      ),
      body: SafeArea(child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          const Text('PELÍCULAS DEL CATÁLOGO REAL',
            style: TextStyle(fontSize: 22, height: 1.12, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text('Explora películas disponibles en Internet Archive.',
            style: TextStyle(color: Color(0xFF9BAAC8), fontSize: 12)),
          const SizedBox(height: 16),
          TextField(
            controller: searchController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Buscar película...', prefixIcon: const Icon(Icons.search, color: azul),
              suffixIcon: searchController.text.isEmpty ? null : IconButton(
                onPressed: () { searchController.clear(); setState(() {}); },
                icon: const Icon(Icons.close, color: Colors.white60)),
            ),
          ),
          const SizedBox(height: 16),
          const Text('FUENTE: INTERNET ARCHIVE · COLECCIÓN FEATURE FILMS',
            style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: .5)),
          const SizedBox(height: 15),
          if (loading)
            const Padding(padding: EdgeInsets.symmetric(vertical: 65), child: Center(
              child: Column(children: [CircularProgressIndicator(color: azul), SizedBox(height: 14),
                Text('Cargando películas reales...', style: TextStyle(color: Colors.white70))]))),
          if (!loading && loadError != null)
            Padding(padding: const EdgeInsets.symmetric(vertical: 35), child: Column(children: [
              const Icon(Icons.cloud_off_rounded, color: azul, size: 48),
              const SizedBox(height: 12), Text(loadError!, textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 15), ElevatedButton.icon(onPressed: loadMovies,
                icon: const Icon(Icons.refresh), label: const Text('REINTENTAR')),
            ])),
          if (!loading && loadError == null && featured != null) ...[
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => MovieDetailPage(movie: featured))),
              child: Container(height: 210, decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), border: Border.all(color: azul.withOpacity(.4))),
                child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Stack(fit: StackFit.expand, children: [
                  Image.network(featured.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) =>
                    Container(color: panel, child: const Icon(Icons.movie, color: azul, size: 55))),
                  const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xEE050817)]))),
                  Positioned(left: 15, right: 15, bottom: 15, child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('PELÍCULA DESTACADA', style: TextStyle(color: azul,
                        fontSize: 10, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6), Text(featured.title, maxLines: 2,
                        overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
                      Text(featured.year, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    ])),
                ]))),
            ),
            const SizedBox(height: 22),
            Row(children: [const Expanded(child: Text('PELÍCULAS DISPONIBLES',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 12))),
              Text('${results.length} títulos', style: const TextStyle(color: azul, fontSize: 11))]),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 13, mainAxisSpacing: 18, childAspectRatio: .61),
              itemBuilder: (context, index) => MoviePoster(movie: results[index]),
            ),
          ],
          if (!loading && loadError == null && results.isEmpty)
            const Padding(padding: EdgeInsets.symmetric(vertical: 45), child: Text(
              'No hay resultados para esa búsqueda.', textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70))),
          const SizedBox(height: 18),
          const Text('La disponibilidad y los derechos de reproducción dependen de cada película. Este catálogo no garantiza que todos los títulos puedan reproducirse.',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white38, fontSize: 10, height: 1.4)),
        ],
      )),
    );
  }
}

class MoviePoster extends StatelessWidget {
  final MovieData movie;

  const MoviePoster({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailPage(movie: movie),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: azul.withOpacity(0.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      movie.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          color: panel,
                          child: const Icon(
                            Icons.movie_outlined,
                            color: azul,
                            size: 45,
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 85,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              fondo.withOpacity(0.95),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      right: 9,
                      top: 9,
                      child: Icon(
                        Icons.play_circle_fill,
                        color: Colors.white,
                        size: 29,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            '${movie.year} · ${movie.category}',
            style: const TextStyle(color: azul, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// DETALLE DE PELÍCULA

class MovieDetailPage extends StatefulWidget {
  final MovieData movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool saving = false;

  Future<void> toggleFavorite(bool currentlySaved) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicia sesión para guardar favoritos.')),
      );
      return;
    }
    if (saving) return;

    setState(() => saving = true);
    final favoriteRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(widget.movie.title);

    try {
      if (currentlySaved) {
        await favoriteRef.delete();
      } else {
        await favoriteRef.set({
          'title': widget.movie.title,
          'category': widget.movie.category,
          'year': widget.movie.year,
          'description': widget.movie.description,
          'duration': widget.movie.duration,
          'image': widget.movie.image,
          'savedAt': FieldValue.serverTimestamp(),
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              currentlySaved
                  ? 'Eliminada de tu lista.'
                  : 'Agregada a tu lista.',
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo actualizar tu biblioteca.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  void reproducirVideo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerScreen(title: widget.movie.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      backgroundColor: fondo,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 330,
            pinned: true,
            backgroundColor: fondo,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    movie.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        color: panel,
                        child: const Icon(
                          Icons.movie,
                          color: azul,
                          size: 70,
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          fondo.withOpacity(0.4),
                          fondo,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: azul.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: azul.withOpacity(0.6)),
                    ),
                    child: Text(
                      movie.category.toUpperCase(),
                      style: const TextStyle(
                        color: azul,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, color: azul, size: 15),
                      const SizedBox(width: 6),
                      Text(movie.year, style: const TextStyle(color: Colors.white70)),
                      const SizedBox(width: 13),
                      const Icon(
                        Icons.access_time_rounded,
                        color: azul,
                        size: 17,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        movie.duration,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(width: 18),
                      const Icon(Icons.hd_rounded, color: azul, size: 21),
                      const SizedBox(width: 5),
                      const Text(
                        'Información del catálogo',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'SINOPSIS',
                    style: TextStyle(
                      color: azul,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    movie.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.6,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: reproducirVideo,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text(
                        'VIDEO DE PRUEBA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.3,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azul,
                        foregroundColor: fondo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),
                  Builder(
                    builder: (context) {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) {
                        return const SizedBox.shrink();
                      }
                      final favoriteRef = FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('favorites')
                          .doc(movie.title);

                      return StreamBuilder<
                          DocumentSnapshot<Map<String, dynamic>>>(
                        stream: favoriteRef.snapshots(),
                        builder: (context, snapshot) {
                          final saved = snapshot.data?.exists ?? false;
                          final waiting =
                              snapshot.connectionState == ConnectionState.waiting;
                          return SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton.icon(
                              onPressed: saving || waiting
                                  ? null
                                  : () => toggleFavorite(saved),
                              icon: saving || waiting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: azul,
                                      ),
                                    )
                                  : Icon(
                                      saved
                                          ? Icons.bookmark
                                          : Icons.bookmark_add_outlined,
                                    ),
                              label: Text(
                                saved
                                    ? 'AGREGADA A MI LISTA'
                                    : 'AGREGAR A MI LISTA',
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: azul,
                                side: const BorderSide(color: azul),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
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

// REPRODUCTOR

class PlayerScreen extends StatefulWidget {
  final String title;

  const PlayerScreen({super.key, required this.title});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final VideoPlayerController controller;
  bool hasError = false;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
    );
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      await controller.initialize();
      if (!mounted) return;
      setState(() => initialized = true);
      await controller.play();
    } catch (_) {
      if (mounted) setState(() => hasError = true);
    }
  }

  String formatTime(Duration duration) {
    final minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours;
    if (hours > 0) return '$hours:$minutes:$seconds';
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: hasError
              ? const Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: azul,
                        size: 55,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'No se pudo cargar el video.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Comprueba tu conexión a internet e inténtalo nuevamente.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60),
                      ),
                    ],
                  ),
                )
              : !initialized
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: azul),
                        SizedBox(height: 18),
                        Text(
                          'CARGANDO VIDEO...',
                          style: TextStyle(
                            color: Colors.white70,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'VIDEO DE DEMOSTRACIÓN',
                          style: TextStyle(
                            color: azul,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 15),
                        AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: VideoPlayer(controller),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 15, 18, 5),
                          child: VideoProgressIndicator(
                            controller,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: azul,
                              bufferedColor: Colors.white30,
                              backgroundColor: Colors.white12,
                            ),
                          ),
                        ),
                        ValueListenableBuilder<VideoPlayerValue>(
                          valueListenable: controller,
                          builder: (context, value, child) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              child: Row(
                                children: [
                                  Text(
                                    formatTime(value.position),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () async {
                                      if (value.isPlaying) {
                                        await controller.pause();
                                      } else {
                                        if (value.isCompleted) {
                                          await controller.seekTo(
                                            Duration.zero,
                                          );
                                        }
                                        await controller.play();
                                      }
                                    },
                                    icon: Icon(
                                      value.isPlaying
                                          ? Icons.pause_circle_filled
                                          : Icons.play_circle_fill,
                                      color: azul,
                                      size: 55,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    formatTime(value.duration),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            'Este contenido es una prueba técnica del reproductor NEXORA.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

// COMPONENTES GENERALES

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 3,
          height: 37,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [azul, morado]),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1)),
              const SizedBox(height: 5),
              Text(subtitle, style: const TextStyle(color: Color(0xFF8E9BB7), fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}

class MediaCard extends StatelessWidget {
  final MovieData media;

  const MediaCard({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailPage(movie: media),
          ),
        );
      },
      child: SizedBox(
        width: 132,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: azul.withOpacity(0.25)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        media.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            color: panel,
                            child: const Icon(
                              Icons.movie_creation_outlined,
                              color: azul,
                              size: 45,
                            ),
                          );
                        },
                      ),
                      const Positioned(
                        right: 8,
                        top: 8,
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              media.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            ),
            const SizedBox(height: 3),
            Text(
              media.category,
              style: const TextStyle(
                color: Color(0xFF8E9BB7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// EXPLORAR

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      _ExploreOption('Películas', 'Historias para cada momento', Icons.movie_creation_rounded, azul, true),
      _ExploreOption('Series', 'Descubre historias y temporadas', Icons.live_tv_rounded, morado, true, series: true),
      _ExploreOption('Deportes', 'Muy pronto: vive la emoción', Icons.sports_soccer_rounded, const Color(0xFFFFB454), false),
      _ExploreOption('Documentales', 'Muy pronto: descubre el mundo', Icons.public_rounded, const Color(0xFF65D6A5), false),
      _ExploreOption('Música', 'Muy pronto: siente el ritmo', Icons.headphones_rounded, const Color(0xFFFF76B7), false),
      _ExploreOption('Educación', 'Muy pronto: aprende más', Icons.school_rounded, const Color(0xFF9EABFF), false),
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DESCUBRE NEXORA', style: TextStyle(color: azul, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    SizedBox(height: 7),
                    Text('Explorar', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -0.7)),
                  ],
                ),
              ),
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(color: azul.withOpacity(0.10), borderRadius: BorderRadius.circular(15), border: Border.all(color: azul.withOpacity(0.25))),
                child: const Icon(Icons.travel_explore_rounded, color: azul, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Encuentra tu próximo contenido favorito.', style: TextStyle(color: Colors.white60, fontSize: 13)),
          const SizedBox(height: 23),
          Container(
            height: 178,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF17446A), Color(0xFF30205D), Color(0xFF111A30)]),
              border: Border.all(color: azul.withOpacity(0.32)),
              boxShadow: [BoxShadow(color: azul.withOpacity(0.10), blurRadius: 25, offset: const Offset(0, 9))],
            ),
            child: Stack(
              children: [
                const Positioned(right: -8, bottom: -18, child: Icon(Icons.auto_awesome, size: 125, color: Color(0x2239D8FF))),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: azul.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: const Text('TU UNIVERSO DE ENTRETENIMIENTO', style: TextStyle(color: azul, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.7))),
                    const SizedBox(height: 12),
                    const Text('Hay algo nuevo\npor descubrir.', style: TextStyle(fontSize: 23, height: 1.12, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 9),
                    const Text('Explora categorías y encuentra lo que te gusta.', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 27),
          Row(
            children: [
              const Expanded(child: Text('Explora por categoría', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900))),
              Text('${options.length} categorías', style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 13),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: options.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.12),
            itemBuilder: (context, index) => _ExploreTile(option: options[index]),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            decoration: BoxDecoration(color: const Color(0xFF121D32), borderRadius: BorderRadius.circular(17), border: Border.all(color: Colors.white.withOpacity(0.06))),
            child: const Row(
              children: [
                Icon(Icons.rocket_launch_rounded, color: azul, size: 21),
                SizedBox(width: 11),
                Expanded(child: Text('NEXORA está creciendo. Pronto llegarán más experiencias.', style: TextStyle(color: Colors.white60, fontSize: 11, height: 1.4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool available;
  final bool series;

  const _ExploreOption(this.title, this.subtitle, this.icon, this.color, this.available, {this.series = false});
}

class _ExploreTile extends StatelessWidget {
  final _ExploreOption option;

  const _ExploreTile({required this.option});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(21),
      onTap: () {
        if (option.available && option.series) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SeriesPage()));
        } else if (option.available) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MoviesPage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${option.title}: próximamente en NEXORA.')));
        }
      },
      child: Ink(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [option.color.withOpacity(0.15), const Color(0xFF17223A), const Color(0xFF10182B)]),
          border: Border.all(color: option.color.withOpacity(0.30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 43, height: 43, decoration: BoxDecoration(color: option.color.withOpacity(0.16), borderRadius: BorderRadius.circular(14)), child: Icon(option.icon, color: option.color, size: 23)),
                if (option.available)
                  const Icon(Icons.arrow_outward_rounded, color: azul, size: 18)
                else
                  Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.07), borderRadius: BorderRadius.circular(10)), child: const Text('PRONTO', style: TextStyle(color: Colors.white54, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5))),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(option.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                const SizedBox(height: 5),
                Text(option.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54, fontSize: 10, height: 1.25)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// BIBLIOTECA

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  Future<void> _deleteFavorite(
    BuildContext context,
    DocumentReference<Map<String, dynamic>> reference,
  ) async {
    try {
      await reference.delete();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Eliminada de tu biblioteca.')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo eliminar este favorito.')),
        );
      }
    }
  }

  Widget _emptyLibrary() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: azul.withOpacity(0.10),
                border: Border.all(color: azul.withOpacity(0.35)),
              ),
              child: const Icon(Icons.bookmark_add_outlined, color: azul, size: 48),
            ),
            const SizedBox(height: 22),
            const Text(
              'TU COLECCIÓN TE ESPERA',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
            const SizedBox(height: 10),
            const Text(
              'Guarda tus películas favoritas y las encontrarás aquí cuando quieras volver a verlas.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60, height: 1.5, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const SimplePage(
        icon: Icons.bookmark,
        title: 'MI BIBLIOTECA',
        message: 'Inicia sesión para ver tus favoritos.',
      );
    }

    final favoritesStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .orderBy('savedAt', descending: true)
        .snapshots();

    return SafeArea(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: favoritesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: azul));
          }
          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Text(
                  'No se pudo cargar tu biblioteca. Inténtalo nuevamente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            );
          }

          final documents = snapshot.data?.docs ?? [];
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(
                        colors: [azul.withOpacity(0.22), morado.withOpacity(0.16), panel],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: azul.withOpacity(0.24)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: azul.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.bookmarks_rounded, color: azul, size: 29),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'MI BIBLIOTECA',
                                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${documents.length} ${documents.length == 1 ? 'título guardado' : 'títulos guardados'}',
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (documents.isEmpty)
                SliverFillRemaining(hasScrollBody: false, child: _emptyLibrary())
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final document = documents[index];
                        final data = document.data();
                        final movie = MovieData(
                          title: data['title'] as String? ?? document.id,
                          category: data['category'] as String? ?? '',
                          year: data['year'] as String? ?? '',
                          description: data['description'] as String? ?? '',
                          duration: data['duration'] as String? ?? '',
                          image: data['image'] as String? ?? '',
                        );

                        return Container(
                          margin: const EdgeInsets.only(bottom: 13),
                          decoration: BoxDecoration(
                            color: panel,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: azul.withOpacity(0.16)),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(13),
                                    child: SizedBox(
                                      width: 88,
                                      height: 116,
                                      child: movie.image.isEmpty
                                          ? Container(color: fondo, child: const Icon(Icons.movie_rounded, color: azul, size: 35))
                                          : Image.network(
                                              movie.image,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => Container(
                                                color: fondo,
                                                child: const Icon(Icons.movie_rounded, color: azul, size: 35),
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
                                        ),
                                        const SizedBox(height: 9),
                                        if (movie.category.isNotEmpty)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: azul.withOpacity(0.12),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(movie.category, style: const TextStyle(color: azul, fontSize: 10, fontWeight: FontWeight.w700)),
                                          ),
                                        const SizedBox(height: 8),
                                        Text(
                                          movie.duration.isEmpty ? 'Disponible en tu colección' : movie.duration,
                                          style: const TextStyle(color: Colors.white54, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Eliminar de favoritos',
                                    onPressed: () => _deleteFavorite(context, document.reference),
                                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.white60),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: documents.length,
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

// PERFIL

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> cerrarSesion(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: panel,
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que deseas salir de tu cuenta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('CANCELAR', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(backgroundColor: morado, foregroundColor: Colors.white),
            child: const Text('SALIR'),
          ),
        ],
      ),
    );
    if (confirmar == true) await FirebaseAuth.instance.signOut();
  }

  void mostrarInfo(BuildContext context, String titulo, String mensaje, IconData icono) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: panel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: [Icon(icono, color: azul), const SizedBox(width: 10), Expanded(child: Text(titulo))],
        ),
        content: Text(mensaje, style: const TextStyle(color: Colors.white70, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('ENTENDIDO', style: TextStyle(color: azul, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Widget opcionPerfil({
    required BuildContext context,
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required VoidCallback accion,
  }) {
    return InkWell(
      onTap: accion,
      borderRadius: BorderRadius.circular(17),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          color: panel,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: azul.withOpacity(0.10),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icono, color: azul, size: 21),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(subtitulo, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white38),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'Usuario NEXORA';
    final initial = email.isNotEmpty ? email[0].toUpperCase() : 'N';

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
        children: [
          const Text('MI PERFIL', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, letterSpacing: 1.3)),
          const SizedBox(height: 7),
          const Text('Administra tu cuenta y disfruta NEXORA.', style: TextStyle(color: Colors.white60, fontSize: 13)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(23),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF17385D), Color(0xFF271B4B), Color(0xFF111A30)],
              ),
              border: Border.all(color: azul.withOpacity(0.38)),
              boxShadow: [BoxShadow(color: azul.withOpacity(0.12), blurRadius: 26, spreadRadius: 1)],
            ),
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [azul, morado]),
                    border: Border.all(color: Colors.white.withOpacity(0.65), width: 2),
                    boxShadow: [BoxShadow(color: azul.withOpacity(0.30), blurRadius: 24)],
                  ),
                  child: Center(child: Text(initial, style: const TextStyle(color: fondo, fontSize: 36, fontWeight: FontWeight.w900))),
                ),
                const SizedBox(height: 17),
                const Text('BIENVENIDO A NEXORA', style: TextStyle(color: azul, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.6)),
                const SizedBox(height: 9),
                Text(email, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.09), borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded, color: azul, size: 14),
                      SizedBox(width: 6),
                      Text('CUENTA ACTIVA', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.7)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text('TU CUENTA', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.4)),
          const SizedBox(height: 12),
          opcionPerfil(
            context: context,
            icono: Icons.shield_outlined,
            titulo: 'Seguridad y acceso',
            subtitulo: 'Tu sesión está protegida por Firebase',
            accion: () => mostrarInfo(context, 'Seguridad y acceso', 'NEXORA utiliza Firebase Authentication para gestionar el inicio de sesión. Recuerda mantener segura la contraseña de tu cuenta.', Icons.shield_outlined),
          ),
          opcionPerfil(
            context: context,
            icono: Icons.favorite_outline_rounded,
            titulo: 'Tus favoritos',
            subtitulo: 'Guarda y consulta tu contenido preferido',
            accion: () => mostrarInfo(context, 'Tus favoritos', 'Los contenidos que marques como favoritos se guardan en tu Biblioteca vinculada a tu cuenta.', Icons.favorite_outline_rounded),
          ),
          const SizedBox(height: 13),
          const Text('ACERCA DE NEXORA', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.4)),
          const SizedBox(height: 12),
          opcionPerfil(
            context: context,
            icono: Icons.info_outline_rounded,
            titulo: 'Sobre la aplicación',
            subtitulo: 'Conoce un poco más de NEXORA',
            accion: () => mostrarInfo(context, 'NEXORA', 'Tu mundo, tu entretenimiento. Estamos construyendo un espacio para descubrir películas, series, deportes y mucho más. Gracias por acompañarnos.', Icons.auto_awesome_rounded),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 53,
            child: ElevatedButton.icon(
              onPressed: () => cerrarSesion(context),
              icon: const Icon(Icons.logout_rounded, size: 19),
              label: const Text('CERRAR SESIÓN', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.8)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF291A43),
                foregroundColor: Colors.white,
                side: BorderSide(color: morado.withOpacity(0.55)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(height: 23),
          const Center(child: Text('NEXORA  •  TU MUNDO, TU ENTRETENIMIENTO', style: TextStyle(color: Colors.white30, fontSize: 9, letterSpacing: 0.8))),
        ],
      ),
    );
  }
}

// CATEGORÍAS

class CategoryPage extends StatelessWidget {
  final String title;

  const CategoryPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(backgroundColor: fondo, title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Text(
            'Próximamente encontrarás contenido de $title.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ),
      ),
    );
  }
}

class SimplePage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const SimplePage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: azul, size: 65),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryData {
  final String name;
  final IconData icon;

  const CategoryData(this.name, this.icon);
}

// FONDO ESTRELLADO

class StarPainter extends CustomPainter {
  const StarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(12);
    final paint = Paint();

    for (int i = 0; i < 150; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.6 + 0.3;

      paint.color = Colors.white.withOpacity(
        random.nextDouble() * 0.55 + 0.15,
      );

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    final linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.transparent, azul, morado, Colors.transparent],
      ).createShader(Rect.fromLTWH(0, size.height - 5, size.width, 5))
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(15, size.height - 5),
      Offset(size.width - 15, size.height - 5),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
