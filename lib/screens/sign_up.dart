import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                    height: MediaQuery.of(context).size.height / 2.5,
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
                            radius: 55,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.attach_money_rounded,
                              size: 50,
                              color: Colors.black,
                            ),
                          ),
                        )
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
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.black),
                              suffixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.lock),
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
                          onPressed: () {
                            var username = _usernameController.text;
                            var email = _emailController.text;
                            var password = _passwordController.text;
                          },
                          child: const Text('Signup'),
                        ),
                        const SizedBox(height: 10),
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
                        const Row(children: [
                          Expanded(child: Divider()),
                          Text("  or  ", style: TextStyle(color: Colors.black)),
                          Expanded(child: Divider()),
                        ]),
                        const SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: null,
                              icon: Icon(Icons.apple),
                              iconSize: 40,
                            ),
                            SizedBox(width: 10),
                            // do the same for google
                            IconButton(
                                onPressed: null,
                                icon: Icon(Icons.android),
                                iconSize: 40),
                          ],
                        )
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
