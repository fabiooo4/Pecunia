import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pecunia/api/sign_up/signup_repository.dart';
import 'package:pecunia/screens/validation.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;

  Future<void> _createAccount() async {
    final String username = _usernameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {

      await ref.read(signUpRepositoryProvider).signUp(
            email: email,
            password: password,
            username: username,
          );

      if (mounted) {
        context.go('/validation', extra: VerificationPageParams(
          email: email,
          password: password,
          username: username,
          ));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("An email has been sent to $email for verification"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _usernameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                              labelText: 'Username',
                              labelStyle: TextStyle(color: Colors.black),
                              suffixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.person),
                                ),
                              )),
                          controller: _usernameController,
                        ),
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 20),
                        FilledButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                                const Size(double.infinity, 50)),
                          ),
                          onPressed: () => _createAccount(),
                          child: const Text('Signup'),
                        ),
                        const SizedBox(height: 10),
                        const Row(children: [
                          Expanded(child: Divider()),
                        ]),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text.rich(
                            TextSpan(
                              text: 'Already have an account? ',
                              children: [
                                TextSpan(
                                  text: 'Login',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.go('/');
                                    },
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
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
