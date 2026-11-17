
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

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
          return Stack(
            children: [
              const Positioned.fill(child: CustomPaint(painter: StarPainter())),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.25),
                      radius: 1.25,
                      colors: [
                        const Color(0xFF163B78).withOpacity(0.72),
                        const Color(0xFF17113D).withOpacity(0.72),
                        fondo,
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 36),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const NexoraLogo(size: 39),
                            const SizedBox(width: 10),
                            const Text(
                              'NEXORA',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.8,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.06),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white12),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Configuración próximamente.')),
                                  );
                                },
                                icon: const Icon(Icons.tune_rounded, color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                              decoration: BoxDecoration(
                                color: azul.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: azul.withOpacity(0.35)),
                              ),
                              child: const Text(
                                'TU UNIVERSO DIGITAL',
                                style: TextStyle(
                                  color: azul,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'TU MUNDO.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                height: 1.0,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2.2,
                                shadows: [Shadow(color: azul, blurRadius: 22)],
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'TU ENTRETENIMIENTO.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: azul,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.3,
                              ),
                            ),
                            const SizedBox(height: 9),
                            const Text(
                              'Películas, series y nuevas experiencias\nen un solo lugar.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.45),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const WelcomeMascot(),
                        const SizedBox(height: 12),
                        Column(
                          children: [
                            NeonButton(
                              text: 'Iniciar Sesión',
                              icon: Icons.login_rounded,
                              color: azul,
                              onTap: () => abrirAcceso('Iniciar sesión'),
                            ),
                            const SizedBox(height: 12),
                            NeonButton(
                              text: 'Crear Cuenta',
                              icon: Icons.person_add_alt_1_rounded,
                              color: morado,
                              onTap: () => abrirAcceso('Crear cuenta'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 19),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xCC0B142B),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: azul.withOpacity(0.24)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              WelcomeCategory(icon: Icons.movie_rounded, label: 'Películas'),
                              WelcomeDivider(),
                              WelcomeCategory(icon: Icons.live_tv_rounded, label: 'Series'),
                              WelcomeDivider(),
                              WelcomeCategory(icon: Icons.sports_esports_rounded, label: 'Juegos'),
                              WelcomeDivider(),
                              WelcomeCategory(icon: Icons.auto_awesome_rounded, label: 'Más'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 17),
                        const Text(
                          'DISFRUTA  ·  EXPLORA  ·  DESCUBRE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: azul,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.1,
                          ),
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
      width: 20,
      height: 49,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: color, blurRadius: 13)],
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
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: fondo,
        title: const Text('NEXORA'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 35),
              const NexoraLogo(size: 75),
              const SizedBox(height: 20),
              Text(
                widget.tipo,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Escribe tu correo electrónico.';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                      .hasMatch(value.trim())) {
                    return 'Escribe un correo válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: passwordController,
                obscureText: ocultarPassword,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => ocultarPassword = !ocultarPassword);
                    },
                    icon: Icon(
                      ocultarPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Escribe tu contraseña.';
                  }
                  if (esRegistro && value.length < 6) {
                    return 'Usa al menos 6 caracteres.';
                  }
                  return null;
                },
              ),
              if (!esRegistro)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: recuperarPassword,
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(color: azul),
                    ),
                  ),
                ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: cargando ? null : continuar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azul,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: cargando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          esRegistro ? 'CREAR CUENTA' : 'INICIAR SESIÓN',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: cambiarTipo,
                child: Text(
                  esRegistro
                      ? '¿Ya tienes cuenta? Inicia sesión'
                      : '¿No tienes cuenta? Regístrate',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: azul),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Tu cuenta estará protegida mediante Firebase.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60),
              ),
            ],
          ),
        ),
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (index) {
          setState(() => selected = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie_rounded),
            label: 'Películas',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_rounded),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: 'Biblioteca',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
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
  final String description;
  final String duration;
  final String image;

  const MovieData({
    required this.title,
    required this.category,
    required this.description,
    required this.duration,
    required this.image,
  });
}

const List<MovieData> movies = [
  MovieData(
    title: 'Universo desconocido',
    category: 'Ciencia ficción',
    description:
        'Una expedición se adentra en los misterios del universo para descubrir mundos y secretos que cambiarán su destino.',
    duration: '1 h 48 min',
    image:
        'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=900',
  ),
  MovieData(
    title: 'Mundo salvaje',
    category: 'Aventura',
    description:
        'Un viaje por paisajes extraordinarios donde la naturaleza revela toda su fuerza y belleza.',
    duration: '1 h 35 min',
    image:
        'https://images.unsplash.com/photo-1511497584788-876760111969?w=900',
  ),
  MovieData(
    title: 'La gran aventura',
    category: 'Acción',
    description:
        'Una aventura llena de desafíos, descubrimientos y decisiones que pondrán a prueba a sus protagonistas.',
    duration: '2 h 05 min',
    image:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=900',
  ),
  MovieData(
    title: 'Más allá del espacio',
    category: 'Fantasía',
    description:
        'Una travesía imaginaria hacia lugares sorprendentes más allá de las estrellas.',
    duration: '1 h 52 min',
    image:
        'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=900',
  ),
  MovieData(
    title: 'Horizonte azul',
    category: 'Drama',
    description:
        'Una historia sobre nuevos comienzos, esperanza y la fuerza para seguir adelante.',
    duration: '1 h 41 min',
    image:
        'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?w=900',
  ),
  MovieData(
    title: 'Noche estelar',
    category: 'Ciencia ficción',
    description:
        'Un misterio en el espacio lleva a un grupo de exploradores a enfrentar lo desconocido.',
    duration: '1 h 56 min',
    image:
        'https://images.unsplash.com/photo-1500534623283-312aade485b7?w=900',
  ),
  MovieData(
    title: 'El planeta azul',
    category: 'Documental',
    description:
        'Un recorrido visual por algunos de los paisajes más fascinantes de nuestro planeta.',
    duration: '1 h 20 min',
    image:
        'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=900',
  ),
  MovieData(
    title: 'Camino a la cima',
    category: 'Aventura',
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

// INICIO DESPUÉS DE AUTENTICARSE

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 17, 18, 30),
        children: [
          Row(
            children: [
              const NexoraLogo(size: 43),
              const SizedBox(width: 9),
              const Text(
                'NEXORA',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.6,
                  shadows: [Shadow(color: azul, blurRadius: 12)],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: azul,
                  size: 27,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  );
                },
                icon: const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white70,
                  size: 27,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            'TU MUNDO.',
            style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900, letterSpacing: 0.4),
          ),
          const Text(
            'TU ENTRETENIMIENTO.',
            style: TextStyle(
              fontSize: 19,
              color: azul,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Descubre un universo hecho para ti.',
            style: TextStyle(color: Color(0xFF9BAAC8), fontSize: 13),
          ),
          const SizedBox(height: 25),
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: azul.withOpacity(0.32)),
                boxShadow: [
                  BoxShadow(color: azul.withOpacity(0.10), blurRadius: 24, spreadRadius: 1),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
              children: [
                SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=1200',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF172D59),
                              Color(0xFF311B55),
                              Color(0xFF080D1B),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.auto_awesome,
                            color: azul,
                            size: 65,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        fondo.withOpacity(0.95),
                        fondo.withOpacity(0.55),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  right: 15,
                  bottom: 18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: azul.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: azul),
                        ),
                        child: const Text(
                          'NEXORA DESTACADOS',
                          style: TextStyle(
                            color: azul,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'EXPLORA LO EXTRAORDINARIO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Tu próxima historia comienza aquí.',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 37,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MoviesPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_arrow_rounded, size: 20),
                          label: const Text(
                            'DESCUBRIR',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: azul,
                            foregroundColor: fondo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: 'PELÍCULAS Y SERIES',
            subtitle: 'Historias para cada momento',
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 205,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              separatorBuilder: (_, __) => const SizedBox(width: 13),
              itemBuilder: (context, index) {
                return MediaCard(media: movies[index]);
              },
            ),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: 'EXPLORA TU UNIVERSO',
            subtitle: 'Todo lo que te gusta en un solo lugar',
          ),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.55,
            ),
            itemBuilder: (context, index) {
              final item = categories[index];
              return InkWell(
                borderRadius: BorderRadius.circular(17),
                onTap: () {
                  if (item.name == 'Películas') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MoviesPage(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryPage(title: item.name),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF192C4B), Color(0xFF211A40)],
                    ),
                    border: Border.all(color: azul.withOpacity(0.25)),
                  ),
                  padding: const EdgeInsets.all(13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, color: azul, size: 29),
                      const SizedBox(height: 9),
                      Text(
                        item.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [azul.withOpacity(0.15), morado.withOpacity(0.15)],
              ),
              border: Border.all(color: azul.withOpacity(0.25)),
            ),
            child: const Row(
              children: [
                Icon(Icons.auto_awesome, color: azul, size: 30),
                SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EL UNIVERSO NEXORA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Disfruta, explora y descubre nuevas experiencias.',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
  String selectedGenre = 'Todas';

  List<MovieData> get filteredMovies {
    return movies.where((movie) {
      final matchesGenre =
          selectedGenre == 'Todas' || movie.category == selectedGenre;
      final query = searchController.text.toLowerCase().trim();
      final matchesSearch =
          movie.title.toLowerCase().contains(query) ||
          movie.category.toLowerCase().contains(query);
      return matchesGenre && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredMovies;

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: fondo,
        title: const Text(
          'PELÍCULAS',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        iconTheme: const IconThemeData(color: azul),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 25),
          children: [
            const Text(
              'TU PRÓXIMA HISTORIA',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            const Text(
              'Encuentra algo que te encante.',
              style: TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Buscar películas o géneros...',
                prefixIcon: const Icon(Icons.search, color: azul),
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.close),
                ),
                filled: true,
                fillColor: panel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'EXPLORAR POR GÉNERO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: movieGenres.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final genre = movieGenres[index];
                  final active = selectedGenre == genre;
                  return ChoiceChip(
                    label: Text(genre),
                    selected: active,
                    onSelected: (_) {
                      setState(() => selectedGenre = genre);
                    },
                    selectedColor: azul,
                    backgroundColor: panel,
                    labelStyle: TextStyle(
                      color: active ? fondo : Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                    side: BorderSide(
                      color: active ? azul : Colors.white12,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'CATÁLOGO NEXORA',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Text(
                  '${results.length} títulos',
                  style: const TextStyle(color: azul, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 15),
            if (results.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 55),
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded, color: azul, size: 55),
                    SizedBox(height: 12),
                    Text(
                      'No encontramos películas.',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Prueba con otro nombre o género.',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: results.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 13,
                  mainAxisSpacing: 18,
                  childAspectRatio: 0.61,
                ),
                itemBuilder: (context, index) {
                  return MoviePoster(movie: results[index]);
                },
              ),
            const SizedBox(height: 20),
            const Text(
              'Los títulos e imágenes actuales son demostrativos.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 10),
            ),
          ],
        ),
      ),
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
            movie.category,
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
        builder: (_) => PlayerScreen(movie: widget.movie),
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
                        'Ficha de demostración',
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
                        'REPRODUCIR',
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
  final MovieData movie;

  const PlayerScreen({super.key, required this.movie});

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
          widget.movie.title,
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
      _ExploreOption('Películas', 'Descubre el catálogo', Icons.movie_rounded, azul, true),
      _ExploreOption('Series', 'Nuevas historias', Icons.live_tv_rounded, morado, false),
      _ExploreOption('Deportes', 'Acción y emoción', Icons.sports_soccer_rounded, const Color(0xFFFFB454), false),
      _ExploreOption('Documentales', 'Conoce el mundo', Icons.public_rounded, const Color(0xFF65D6A5), false),
      _ExploreOption('Música', 'Ritmo para cada momento', Icons.headphones_rounded, const Color(0xFFFF76B7), false),
      _ExploreOption('Educación', 'Aprende algo nuevo', Icons.school_rounded, const Color(0xFF9EABFF), false),
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
        children: [
          const Text(
            'EXPLORA',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1.4),
          ),
          const SizedBox(height: 7),
          const Text(
            'Un universo de experiencias te espera.',
            style: TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF17365A), Color(0xFF251A49), Color(0xFF111A30)],
              ),
              border: Border.all(color: azul.withOpacity(0.30)),
            ),
            child: const Row(
              children: [
                Icon(Icons.travel_explore_rounded, color: azul, size: 38),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TU SIGUIENTE DESCUBRIMIENTO', style: TextStyle(fontSize: 11, color: azul, fontWeight: FontWeight.w900, letterSpacing: 0.8)),
                      SizedBox(height: 6),
                      Text('Encuentra algo que te sorprenda.', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text('CATEGORÍAS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
          const SizedBox(height: 13),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: options.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.32,
            ),
            itemBuilder: (context, index) {
              final option = options[index];
              return _ExploreTile(option: option);
            },
          ),
          const SizedBox(height: 18),
          const Text(
            'NEXORA reúne tus experiencias favoritas en un solo lugar.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 11, height: 1.5),
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

  const _ExploreOption(this.title, this.subtitle, this.icon, this.color, this.available);
}

class _ExploreTile extends StatelessWidget {
  final _ExploreOption option;

  const _ExploreTile({required this.option});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(19),
      onTap: () {
        if (option.available) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MoviesPage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${option.title}: próximamente en NEXORA.')),
          );
        }
      },
      child: Ink(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF182641), Color(0xFF10182B)],
          ),
          border: Border.all(color: option.color.withOpacity(0.28)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: option.color.withOpacity(0.13), borderRadius: BorderRadius.circular(13)),
              child: Icon(option.icon, color: option.color, size: 23),
            ),
            const SizedBox(height: 12),
            Text(option.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(option.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54, fontSize: 10, height: 1.25)),
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
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo eliminar este favorito.'),
          ),
        );
      }
    }
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
            return const Center(
              child: CircularProgressIndicator(color: azul),
            );
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
          if (documents.isEmpty) {
            return const SimplePage(
              icon: Icons.bookmark_border,
              title: 'MI BIBLIOTECA',
              message:
                  'Todavía no tienes favoritos. Guarda una película para verla aquí.',
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MI BIBLIOTECA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        '${documents.length} elemento${documents.length == 1 ? '' : 's'} guardado${documents.length == 1 ? '' : 's'}',
                        style: const TextStyle(color: Colors.white60),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final document = documents[index];
                      final data = document.data();
                      final movie = MovieData(
                        title: data['title'] as String? ?? document.id,
                        category: data['category'] as String? ?? '',
                        description: data['description'] as String? ?? '',
                        duration: data['duration'] as String? ?? '',
                        image: data['image'] as String? ?? '',
                      );

                      return Container(
                        margin: const EdgeInsets.only(bottom: 13),
                        decoration: BoxDecoration(
                          color: panel,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: azul.withOpacity(0.18),
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MovieDetailPage(movie: movie),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(11),
                                  child: SizedBox(
                                    width: 88,
                                    height: 112,
                                    child: movie.image.isEmpty
                                        ? Container(
                                            color: fondo,
                                            child: const Icon(
                                              Icons.movie,
                                              color: azul,
                                              size: 35,
                                            ),
                                          )
                                        : Image.network(
                                            movie.image,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) {
                                              return Container(
                                                color: fondo,
                                                child: const Icon(
                                                  Icons.movie,
                                                  color: azul,
                                                  size: 35,
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 13),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Text(
                                        movie.category,
                                        style: const TextStyle(
                                          color: azul,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Text(
                                        movie.duration,
                                        style: const TextStyle(
                                          color: Colors.white60,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Eliminar de favoritos',
                                  onPressed: () =>
                                      _deleteFavorite(context, document.reference),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.white70,
                                  ),
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
          const Text('Tu espacio personal en NEXORA.', style: TextStyle(color: Colors.white60, fontSize: 13)),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF17385D), Color(0xFF271B4B), Color(0xFF111A30)],
              ),
              border: Border.all(color: azul.withOpacity(0.35)),
              boxShadow: [BoxShadow(color: azul.withOpacity(0.10), blurRadius: 25, spreadRadius: 1)],
            ),
            child: Column(
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [azul, morado]),
                    boxShadow: [BoxShadow(color: azul.withOpacity(0.28), blurRadius: 22)],
                  ),
                  child: Center(child: Text(initial, style: const TextStyle(color: fondo, fontSize: 34, fontWeight: FontWeight.w900))),
                ),
                const SizedBox(height: 16),
                const Text('MI CUENTA NEXORA', style: TextStyle(color: azul, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                Text(email, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 7),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(20)),
                  child: const Text('Cuenta protegida con Firebase', style: TextStyle(color: Colors.white70, fontSize: 10)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.07))),
            child: const Row(
              children: [
                Icon(Icons.verified_user_outlined, color: azul, size: 25),
                SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tu cuenta está activa', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                      SizedBox(height: 4),
                      Text('Tus favoritos se sincronizan con tu biblioteca.', style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.35)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 52,
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
          const SizedBox(height: 22),
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
