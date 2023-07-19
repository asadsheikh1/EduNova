import 'package:edu_nova/themes/colors.dart';
import 'package:flutter/material.dart';

class DefaultWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const DefaultWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 60, color: kTextColor),
        Text(title, style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: kTextColor), textAlign: TextAlign.center),
        Text(subtitle, style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: kTextColor), textAlign: TextAlign.center),
      ],
    );
  }
}
