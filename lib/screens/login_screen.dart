
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;
  bool _isArabic = false;

  // Simple i18n solution
  Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      'login': 'Login',
      'email': 'Email',
      'password': 'Password',
      'join_now': 'Join Now',
      'language_toggle': 'AR',
    },
    'ar': {
      'login': 'تسجيل الدخول',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'join_now': 'انضم الآن',
      'language_toggle': 'EN',
    }
  };

  String _getLocalizedString(String key) {
    return _localizedStrings[_isArabic ? 'ar' : 'en']![key]!;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 5.0, end: 20.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleLanguage() {
    setState(() {
      _isArabic = !_isArabic;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = _isArabic ? TextDirection.rtl : TextDirection.ltr;
    final fontFamily = _isArabic ? GoogleFonts.cairo().fontFamily : GoogleFonts.roboto().fontFamily;

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        body: Stack(
          children: [
            // Dynamic Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF000020), Color(0xFF000030)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.5),
                          blurRadius: _glowAnimation.value * 2,
                          spreadRadius: _glowAnimation.value,
                        ),
                         BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          blurRadius: _glowAnimation.value * 2,
                          spreadRadius: _glowAnimation.value,
                        ),
                      ],
                    ),
                    child: child,
                  );
                },
                child: const Icon(
                  Icons.gamepad,
                  color: Color.fromARGB(255, 23, 23, 53),
                  size: 200,
                ),
              ),
            ),

            // Glassmorphic Login Form
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Darsh Store',
                              style: TextStyle(
                                fontFamily: GoogleFonts.orbitron().fontFamily,
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(_getLocalizedString('email'), Icons.email, textDirection, fontFamily!),
                            const SizedBox(height: 15),
                            _buildTextField(_getLocalizedString('password'), Icons.lock, textDirection, fontFamily, isObscure: true),
                            const SizedBox(height: 25),
                            _buildLoginButton(fontFamily!),
                            const SizedBox(height: 15),
                            _buildJoinNowButton(fontFamily!),
                            const SizedBox(height: 20),
                            SignInButton(
                              Buttons.google,
                              text: "Sign up with Google",
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Language Toggle Button
            Positioned(
              top: 40,
              right: _isArabic ? null : 20,
              left: _isArabic ? 20 : null,
              child: TextButton(
                onPressed: _toggleLanguage,
                child: Text(
                  _getLocalizedString('language_toggle'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: fontFamily,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextDirection textDirection, String fontFamily, {bool isObscure = false}) {
    return TextField(
      obscureText: isObscure,
      style: TextStyle(color: Colors.white, fontFamily: fontFamily),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70, fontFamily: fontFamily),
        prefixIcon: Icon(icon, color: Colors.purpleAccent),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.purpleAccent),
        ),
      ),
      textAlign: textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left,
    );
  }

  Widget _buildLoginButton(String fontFamily) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.blue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          _getLocalizedString('login'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildJoinNowButton(String fontFamily) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.blueAccent),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          _getLocalizedString('join_now'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
