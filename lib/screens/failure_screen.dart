import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/screens/tabs_screen.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:edu_nova/themes/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FailureScreen extends StatelessWidget {
  const FailureScreen({super.key});
  static const routeName = '/failure';

  @override
  Widget build(BuildContext context) {
    ThemeCubit theme = BlocProvider.of<ThemeCubit>(context, listen: true);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 0,
              color: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                tileColor: kMainSwatchColor.withOpacity(0.2),
                title: Text('${AppLocalizations.of(context)!.oops} 😕', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                subtitle: Text(AppLocalizations.of(context)!.sorryAnErrorOccurred, style: Theme.of(context).textTheme.labelLarge),
                trailing: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: kMainSwatchColor.withOpacity(0.2),
                          ),
                          child: Tooltip(
                            message: AppLocalizations.of(context)!.home,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(context, TabsScreen.routeName, (route) => false);
                              },
                              icon: Icon(Icons.home, color: kMainSwatchColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Hero(
                tag: 'hero-tag',
                child: Image.asset(
                  theme.isDark ? 'assets/images/failure-dark.png' : 'assets/images/failure-light.png',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: size(context).width,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, TabsScreen.routeName, (route) => false);
                  },
                  child: Text(AppLocalizations.of(context)!.goToHome),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
