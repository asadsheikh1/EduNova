import 'package:edu_nova/constants/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});
  static const routeName = '/image';

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    final image = arguments is String ? arguments : null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(AppLocalizations.of(context)!.profile),
      ),
      body: Center(
        child: SizedBox(
          height: size(context).height * 0.5,
          child: Hero(
            tag: 'hero-tag',
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 1,
              maxScale: 4,
              child: image != null
                  ? FadeInImage.assetNetwork(
                      placeholder: 'assets/images/logo-light.png',
                      image: image,
                      width: size(context).width,
                      fit: BoxFit.fitHeight,
                    )
                  : Image.asset('assets/images/profile.jpg'),
            ),
          ),
        ),
      ),
    );
  }
}
