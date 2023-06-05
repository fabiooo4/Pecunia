import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pecunia/api/sign_up/signup_repository.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationPageParams {
  const VerificationPageParams({this.email, this.password, this.username});

  final email;
  final password;
  final username;
}

class Validation extends ConsumerStatefulWidget {
  const Validation({required this.params, super.key});

  final VerificationPageParams params;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ValidationState();
}

class _ValidationState extends ConsumerState<Validation> {
  final TextEditingController codeController = TextEditingController();

  void _controlCode() async {
    try {
      ref
          .read(signUpRepositoryProvider)
          .VerifyCode(email: widget.params.email, code: codeController.text);
      if (mounted) {
        context.go('/');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account verified"),
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
  Widget build(BuildContext context) {
    StreamController<ErrorAnimationType> errorController =
        StreamController<ErrorAnimationType>();
    TextEditingController textEditingController = TextEditingController();
    // ignore: unused_local_variable
    String currentText = "";
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.email, size: 32, color: Colors.green),
          const Text("VERIFY YOU EMAIL ADDRESS",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          const Divider(
            color: Colors.black,
            thickness: 1,
            height: 40,
            indent: 20,
            endIndent: 20,
          ),
          const Text("A verification code has been sent to"),
          //insert code field and submit button
          Text(
            widget.params.email,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: const Text(
                  "Please check your inbox and enter the verification code below to verify your email address. The code will expire in 15 minutes")),
          Container(
            width: 300,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                selectedColor: Colors.green,
                selectedFillColor: Colors.white,
                inactiveColor: Colors.grey,
                inactiveFillColor: Colors.white,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
              ),
              animationDuration: Duration(milliseconds: 300),
              backgroundColor: const Color.fromARGB(0, 227, 242, 253),
              enableActiveFill: true,
              errorAnimationController: errorController,
              controller: textEditingController,
              onCompleted: (v) {
                print("Completed");
              },
              onChanged: (value) {
                print(value);
                setState(() {
                  currentText = value;
                });
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
            ),
          ),
          ElevatedButton(
              onPressed: () => _controlCode(), child: const Text("Submit")),
        ],
      ),
    );
  }
}
