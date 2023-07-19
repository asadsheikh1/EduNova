import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/screens/sign_up_one_screen.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:edu_nova/themes/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const routeName = '/sign-in';
  static bool isChecked = true;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  Repository apis = Repository();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool userLoggedIn = false;
  bool passwordObscure = true;

  void resetForm() {
    formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    ThemeCubit theme = BlocProvider.of<ThemeCubit>(context, listen: true);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const ClampingScrollPhysics(),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size(context).width - 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'logo',
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                theme.isDark ? 'assets/images/logo-dark.png' : 'assets/images/logo-light.png',
                                scale: 5,
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(minHeight: size(context).height * 0.25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
                                        return AppLocalizations.of(context)!.useTheStandardUsernameFormatLikeNameAtExampleDotCom;
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: AppLocalizations.of(context)!.emailAddress,
                                      hintText: AppLocalizations.of(context)!.exampleAtExampleDotCom,
                                      floatingLabelStyle: TextStyle(color: kMainSwatchColor),
                                      hintStyle: TextStyle(color: kTextColor),
                                      labelStyle: TextStyle(color: kTextColor),
                                      suffixIcon: Icon(Icons.email, color: kMainSwatchColor),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return AppLocalizations.of(context)!.enterAPassword;
                                      } else if (value.length < 6) {
                                        return AppLocalizations.of(context)!.youveEnteredIncorrectPassword;
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: AppLocalizations.of(context)!.password,
                                      floatingLabelStyle: TextStyle(color: kMainSwatchColor),
                                      hintStyle: TextStyle(color: kTextColor),
                                      labelStyle: TextStyle(color: kTextColor),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            passwordObscure = !passwordObscure;
                                          });
                                        },
                                        icon: Icon(passwordObscure ? Icons.visibility_off : Icons.visibility, color: kMainSwatchColor),
                                      ),
                                    ),
                                    obscureText: passwordObscure,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              direction: Axis.horizontal,
                              spacing: 20.0,
                              runSpacing: 4.0,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.center,
                                  direction: Axis.horizontal,
                                  children: [
                                    Checkbox(
                                      value: SignInScreen.isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          SignInScreen.isChecked = value!;
                                          uncachedEmail = emailController.text.toLowerCase();
                                        });
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        AppLocalizations.of(context)!.keepMeSignedIn,
                                        style: Theme.of(context).textTheme.labelLarge,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          FilledButton(
                            child: Text(AppLocalizations.of(context)!.signIn),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                apis.login(context, emailController.text.toLowerCase(), passwordController.text.toLowerCase());
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.dontHaveAnAccount),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(SignUpOneScreen.routeName);
                            resetForm();
                          },
                          child: Text(AppLocalizations.of(context)!.register),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
