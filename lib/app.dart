import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:social_app/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:social_app/features/authentication/presentation/cubits/auth_states.dart';
import 'package:social_app/features/authentication/presentation/pages/auth_page.dart';
import 'package:social_app/features/home/presentation/pages/home_page.dart';
import 'package:social_app/features/post/data/repository/firebase_post_repository.dart';
import 'package:social_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_app/features/profile/data/repository/firebase_profile_repository.dart';
import 'package:social_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:social_app/features/search/data/firebase_search_repository.dart';
import 'package:social_app/features/search/presentation/cubits/search_cubit.dart';
import 'package:social_app/features/storage/data/firebase_storage_repository.dart';
import 'package:social_app/themes/light_mode.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final firebaseAuthRepository = FirebaseAuthRepository();
  final firebaseProfileRepository = FirebaseProfileRepository();
  final firebaseStorageRepository = FirebaseStorageRepository();
  final firebasePostRepository = FirebasePostRepository();
  final firebaseSearchRepository = FirebaseSearchRepository();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(
            firebaseAuthRepository: firebaseAuthRepository,
          )..checkAuth(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepository: firebaseProfileRepository,
            firebaseStorageRepository: firebaseStorageRepository,
          ),
        ),
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepository: firebasePostRepository,
            storageRepository: firebaseStorageRepository,
          ),
        ),
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(
            searchRepository: firebaseSearchRepository,
          ),
        ),
      ],
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
