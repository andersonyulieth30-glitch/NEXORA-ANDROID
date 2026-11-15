import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              Positioned.fill(child: CustomPaint(painter: StarPainter())),
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
                              shadows: [Shadow(color: azul, blurRadius: 18)],
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
                boxShadow: const [BoxShadow(color: azul, blurRadius: 17)],
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
                    children: [RobotEye(), RobotEye()],
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
                boxShadow: const [BoxShadow(color: azul, blurRadius: 12)],
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
                boxShadow: const [BoxShadow(color: morado, blurRadius: 12)],
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
        boxShadow: const [BoxShadow(color: azul, blurRadius: 12)],
      ),
    );
  }
}

// BOTONES Y CATEGORÍAS

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
      body: IndexedStack(index: selected, children: pages),
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

// DATOS DE PELÍCULAS DE DEMOSTRACIÓN

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

// INICIO

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
        padding: const EdgeInsets.fromLTRB(18, 15, 18, 25),
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(colors: [azul, morado]),
                  boxShadow: [
                    BoxShadow(color: azul.withOpacity(0.25), blurRadius: 15),
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
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
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
                        Icon(item.icon, color: azul, size: 29),
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

// CATÁLOGO DE PELÍCULAS

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

// TARJETA DEL CATÁLOGO

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
                boxShadow: [
                  BoxShadow(color: azul.withOpacity(0.08), blurRadius: 12),
                ],
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

// DETALLES DE LA PELÍCULA

class MovieDetailPage extends StatefulWidget {
  final MovieData movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool saved = false;

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
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() => saved = !saved);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              saved
                                  ? 'Agregada a tu lista.'
                                  : 'Eliminada de tu lista.',
                            ),
                          ),
                        );
                      },
                      icon: Icon(
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

// REPRODUCTOR DE VIDEO

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

      setState(() {
        initialized = true;
      });

      await controller.play();
    } catch (_) {
      if (mounted) {
        setState(() {
          hasError = true;
        });
      }
    }
  }

  String formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours;

    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }

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

// TARJETAS DE INICIO

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
          style: const TextStyle(color: Color(0xFF8E9BB7), fontSize: 11),
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'EXPLORAR',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Descubre todo lo que NEXORA tiene para ti.',
              style: TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 25),
            ListTile(
              leading: const Icon(Icons.movie, color: azul),
              title: const Text('Películas'),
              subtitle: const Text('Explora el catálogo'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MoviesPage()),
                );
              },
            ),
            const Divider(color: Colors.white12),
            const ListTile(
              leading: Icon(Icons.live_tv, color: morado),
              title: Text('Series'),
              subtitle: Text('Próximamente'),
            ),
            const Divider(color: Colors.white12),
            const ListTile(
              leading: Icon(Icons.sports_soccer, color: azul),
              title: Text('Deportes'),
              subtitle: Text('Próximamente'),
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
              const Icon(Icons.account_circle, color: azul, size: 65),
              const SizedBox(height: 20),
              const Text(
                'Mi perfil',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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

// CATEGORÍAS PENDIENTES

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
