
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Locale _locale = const Locale('en');
  Map<String, String> _localizedStrings = {};

  @override
  void initState() {
    super.initState();
    _loadLocalizedStrings();
  }

  Future<void> _loadLocalizedStrings() async {
    final jsonString =
        await DefaultAssetBundle.of(context).loadString('lib/l10n/${_locale.languageCode}.json');
    final jsonMap = json.decode(jsonString);
    setState(() {
      _localizedStrings =
          jsonMap.map<String, String>((key, value) => MapEntry(key, value.toString()));
    });
  }

  void _toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
      _loadLocalizedStrings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/controller.png',
              width: 300,
              height: 300,
            )
                .animate(
                  onComplete: (controller) => controller.repeat(),
                )
                .then(
                  duration: 2000.ms,
                )
                .fade(
                  begin: 0.5,
                  end: 1,
                )
                .then(
                  duration: 2000.ms,
                )
                .fade(
                  begin: 1,
                  end: 0.5,
                ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  TextButton(
                    onPressed: _toggleLocale,
                    child: Text(
                      _locale.languageCode == 'en' ? 'AR' : 'EN',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: GlassmorphicContainer(
                    width: 400,
                    height: 500,
                    borderRadius: 20,
                    blur: 20,
                    alignment: Alignment.center,
                    border: 2,
                    linearGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFffffff).withOpacity(0.1),
                        const Color(0xFFFFFFFF).withOpacity(0.05),
                      ],
                      stops: const [
                        0.1,
                        1,
                      ],
                    ),
                    borderGradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFffffff).withOpacity(0.5),
                        const Color(0xFFFFFFFF).withOpacity(0.5),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: _localizedStrings['email'] ?? 'Email',
                              labelStyle: GoogleFonts.roboto(
                                color: Colors.white,
                              ),
                            ),
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: _localizedStrings['password'] ?? 'Password',
                              labelStyle: GoogleFonts.roboto(
                                color: Colors.white,
                              ),
                            ),
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.purple,
                                    Colors.blue,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  _localizedStrings['login'] ?? 'Login',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                _localizedStrings['join_now'] ?? 'Join Now',
                                style: GoogleFonts.roboto(
                                  color: Colors.blue,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SignInButton(
                            Buttons.google,
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
        ],
      ),
    );
  }
}
