import 'package:edu_nova/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MarkedFilterChip extends StatelessWidget {
  final List<String> list;

  const MarkedFilterChip({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: list.isNotEmpty
          ? list.map((interest) {
              return FilterChip(
                label: Text(
                  interest,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: kLightColor),
                ),
                onSelected: (bool value) {},
                selected: true,
                showCheckmark: true,
                checkmarkColor: kLightColor,
                backgroundColor: kMainSwatchColor,
                selectedColor: kMainSwatchColor,
              );
            }).toList()
          : [
              Text(AppLocalizations.of(context)!.noInterestsToShow, style: Theme.of(context).textTheme.titleSmall),
            ],
    );
  }
}
