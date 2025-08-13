import 'package:flutter/material.dart';
import 'package:second_shot/utils/extensions.dart';

class CareerDetailsHeading extends StatelessWidget {
  final String title;
  const CareerDetailsHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
    );
  }
}

class CareerDetailsGreyText extends StatelessWidget {
  final String text;
  const CareerDetailsGreyText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.bodyMedium!.copyWith(),
    );
  }
}

class CareerBulletedText extends StatelessWidget {
  final String text;
  const CareerBulletedText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(text: '\u2022  ', children: [
        TextSpan(text: text),
      ]),
      style: context.textTheme.titleMedium,
    );
  }
}
