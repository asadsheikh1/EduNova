import 'package:edu_nova/constants/component.dart';
import 'package:flutter/material.dart';

class OrderRowWidget extends StatelessWidget {
  final String left;
  final String right;

  const OrderRowWidget({
    super.key,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: size(context).width * 0.2,
            child: Text(
              left,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          SizedBox(
            width: size(context).width * 0.6,
            child: Text(
              right,
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
