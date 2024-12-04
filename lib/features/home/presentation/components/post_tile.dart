import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/authentication/domain/app_user.dart';
import 'package:social_app/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:social_app/features/post/domain/entities/post.dart';
import 'package:social_app/features/post/presentation/cubits/post_cubit.dart';
import 'package:social_app/features/profile/domain/entities/profile_user.dart';
import 'package:social_app/features/profile/presentation/cubits/profile_cubit.dart';

class PostTile extends StatefulWidget {
  const PostTile(
      {super.key, required this.post, required this.onDeletePressed});
  final Post post;
  final void Function()? onDeletePressed;

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  bool isOwnPost = false;
  AppUser? currentUser;
  ProfileUser? postUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Posts'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
            ),
          ),
          TextButton(
            onPressed: () {
              widget.onDeletePressed!();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Delete',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                postUser?.profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: postUser!.profileImageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : const Icon(Icons.person),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.post.userName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (isOwnPost)
                  GestureDetector(
                    onTap: showOptions,
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(
              height: 430,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.favorite_border),
                Text('0'),
                const SizedBox(width: 20),
                Icon(Icons.comment),
                Text('0'),
                Text(widget.post.timestamp.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
