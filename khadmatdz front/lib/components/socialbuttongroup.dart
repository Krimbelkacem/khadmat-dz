import 'package:flutter/material.dart';

class SocialButtonGroup extends StatelessWidget {
  final Function() onGooglePressed;
  final Function() onLinkedInPressed;

  const SocialButtonGroup({
    required this.onGooglePressed,
    required this.onLinkedInPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _GoogleButton(
          onPressed: onGooglePressed,
        ),
        const SizedBox(width: 10),
        _LinkedInButton(
          onPressed: onLinkedInPressed,
        ),
      ],
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final Function() onPressed;

  const _GoogleButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          )),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '../../images/google.png', // Path to the asset
              width: 30,
            ),
            const SizedBox(width: 10),
            const Text(
              "Google",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkedInButton extends StatelessWidget {
  final Function() onPressed;

  const _LinkedInButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement the LinkedIn button similar to the Google button
    // Replace the placeholder implementation with the actual LinkedIn button implementation
    return Container(
      height: 54,
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),

      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          )),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '../../images/linkedin.png', // Path to the asset
              width: 30,
            ),
            const SizedBox(width: 10),
            const Text(
              "LinkedIn",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
