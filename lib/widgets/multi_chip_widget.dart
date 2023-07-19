import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:flutter/material.dart';

class MultiChipWidget extends StatefulWidget {
  final Function(List<String>)? onSelectionChanged;
  final Function(List<String>)? onMaxSelected;

  const MultiChipWidget({super.key, this.onSelectionChanged, this.onMaxSelected});

  @override
  State<MultiChipWidget> createState() => _MultiChipWidgetState();
}

class _MultiChipWidgetState extends State<MultiChipWidget> {
  List<String> interestList = Repository.interestsList();
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];

    for (var item in interestList) {
      choices.add(
        Container(
          padding: const EdgeInsets.all(2.0),
          child: FilterChip(
            label: Text(
              item,
              style: selectedChoices.contains(item) ? Theme.of(context).textTheme.titleSmall!.copyWith(color: kLightColor) : Theme.of(context).textTheme.titleSmall!.copyWith(color: kDarkColor),
            ),
            checkmarkColor: kLightColor,
            selectedColor: kMainSwatchColor,
            selected: selectedChoices.contains(item),
            onSelected: (selected) {
              if (selectedChoices.length == (interestList.length) && !selectedChoices.contains(item)) {
                widget.onMaxSelected?.call(selectedChoices);
              } else {
                setState(() {
                  selectedChoices.contains(item) ? selectedChoices.remove(item) : selectedChoices.add(item);
                  widget.onSelectionChanged?.call(selectedChoices);
                });
              }
            },
          ),
        ),
      );
    }
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
