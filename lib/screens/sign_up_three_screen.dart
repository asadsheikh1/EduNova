import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/screens/sign_up_four_screen.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpThreeScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final List<String> selectedinterestList;

  const SignUpThreeScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.selectedinterestList,
  });

  @override
  State<SignUpThreeScreen> createState() => _SignUpThreeScreenState();
}

class _SignUpThreeScreenState extends State<SignUpThreeScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryISOCodeController = TextEditingController();
  bool passwordObscure = true;
  bool confirmPasswordObscure = true;

  @override
  void dispose() {
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
                              AppLocalizations.of(context)!.giveUsYourPhoneNumberWithCountryYouAreResiding,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: IntlPhoneField(
                              validator: (value) {
                                if (value.toString() == '') {
                                  return AppLocalizations.of(context)!.pleaseFillTheInfo;
                                } else {
                                  countryCodeController.text = value!.countryCode.toString();
                                  countryISOCodeController.text = value.countryISOCode.toString();
                                  return null;
                                }
                              },
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              autofocus: true,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.phone,
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SignUpFourScreen(
                                    firstName: widget.firstName,
                                    lastName: widget.lastName,
                                    selectedinterestList: widget.selectedinterestList,
                                    countryCode: countryCodeController.text,
                                    phone: phoneController.text,
                                    countryISOCodeController: countryISOCodeController.text,
                                  ),
                                ),
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
