import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hawa_mobile/screens/main_screen.dart';
import 'package:hawa_mobile/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'operator@hawa.eco.id');
  final _passwordController = TextEditingController(text: '••••••••');

  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    HapticFeedback.mediumImpact();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate authentication delay for smooth UX
    await Future.delayed(const Duration(milliseconds: 750));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _fillDemoCredentials() {
    HapticFeedback.selectionClick();
    setState(() {
      _emailController.text = 'operator@hawa.eco.id';
      _passwordController.text = 'hawa2026';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Akun demo otomatis terisi',
          style: AppTheme.font(fontSize: 13, color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8F5EE), // Soft mint hijau
              Color(0xFFF7FAF8), // Off-white sejuk
              Color(0xFFEDF7F2), // Light sage
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Top Brand Icon (Air / Breeze Flow) ────────────────
                      const Center(
                        child: _HawaAirLogo(size: 82),
                      ),
                      const SizedBox(height: 20),

                      // ── App Title & Greeting ───────────────────────────────
                      Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'HAWA',
                                  style: AppTheme.font(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.primaryDark,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentGreen,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'IoT',
                                    style: AppTheme.font(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primaryDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Air Quality & Environmental Monitoring',
                              style: AppTheme.font(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Form Glass Card ────────────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.95),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryDark.withValues(alpha: 0.06),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Masuk ke Akun',
                              style: AppTheme.font(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Gunakan akun operator atau pengawas zona',
                              style: AppTheme.font(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Email Field Label
                            Text(
                              'Email atau ID Petugas',
                              style: AppTheme.font(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: AppTheme.font(fontSize: 14, color: AppTheme.textPrimary),
                              decoration: InputDecoration(
                                hintText: 'nama@hawa.eco.id',
                                hintStyle: AppTheme.font(fontSize: 13, color: AppTheme.textMuted),
                                prefixIcon: const Icon(
                                  Icons.alternate_email_rounded,
                                  color: AppTheme.textSecondary,
                                  size: 20,
                                ),
                                filled: true,
                                fillColor: AppTheme.surfaceContainerLow,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0x150D3326)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: AppTheme.primaryDark, width: 1.5),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password Field Label
                            Text(
                              'Kata Sandi',
                              style: AppTheme.font(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: AppTheme.font(fontSize: 14, color: AppTheme.textPrimary),
                              decoration: InputDecoration(
                                hintText: 'Masukkan kata sandi',
                                hintStyle: AppTheme.font(fontSize: 13, color: AppTheme.textMuted),
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  color: AppTheme.textSecondary,
                                  size: 20,
                                ),
                                suffixIcon: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                                    child: Icon(
                                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                      color: AppTheme.textSecondary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                filled: true,
                                fillColor: AppTheme.surfaceContainerLow,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0x150D3326)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: AppTheme.primaryDark, width: 1.5),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Kata sandi tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            // Remember Me & Forgot Password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: Checkbox(
                                        value: _rememberMe,
                                        activeColor: AppTheme.primaryDark,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        onChanged: (val) => setState(() => _rememberMe = val ?? true),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Ingat saya',
                                      style: AppTheme.font(fontSize: 12, color: AppTheme.textSecondary),
                                    ),
                                  ],
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Hubungi admin TPS3R untuk reset password',
                                            style: AppTheme.font(fontSize: 13, color: Colors.white),
                                          ),
                                          backgroundColor: AppTheme.primaryDark,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Lupa sandi?',
                                      style: AppTheme.font(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.primaryDark,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // ── Submit Button ──────────────────────────────
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: _isLoading ? null : _handleLogin,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryDark,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primaryDark.withValues(alpha: 0.28),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Masuk ke Dashboard',
                                                style: AppTheme.font(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(
                                                Icons.arrow_forward_rounded,
                                                color: AppTheme.accentGreen,
                                                size: 18,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Quick Demo Pill ────────────────────────────────────
                      Center(
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: _fillDemoCredentials,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.mintContainer,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppTheme.accentGreen.withValues(alpha: 0.4),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.bolt_rounded,
                                    color: AppTheme.primaryDark,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Isi Akun Demo Otomatis',
                                    style: AppTheme.font(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Security Footer ────────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            size: 14,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'HAWA Smart Telemetry · Enkripsi IoT Aktif',
                            style: AppTheme.font(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HawaAirLogo extends StatelessWidget {
  final double size;

  const _HawaAirLogo({this.size = 82});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryDark.withValues(alpha: 0.14),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppTheme.accentGreen.withValues(alpha: 0.25),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF07241A), // Deep atmospheric dark
              Color(0xFF0D3326), // Signature HAWA green
              Color(0xFF1B553F), // Fresh breeze emerald
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: ClipOval(
          child: CustomPaint(
            size: Size(size, size),
            painter: _HawaAirLogoPainter(),
          ),
        ),
      ),
    );
  }
}

class _HawaAirLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Paint for main white wind stream
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.4
      ..strokeCap = StrokeCap.round;

    // Paint for fresh lime accent wind stream (symbolizing clean active air flow)
    final limePaint = Paint()
      ..color = const Color(0xFFB5E873)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.6
      ..strokeCap = StrokeCap.round;

    // Paint for secondary soft breeze stream
    final softPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round;

    // ── Stream 1 (Top Wind Wave: sweeps right, curls upward gracefully) ──
    final path1 = Path();
    path1.moveTo(w * 0.22, h * 0.36);
    path1.lineTo(w * 0.58, h * 0.36);
    path1.cubicTo(
      w * 0.68, h * 0.36,
      w * 0.72, h * 0.22,
      w * 0.62, h * 0.22,
    );
    path1.cubicTo(
      w * 0.54, h * 0.22,
      w * 0.54, h * 0.29,
      w * 0.60, h * 0.29,
    );
    canvas.drawPath(path1, whitePaint);

    // ── Stream 2 (Middle Main Airflow: dynamic, energetic, in lime green) ──
    final path2 = Path();
    path2.moveTo(w * 0.16, h * 0.51);
    path2.lineTo(w * 0.68, h * 0.51);
    path2.cubicTo(
      w * 0.80, h * 0.51,
      w * 0.82, h * 0.67,
      w * 0.70, h * 0.67,
    );
    path2.cubicTo(
      w * 0.60, h * 0.67,
      w * 0.60, h * 0.59,
      w * 0.68, h * 0.59,
    );
    canvas.drawPath(path2, limePaint);

    // ── Stream 3 (Bottom Ambient Breeze) ──
    final path3 = Path();
    path3.moveTo(w * 0.26, h * 0.67);
    path3.lineTo(w * 0.48, h * 0.67);
    canvas.drawPath(path3, softPaint);

    // ── Atmospheric Particles / Pure Air Droplets ──
    final dotPaint = Paint()..style = PaintingStyle.fill;

    // Particle 1 (Lime green pure air droplet)
    dotPaint.color = const Color(0xFFB5E873);
    canvas.drawCircle(Offset(w * 0.78, h * 0.36), 3.2, dotPaint);

    // Particle 2 (Pure white droplet)
    dotPaint.color = Colors.white;
    canvas.drawCircle(Offset(w * 0.84, h * 0.51), 2.4, dotPaint);

    // Particle 3 (Soft mint aura droplet)
    dotPaint.color = const Color(0xFFE2F4E6).withValues(alpha: 0.9);
    canvas.drawCircle(Offset(w * 0.57, h * 0.78), 2.2, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

