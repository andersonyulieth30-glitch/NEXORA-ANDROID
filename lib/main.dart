import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: fondo,
        colorScheme: const ColorScheme.dark(
          primary: azul,
          secondary: morado,
        ),
      ),
      home: const AuthGate(),
    );
  }
}

// PROTECCIÓN DE ACCESO

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
            body: Center(
              child: CircularProgressIndicator(color: azul),
            ),
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

// PORTADA

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

// ROBOT

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
                  colors: [
                    Color(0xFF263E68),
                    Color(0xFF101B39),
                  ],
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

// BOTONES Y CATEGORÍAS DE LA PORTADA

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

// ACCESO CON FIREBASE

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

      if (mounted) {
        Navigator.of(context).pop();
      }
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
              const Icon(Icons.lock_outline, color: azul, size: 55),
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
    ExplorePage(),
    LibraryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: IndexedStack(
        index: selected,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF11182B),
        indicatorColor: azul.withOpacity(0.18),
        selectedIndex: selected,
        onDestinationSelected: (index) {
          setState(() => selected = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: azul),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore, color: azul),
            label: 'Explorar',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark, color: azul),
            label: 'Biblioteca',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: azul),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// NUEVA PANTALLA DE INICIO

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

  static const List<MediaData> movies = [
    MediaData(
      'Universo desconocido',
      'Ciencia ficción',
      'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=700',
    ),
    MediaData(
      'Mundo salvaje',
      'Aventura',
      'https://images.unsplash.com/photo-1511497584788-876760111969?w=700',
    ),
    MediaData(
      'La gran aventura',
      'Acción',
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=700',
    ),
    MediaData(
      'Más allá del espacio',
      'Fantasía',
      'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=700',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 15, 18, 25),
        children: [
          // ENCABEZADO
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [azul, morado],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: azul.withOpacity(0.25),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.change_history_rounded,
                  color: Colors.white,
                  size: 29,
                ),
              ),
              const SizedBox(width: 11),
              const Text(
                'NEXORA',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  shadows: [
                    Shadow(color: azul, blurRadius: 12),
                  ],
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
                onPressed: () {},
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
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
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
            style: TextStyle(
              color: Color(0xFF9BAAC8),
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 25),

          // BANNER DESTACADO
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=1200',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
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
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 37,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CategoryPage(
                                  title: 'Destacados',
                                ),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // PELÍCULAS Y SERIES
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
                final movie = movies[index];
                return MediaCard(media: movie);
              },
            ),
          ),

          const SizedBox(height: 28),

          // CATEGORÍAS
          const SectionHeader(
            title: 'EXPLORA TU UNIVERSO',
            subtitle: 'Todo lo que te gusta en un solo lugar',
          ),
          const SizedBox(height: 15),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryPage(title: item.name),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF192C4B),
                        Color(0xFF211A40),
                      ],
                    ),
                    border: Border.all(
                      color: azul.withOpacity(0.25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: morado.withOpacity(0.08),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          color: azul,
                          size: 29,
                        ),
                        const SizedBox(height: 9),
                        Text(
                          item.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
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
                colors: [
                  azul.withOpacity(0.15),
                  morado.withOpacity(0.15),
                ],
              ),
              border: Border.all(
                color: azul.withOpacity(0.25),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: azul,
                  size: 30,
                ),
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
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
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

// TÍTULOS DE SECCIÓN

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF8E9BB7),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// TARJETAS DE PELÍCULAS

class MediaData {
  final String title;
  final String category;
  final String image;

  const MediaData(this.title, this.category, this.image);
}

class MediaCard extends StatelessWidget {
  final MediaData media;

  const MediaCard({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: azul.withOpacity(0.25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: azul.withOpacity(0.08),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      media.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF1A3760),
                                Color(0xFF39205B),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.movie_creation_outlined,
                            color: azul,
                            size: 45,
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 65,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              fondo.withOpacity(0.9),
                            ],
                          ),
                        ),
                      ),
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
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
    );
  }
}

// EXPLORAR

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      icon: Icons.explore,
      title: 'Explorar',
      message: 'Aquí descubrirás todo el contenido de NEXORA.',
    );
  }
}

// BIBLIOTECA

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      icon: Icons.bookmark,
      title: 'Mi biblioteca',
      message: 'Aquí podrás guardar tus películas y series favoritas.',
    );
  }
}

// PERFIL

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> cerrarSesion(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle,
                color: azul,
                size: 65,
              ),
              const SizedBox(height: 20),
              const Text(
                'Mi perfil',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                FirebaseAuth.instance.currentUser?.email ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => cerrarSesion(context),
                icon: const Icon(Icons.logout),
                label: const Text('CERRAR SESIÓN'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: morado,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// PÁGINAS DE CATEGORÍAS

class CategoryPage extends StatelessWidget {
  final String title;

  const CategoryPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: fondo,
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Text(
            'Próximamente encontrarás contenido de $title.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
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

// DATOS DE CATEGORÍAS

class CategoryData {
  final String name;
  final IconData icon;

  const CategoryData(this.name, this.icon);
}

// FONDO DE ESTRELLAS

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
