import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/authentication/presentation/components/my_button.dart';
import 'package:social_app/features/authentication/presentation/components/my_text_field.dart';
import 'package:social_app/features/authentication/presentation/cubits/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.togglePages});
  final void Function()? togglePages;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    final String email = emailController.text;
    final String password = passwordController.text;
    final authCubit = context.read<AuthCubit>();
    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter both email and password',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_open_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Welcome back',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16),
                ),
                const SizedBox(
                  height: 25,
                ),
                MyTextField(
                    hintText: 'Email',
                    obscureText: false,
                    controller: emailController),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    hintText: 'Password',
                    obscureText: true,
                    controller: passwordController),
                const SizedBox(
                  height: 25,
                ),
                MyButton(onTap: login, text: 'Login'),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        ' Register now',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
