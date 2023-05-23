import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pecunia/api/sign_up/signup_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
        context.go('/login');
        
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
    return Scaffold(
      appBar: AppBar(title: const Text("Verification")),
      body: Center(
        child: Column(
        children: [
          Text("Insert code sent to ${widget.params.email}"),
          //insert code field and submit button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: codeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                labelText: 'Insert code',
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () => _controlCode(), child: const Text("Submit")),
        ],
      )),
    );
  }
}
