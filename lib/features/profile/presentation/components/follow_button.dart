import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  const FollowButton(
      {super.key, required this.onPressed, required this.isFollowing});

  final void Function()? onPressed;
  final bool isFollowing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MaterialButton(
          onPressed: onPressed,
          padding: const EdgeInsets.all(25.0),
          color: isFollowing
              ? Theme.of(context).colorScheme.primary
              : Colors.green,
          child: Text(
            isFollowing ? 'Unfollow' : 'Following',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
