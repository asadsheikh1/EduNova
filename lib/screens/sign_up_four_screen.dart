import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpFourScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final List<String> selectedinterestList;
  final String countryCode;
  final String phone;
  final String countryISOCodeController;

  const SignUpFourScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.selectedinterestList,
    required this.countryCode,
    required this.phone,
    required this.countryISOCodeController,
  });

  @override
  State<SignUpFourScreen> createState() => _SignUpFourScreenState();
}

class _SignUpFourScreenState extends State<SignUpFourScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool passwordObscure = true;
  bool confirmPasswordObscure = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: size(context).height * 0.4),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              AppLocalizations.of(context)!.sshhhhWhatsThePassword,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
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
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.emailAddress,
                                hintText: AppLocalizations.of(context)!.exampleAtExampleDotCom,
                                floatingLabelStyle: TextStyle(color: kMainSwatchColor),
                                hintStyle: TextStyle(color: kTextColor),
                                labelStyle: TextStyle(color: kTextColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.pleaseEnterSomeText;
                                }
                                if (value.length < 6) {
                                  return AppLocalizations.of(context)!.passwordMustContainAtleast6Alphabets;
                                }
                                return null;
                              },
                              controller: passwordController,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.password,
                                floatingLabelStyle: TextStyle(color: kMainSwatchColor),
                                hintStyle: TextStyle(color: kTextColor),
                                labelStyle: TextStyle(color: kTextColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passwordObscure = !passwordObscure;
                                    });
                                  },
                                  icon: Icon(
                                    passwordObscure ? Icons.visibility_off : Icons.visibility,
                                    color: kTextColor,
                                  ),
                                ),
                                filled: true,
                              ),
                              obscureText: passwordObscure,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.pleaseEnterSomeText;
                                }
                                if (value.length < 6) {
                                  return AppLocalizations.of(context)!.passwordMustContainAtleast6Alphabets;
                                }
                                if (value != passwordController.text) {
                                  return AppLocalizations.of(context)!.passwordsDoNotMatch;
                                }
                                return null;
                              },
                              controller: confirmPasswordController,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.confirmPassword,
                                floatingLabelStyle: TextStyle(color: kMainSwatchColor),
                                hintStyle: TextStyle(color: kTextColor),
                                labelStyle: TextStyle(color: kTextColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      confirmPasswordObscure = !confirmPasswordObscure;
                                    });
                                  },
                                  icon: Icon(
                                    confirmPasswordObscure ? Icons.visibility_off : Icons.visibility,
                                    color: kTextColor,
                                  ),
                                ),
                                filled: true,
                              ),
                              obscureText: confirmPasswordObscure,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.keyboard_arrow_left),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FilledButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Repository().userAuth(
                                context: context,
                                firstName: widget.firstName,
                                lastName: widget.lastName,
                                interests: widget.selectedinterestList,
                                countryCode: widget.countryCode,
                                phone: widget.phone,
                                countryISOCode: widget.countryISOCodeController,
                                email: emailController.text.toLowerCase(),
                                password: passwordController.text,
                              );
                            }
                          },
                          child: const Icon(Icons.keyboard_arrow_right),
                        ),
                      ),
                    ],
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
