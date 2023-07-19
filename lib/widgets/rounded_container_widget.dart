import 'package:edu_nova/themes/colors.dart';
import 'package:flutter/material.dart';

class RoundedContainerWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const RoundedContainerWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: kMainSwatchColor.shade900,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(60),
          ),
          child: Icon(icon, color: kLightColor, size: 40),
        ),
        const SizedBox(height: 10),
        Text(title, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        Text(subtitle, style: Theme.of(context).textTheme.titleSmall!.copyWith(color: kTextColor), textAlign: TextAlign.center),
      ],
    );
  }
}
