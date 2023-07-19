import 'package:edu_nova/blocs/lang/language_bloc.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:edu_nova/themes/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edu_nova/l10n/language.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  static const routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeCubit theme = BlocProvider.of<ThemeCubit>(context, listen: false);
    bool isSwitched = theme.isDark == true;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(AppLocalizations.of(context)!.settings),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context)!.displaySettings,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: kTextColor),
                ),
              ),
              ListTile(
                title: Text(
                  '${theme.isDark ? AppLocalizations.of(context)!.light : AppLocalizations.of(context)!.dark} ${AppLocalizations.of(context)!.mode}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  '${AppLocalizations.of(context)!.experienceAnExciting} ${theme.isDark ? AppLocalizations.of(context)!.lightMode : AppLocalizations.of(context)!.darkMode} ${AppLocalizations.of(context)!.darkMode}',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kTextColor),
                ),
                trailing: Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    theme.changeTheme();
                    setState(() {
                      isSwitched = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context)!.selectLanguage,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: kTextColor),
                ),
              ),
              BlocBuilder<LanguageBloc, LanguageState>(
                builder: (context, state) {
                  return ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: Language.values.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          context.read<LanguageBloc>().add(ChangeLanguage(selectedLanguage: Language.values[index]));
                        },
                        title: Text(
                          "${Language.values[index].name[0].toUpperCase()}${Language.values[index].name.substring(1).toLowerCase()}",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          Language.values[index].value.toString(),
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kTextColor),
                        ),
                        trailing: state.selectedLanguage.name == Language.values[index].name ? Icon(Icons.check, color: kMainSwatchColor) : const SizedBox(),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
