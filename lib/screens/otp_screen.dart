// import 'package:edu_nova/constants/component.dart';
// import 'package:edu_nova/screens/sign_up_three_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class OtpScreen extends StatefulWidget {
//   final String firstName;
//   final String lastName;
//   final List<String> selectedinterestList;
//   final String verificationId;
//   final String countryCode;
//   final String phone;

//   const OtpScreen({Key? key, required this.firstName, required this.lastName, required this.selectedinterestList, required this.verificationId, required this.countryCode, required this.phone})
//       : super(key: key);

//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }

// class _OtpScreenState extends State<OtpScreen> {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   String smsCode = '';

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//           elevation: 0,
//         ),
//         resizeToAvoidBottomInset: false,
//         body: Container(
//           margin: const EdgeInsets.all(16),
//           alignment: Alignment.center,
//           child: SingleChildScrollView(
//             keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//             physics: const ClampingScrollPhysics(),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   'Verify OTP',
//                   style: Theme.of(context).textTheme.headlineSmall,
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 20),
//                 Pinput(
//                   length: 6,
//                   pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
//                   showCursor: true,
//                   onChanged: (value) {
//                     smsCode = value;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: size(context).width,
//                   child: FilledButton(
//                     onPressed: () async {
//                       try {
//                         PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: smsCode);
//                         await auth.signInWithCredential(credential).then((value) {
//                           return Navigator.of(context)
//                               .push(
//                             MaterialPageRoute(
//                               builder: (context) => SignUpThreeScreen(
//                                 firstName: widget.firstName,
//                                 lastName: widget.lastName,
//                                 selectedinterestList: widget.selectedinterestList,
//                                 verificationId: widget.verificationId,
//                                 countryCode: widget.countryCode,
//                                 phone: widget.phone,
//                               ),
//                             ),
//                           )
//                               .onError((error, stackTrace) {
//                             return flutterToast(AppLocalizations.of(context)!.sorryAnErrorOccurred);
//                           });
//                         });
//                       } catch (e) {
//                         flutterToast(AppLocalizations.of(context)!.sorryAnErrorOccurred);
//                       }
//                     },
//                     child: const Text('Verify Phone Number'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
