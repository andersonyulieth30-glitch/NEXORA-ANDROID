
import 'package:flutter/material.dart';

void main() {
  runApp(const NexoraApp());
}

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

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF080D20),
              Color(0xFF10102D),
              Color(0xFF080B19),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  const Positioned(
                    top: 35,
                    left: 25,
                    child: Star(),
                  ),
                  const Positioned(
                    top: 100,
                    right: 35,
                    child: Star(),
                  ),
                  const Positioned(
                    top: 250,
                    left: 45,
                    child: Star(),
                  ),
                  const Positioned(
                    top: 370,
                    right: 25,
                    child: Star(),
                  ),
                  SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 18,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(height: 12),

                            // LOGO
                            Column(
                              children: [
                                Container(
                                  width: 86,
                                  height: 86,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF39D8FF),
                                      width: 2,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x8839D8FF),
                                        blurRadius: 28,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'N',
                                      style: TextStyle(
                                        fontSize: 58,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF39D8FF),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'NEXORA',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 7,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'TU MUNDO. TU ENTRETENIMIENTO.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 2,
                                    color: Color(0xFF9C9CDA),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // ROBOT GUÍA
                            const RobotMascot(),

                            const SizedBox(height: 25),

                            // BOTONES
                            Column(
                              children: [
                                WelcomeButton(
                                  text: 'INICIAR SESIÓN',
                                  icon: Icons.login_rounded,
                                  colors: const [
                                    Color(0xFF168DFF),
                                    Color(0xFF514BFF),
                                  ],
                                  onTap: () {
                                    showMessage(context, 'Iniciar sesión');
                                  },
                                ),
                                const SizedBox(height: 15),
                                WelcomeButton(
                                  text: 'CREAR CUENTA',
                                  icon: Icons.person_add_alt_1_rounded,
                                  colors: const [
                                    Color(0xFF8D45FF),
                                    Color(0xFFD13DDB),
                                  ],
                                  onTap: () {
                                    showMessage(context, 'Crear cuenta');
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),

                            // CATEGORÍAS
                            const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                CategoryItem(
                                  icon: Icons.movie_rounded,
                                  label: 'Películas',
                                ),
                                CategoryItem(
                                  icon: Icons.live_tv_rounded,
                                  label: 'Series',
                                ),
                                CategoryItem(
                                  icon: Icons.sports_esports_rounded,
                                  label: 'Juegos',
                                ),
                                CategoryItem(
                                  icon: Icons.auto_awesome_rounded,
                                  label: 'Y mucho más',
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),
                            const Text(
                              'DISFRUTA  •  EXPLORA  •  DESCUBRE',
                              style: TextStyle(
                                fontSize: 9,
                                letterSpacing: 2,
                                color: Color(0xFF777CA8),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class Star extends StatelessWidget {
  const Star({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF8C9EFF),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF514BFF),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}

class RobotMascot extends StatelessWidget {
  const RobotMascot({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 205,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF29236A).withOpacity(0.25),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x554A3BFF),
                  blurRadius: 55,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 130,
                height: 112,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFB8E9FF),
                      Color(0xFF536BBD),
                      Color(0xFF292D69),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: const Color(0xFF64DFFF),
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x8839D8FF),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RobotEye(),
                        SizedBox(width: 25),
                        RobotEye(),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Container(
                      width: 32,
                      height: 7,
                      decoration: BoxDecoration(
                        color: const Color(0xFF39D8FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 75,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF4D54A7),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFF39D8FF),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 15,
            right: 35,
            child: Icon(
              Icons.headphones_rounded,
              size: 42,
              color: Color(0xFFB18AFF),
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
      width: 17,
      height: 23,
      decoration: BoxDecoration(
        color: const Color(0xFF39E7FF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF39D8FF),
            blurRadius: 12,
          ),
        ],
      ),
    );
  }
}

class WelcomeButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  const WelcomeButton({
    super.key,
    required this.text,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 57,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.35),
              blurRadius: 16,
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, color: Colors.white),
          label: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: const Color(0xFF65CFFF),
        ),
        const SizedBox(height: 7),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: Color(0xFFB7B8D5),
          ),
        ),
      ],
    );
  }
}

void showMessage(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$title: próximamente'),
      backgroundColor: const Color(0xFF514BFF),
    ),
  );
}
