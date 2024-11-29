import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/authentication/data/auth_repository.dart';
import 'package:social_app/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:social_app/features/authentication/presentation/cubits/auth_states.dart';
import 'package:social_app/features/authentication/presentation/pages/auth_page.dart';
import 'package:social_app/features/post/presentation/pages/home_page.dart';
import 'package:social_app/themes/light_mode.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final firebaseAuthRepository = FirebaseAuthRepository();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        firebaseAuthRepository: firebaseAuthRepository,
      )..checkAuth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            if (authState is Unauthenticated) {
              return const AuthPage();
            } else if (authState is Authenticated) {
              return const HomePage();
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
