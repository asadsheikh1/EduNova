import 'dart:convert';
import 'dart:io';

import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/constants/repository.dart';
import 'package:edu_nova/screens/failure_screen.dart';
import 'package:edu_nova/screens/success_screen.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:edu_nova/widgets/order_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:jazzcash_flutter/jazzcash_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  static const routeName = '/checkout';

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String paymentStatus = "pending";
  String integritySalt = "v3s3y665vf";
  String merchantID = "MC12686";
  String merchantPassword = "5z932w9sa5";
  String transactionUrl = "https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction";

  // String integritySalt = "9w79ux4103";
  // String merchantID = "MC58249";
  // String merchantPassword = "6b1wausc29";
  // String transactionUrl = "https://sandbox.jazzcash.com.pk/Sandbox/Home/GettingStarted";

  Future payViaJazzCash(CourseModel element, BuildContext c) async {
    JazzCashFlutter jazzCashFlutter = JazzCashFlutter(
      merchantId: merchantID,
      merchantPassword: merchantPassword,
      integritySalt: integritySalt,
      isSandbox: true,
    );

    DateTime date = DateTime.now();

    JazzCashPaymentDataModelV1 paymentDataModelV1 = JazzCashPaymentDataModelV1(
      ppAmount: '${element.courseCost}',
      ppBillReference: 'refbill${date.year}${date.month}${date.day}${date.hour}${date.millisecond}',
      ppDescription: 'Product details  ${element.courseId} - ${element.courseCost}',
      ppMerchantID: merchantID,
      ppPassword: merchantPassword,
      ppReturnURL: transactionUrl,
    );

    jazzCashFlutter.startPayment(paymentDataModelV1: paymentDataModelV1, context: context).then((response) {
      if (Platform.isAndroid) {
        Repository.addOrder(
          context: context,
          courseId: element.courseId.toString(),
          courseTitle: element.courseTitle.toString(),
          amount: element.courseCost.toString(),
          billReference: 'refbill20237417480',
          merchantId: 'MC58249',
          transactionCurrency: 'PKR',
          transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
          transactionReferenceNumber: 'T470221066772',
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          SuccessScreen.routeName,
          (route) => false,
          arguments: {
            'order': element.courseId.toString(),
            'price': element.courseCost.toString(),
            'pp_TxnRefNo': '123123',
          },
        );
      }

      if (Platform.isIOS) {
        Map<dynamic, dynamic> stringVar = json.decode(response);

        if (stringVar['pp_TxnRefNo'] != null) {
          Repository.addOrder(
            context: context,
            courseId: element.courseId.toString(),
            courseTitle: element.courseTitle.toString(),
            amount: stringVar['pp_Amount'],
            billReference: stringVar['pp_BillReference'],
            merchantId: stringVar['pp_MerchantID'],
            transactionCurrency: stringVar['pp_TxnCurrency'],
            transactionId: stringVar['pp_TxnDateTime'],
            transactionReferenceNumber: stringVar['pp_TxnRefNo'],
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            SuccessScreen.routeName,
            (route) => false,
            arguments: {
              'order': element.courseId.toString(),
              'price': element.courseCost.toString(),
              'pp_TxnRefNo': stringVar['pp_TxnRefNo'].toString(),
            },
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(context, FailureScreen.routeName, (route) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    CourseModel courseModel = CourseModel(course['time'], course['title'], course['cost']);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                  title: Text('${AppLocalizations.of(context)!.checkout} 🛒', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(AppLocalizations.of(context)!.convenientPaymentSolutions, style: Theme.of(context).textTheme.labelLarge),
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
                              message: 'Home',
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.keyboard_arrow_left, color: kMainSwatchColor),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.eduNovaEnsuresASeamlessAndReliableTransactionExperiencePoweredBy,
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Hero(
                      tag: 'hero-tag',
                      child: Image.asset('assets/images/jazzcash-logo.png'),
                    ),
                  ],
                ),
              ),
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
                  title: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(AppLocalizations.of(context)!.orderDetails, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      OrderRowWidget(left: AppLocalizations.of(context)!.order, right: '1 x ${course['title']}'),
                      OrderRowWidget(left: AppLocalizations.of(context)!.pricePKR, right: course['cost']),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: size(context).width,
                  child: FilledButton(
                    onPressed: () {
                      payViaJazzCash(courseModel, context);
                    },
                    child: Text(AppLocalizations.of(context)!.purchaseNow),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseModel {
  String? courseId;
  String? courseTitle;
  String? courseCost;

  CourseModel(this.courseId, this.courseTitle, this.courseCost);
}
