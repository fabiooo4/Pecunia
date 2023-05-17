import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pecunia/widgets/provider_tile.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;

  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      
    });

    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final authServiceProvider = ref.watch(authService);

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            top: false,
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 7, 46, 8),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(100, 80),
                            bottomRight: Radius.elliptical(100, 80))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Transform(
                            transform: Matrix4.translationValues(0, 50, 0),
                            child: const CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white,
                              child: ImageIcon(
                                AssetImage('assets/images/logopng.png'),
                                size: 100,
                                color: Color.fromARGB(255, 7, 46, 8),
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Pecunia',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreen),
                  ),
                  const Text(
                    'Handle them coins, dawg!',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.black),
                              suffixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.email),
                                ),
                              )),
                          controller: _emailController,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.black),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                  icon: Icon(
                                    _isObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                              )),
                          controller: _passwordController,
                        ),
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.all(0)),
                                      overlayColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.transparent)),
                                  onPressed: () async {
                                    await supabase.auth.signOut();
                                  },
                                  child: const Text('Forgot Password?',
                                      style: TextStyle(
                                          color: Colors.lightGreen,
                                          fontWeight: FontWeight.bold))),
                            ]),
                        FilledButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                                const Size(double.infinity, 50)),
                          ),
                          onPressed: () async {
                            // await authServiceProvider.signIn(
                            //     _emailController.text,
                            //     _passwordController.text);

                            Object? response = await signIn(
                                _emailController.text,
                                _passwordController.text);

                            if (response is Error || response == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(response is Error
                                    ? 'Invalid email or password'
                                    : 'Please fill in all fields'),
                              ));
                            } else {
                              context.go('/home');
                            }
                          },
                          child: const Text('Login'),
                        ),
                        const SizedBox(height: 10),
                        Row(children: const [
                          Expanded(child: Divider()),
                          Text("  or  ", style: TextStyle(color: Colors.black)),
                          Expanded(child: Divider()),
                        ]),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            ProviderTile(path: 'assets/images/google.png'),
                            SizedBox(width: 15),
                            ProviderTile(path: 'assets/images/apple.png'),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text.rich(
                            TextSpan(
                              text: 'Don\'t have an account? ',
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.go('/signup');
                                    },
                                  text: 'Sign Up',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
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
        ));
  }
}

Future<Object?> signIn(String email, String password) async {
  if (email.isEmpty || password.isEmpty) {
    return null;
  }

  try {
    Object response = await supabase.auth
        .signInWithPassword(email: email, password: password);
    return response;
  } on AuthException {
    return Error();
  }
}
