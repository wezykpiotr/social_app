import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/authentication/presentation/components/my_button.dart';
import 'package:social_app/features/authentication/presentation/components/my_text_field.dart';
import 'package:social_app/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:social_app/responsive/constrained_scaffold.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
    required this.togglePage,
  });
  final void Function()? togglePage;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void register() {
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    final authCubit = context.read<AuthCubit>();
    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        authCubit.register(name, email, password);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Passwords do not match',
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please complete all fields',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
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
                  'Let\'s create an accoun for you',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16),
                ),
                const SizedBox(
                  height: 25,
                ),
                MyTextField(
                    hintText: 'Name',
                    obscureText: false,
                    controller: nameController),
                const SizedBox(
                  height: 10,
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
                  height: 10,
                ),
                MyTextField(
                    hintText: 'Confirm password',
                    obscureText: true,
                    controller: confirmPasswordController),
                const SizedBox(
                  height: 25,
                ),
                MyButton(onTap: register, text: 'Register'),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: widget.togglePage,
                      child: Text(
                        ' Login now',
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
