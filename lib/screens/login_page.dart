import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;

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
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 7, 46, 8),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(110, 110),
                          bottomRight: Radius.elliptical(100, 100))),
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
                      fontSize: 20,
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
                                icon: Icon(_isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            )),
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () {
                          var email = _emailController.text;
                          var password = _passwordController.text;

                          print('Email: $email');
                          print('Password: $password');
                        },
                        child: Text('Login'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
