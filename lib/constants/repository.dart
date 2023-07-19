import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/screens/sign_in_screen.dart';
import 'package:edu_nova/screens/tabs_screen.dart';
import 'package:edu_nova/utils/cache.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List value = [];
String? uncachedEmail;

class Repository {
  static final auth = FirebaseAuth.instance;
  static final databaseUser = FirebaseDatabase.instance.ref('user');
  static final databaseFeedback = FirebaseDatabase.instance.ref('feedback');
  static final databaseCategory = FirebaseDatabase.instance.ref('category');
  static final databaseCourse = FirebaseDatabase.instance.ref('course');
  static final databaseFavourite = FirebaseDatabase.instance.ref('favourite');
  static final databaseSubscribe = FirebaseDatabase.instance.ref('subscribe');
  static final databaseLike = FirebaseDatabase.instance.ref('like');
  static final databaseComment = FirebaseDatabase.instance.ref('comment');
  static final databaseTransaction = FirebaseDatabase.instance.ref('transaction');
  static final databaseDevice = FirebaseDatabase.instance.ref('device');

  userAuth({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required List<String> interests,
    required String countryCode,
    required String phone,
    required String countryISOCode,
    required String email,
    required String password,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Repository.auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      pref.setString('email', email);
      UserCacheData.getCacheData();
      Repository.databaseUser.onValue.listen((event) {
        for (var child in event.snapshot.children) {
          if (child.child('email').value.toString() == UserCacheData.userEmail.toString()) {
            pref.setString('id', child.key.toString());
            UserCacheData.getCacheData();
          }
        }
      });
      setUserData(
        context: context,
        firstName: firstName,
        lastName: lastName,
        interests: interests,
        countryCode: countryCode,
        phone: phone,
        countryISOCode: countryISOCode,
        email: email,
      );
    }).onError((error, stackTrace) {
      String errorMessage = AppLocalizations.of(context)!.anErrorOccurredDuringAuthentication;

      if (error is FirebaseAuthException) {
        errorMessage = getFirebaseAuthErrorMessage(error, context);
      }

      flutterToast(errorMessage);
    });
  }

  void login(BuildContext context, String inputEmail, String inputPassword) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Repository.auth.signInWithEmailAndPassword(email: inputEmail.toLowerCase(), password: inputPassword.toLowerCase()).then((value) {
      if (SignInScreen.isChecked) {
        pref.setString('email', inputEmail);
        UserCacheData.getCacheData();
        Repository.databaseUser.onValue.listen((event) {
          for (var child in event.snapshot.children) {
            if (child.child('email').value.toString() == UserCacheData.userEmail.toString()) {
              pref.setString('id', child.key.toString());
              UserCacheData.getCacheData();
            }
          }
        });
      } else {
        uncachedEmail = inputEmail;
      }

      Navigator.pushNamedAndRemoveUntil(context, TabsScreen.routeName, (route) => false);

      flutterToast('${AppLocalizations.of(context)!.successfullyLoginAs} ${value.user!.email.toString()}');
    }).catchError((error) {
      String errorMessage = AppLocalizations.of(context)!.anErrorOccurredDuringAuthentication;

      if (error is FirebaseAuthException) {
        errorMessage = getFirebaseAuthErrorMessage(error, context);
      }

      flutterToast(errorMessage);
    });
  }

  String getFirebaseAuthErrorMessage(FirebaseAuthException exception, BuildContext context) {
    String errorMessage = AppLocalizations.of(context)!.anErrorOccurredDuringAuthentication;

    switch (exception.code) {
      case 'invalid-email':
        errorMessage = AppLocalizations.of(context)!.theEmailAddressIsNotValid;
        break;
      case 'user-disabled':
        errorMessage = AppLocalizations.of(context)!.theUserHasBeenDisabled;
        break;
      case 'user-not-found':
        errorMessage = AppLocalizations.of(context)!.thereIsNoUserRecordCorrespondingToThisIdentifier;
        break;
      case 'wrong-password':
        errorMessage = AppLocalizations.of(context)!.thePasswordIsIncorrect;
        break;
      case 'email-already-in-use':
        errorMessage = AppLocalizations.of(context)!.theEmailAddressIsAlreadyInUseByAnotherAccount;
        break;
      case 'operation-not-allowed':
        errorMessage = AppLocalizations.of(context)!.theOperationIsNotAllowed;
        break;
      case 'weak-password':
        errorMessage = AppLocalizations.of(context)!.thePasswordIsTooWeak;
        break;
      default:
        errorMessage = AppLocalizations.of(context)!.anErrorOccurredDuringAuthentication;
    }

    return errorMessage;
  }

  static logout(BuildContext context) async {
    auth.signOut().then(
      (value) async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.clear().then((value) {
          UserCacheData.getCacheData();
          Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => false);

          flutterToast(AppLocalizations.of(context)!.loggedOut);
        });
      },
    );
  }

  static setUserData({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required List<String> interests,
    required String countryCode,
    required String phone,
    required String countryISOCode,
    required String email,
  }) {
    databaseUser.child('${DateTime.now().millisecondsSinceEpoch}').set({
      'first_name': firstName,
      'last_name': lastName,
      'interests': interests,
      'countryCode': countryCode,
      'phone': phone,
      'countryISOCode': countryISOCode,
      'email': email,
    }).then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false,
      );
      flutterToast(AppLocalizations.of(context)!.accountCreatedSuccessfully).onError((error, stackTrace) {
        return flutterToast(AppLocalizations.of(context)!.sorryAnErrorOccurred);
      });
    });
  }

  static updateUserData({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required List<String> interests,
    required String imageUrl,
    required String countryCode,
    required String phone,
    required String countryISOCode,
  }) {
    databaseUser.child('${UserCacheData.userId}').set({
      'email': UserCacheData.userEmail,
      'first_name': firstName,
      'last_name': lastName,
      'interests': interests,
      'imageUrl': imageUrl,
      'countryCode': countryCode,
      'phone': phone,
      'countryISOCode': countryISOCode,
    }).then((value) {
      flutterToast(AppLocalizations.of(context)!.accountUpdatedSuccessfully).onError((error, stackTrace) {
        return flutterToast(AppLocalizations.of(context)!.sorryAnErrorOccurred);
      });
    });
  }

  static updateUserDataWithoutImage({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required List<String> interests,
    required String countryCode,
    required String phone,
    required String countryISOCode,
  }) {
    databaseUser.child('${UserCacheData.userId}').set({
      'email': UserCacheData.userEmail,
      'first_name': firstName,
      'last_name': lastName,
      'interests': interests,
      'countryCode': countryCode,
      'phone': phone,
      'countryISOCode': countryISOCode,
    }).then((value) {
      flutterToast(AppLocalizations.of(context)!.accountUpdatedSuccessfully).onError((error, stackTrace) {
        return flutterToast(AppLocalizations.of(context)!.sorryAnErrorOccurred);
      });
    });
  }

  static setFeedbackData({
    required BuildContext context,
    required String feedback,
    required int rating,
  }) {
    databaseFeedback.child('${DateTime.now().millisecondsSinceEpoch}').set({
      'email': UserCacheData.userEmail,
      'feedback': feedback,
      'rating': rating,
    }).then((value) {
      flutterToast(AppLocalizations.of(context)!.thankYouForSubmittingTheFeedback);
    }).onError((error, stackTrace) {
      flutterToast(AppLocalizations.of(context)!.sorryAnErrorOccurred);
    });
  }

  static setCourseData({
    required BuildContext context,
    required String title,
    required String description,
    required List<String> outline,
    required String cost,
    required List<String> interests,
    required int date,
    required String imageUrl,
    required List<String> videoUrl,
  }) {
    databaseCourse.child(date.toString()).set({
      'email': UserCacheData.userEmail,
      'title': title,
      'description': description,
      'outline': outline,
      'cost': cost,
      'interests': interests,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'time': date.toString(),
    }).then((value) {
      flutterToast(AppLocalizations.of(context)!.yourCourseHasBeenCreated);
      Navigator.of(context).pop();
    }).onError((error, stackTrace) {
      flutterToast(AppLocalizations.of(context)!.sorryAnErrorOccurred);
    });
  }

  static addFavouriteCourse({
    required BuildContext context,
    required String date,
    required String courseId,
  }) {
    databaseFavourite.child(date).set({
      'email': UserCacheData.userEmail,
      'favouriteId': date,
      'courseId': courseId,
    }).then((value) {
      flutterToast(AppLocalizations.of(context)!.addedToFavourites);
    }).onError((error, stackTrace) {
      flutterToast(AppLocalizations.of(context)!.sorryAnErrorOccurred);
    });
  }

  static deleteFavouriteCourse({
    required BuildContext context,
    required String date,
  }) {
    databaseFavourite.child(date).remove().then((value) {
      flutterToast(AppLocalizations.of(context)!.removedFromFavourites);
    }).onError((error, stackTrace) {
      flutterToast(AppLocalizations.of(context)!.sorryAnErrorOccurred);
    });
  }

  static addSubscribeCourse({
    required BuildContext context,
    required String date,
    required String to,
  }) {
    databaseSubscribe.child(date).set({
      'from': UserCacheData.userEmail,
      'to': to,
      'subscribeId': date,
    }).then((value) {
      flutterToast(AppLocalizations.of(context)!.youAreASubscriberNow);
    }).onError((error, stackTrace) {
      flutterToast(AppLocalizations.of(context)!.sorryAnErrorOccurred);
    });
  }

  static deleteSubscribeCourse({
    required BuildContext context,
    required String date,
  }) {
    databaseSubscribe.child(date).remove().then((value) {
      flutterToast(AppLocalizations.of(context)!.youHaveUnsubscribedFromTheUser);
    }).onError((error, stackTrace) {
      flutterToast(AppLocalizations.of(context)!.sorryAnErrorOccurred);
    });
  }

  static addLikeVideo({
    required BuildContext context,
    required String date,
    required String courseId,
  }) {
    databaseLike.child(date).set({
      'email': UserCacheData.userEmail,
      'likeId': date,
      'courseId': courseId,
    }).then((value) {
      flutterToast(AppLocalizations.of(context)!.liked);
    }).onError((error, stackTrace) {
      flutterToast(AppLocalizations.of(context)!.sorryAnErrorOccurred);
    });
  }

  static deleteLikeVideo({
    required BuildContext context,
    required String date,
  }) {
    databaseLike.child(date).remove().then((value) {
      flutterToast(AppLocalizations.of(context)!.disliked);
    }).onError((error, stackTrace) {
      flutterToast(AppLocalizations.of(context)!.sorryAnErrorOccurred);
    });
  }

  static addComment({
    required BuildContext context,
    required String date,
    required String to,
    required String description,
  }) {
    databaseComment.child(date).set({
      'from': UserCacheData.userEmail,
      'to': to,
      'commentId': date,
      'description': description,
    }).then((value) {
      flutterToast(AppLocalizations.of(context)!.commentAddedSuccessfully);
    }).onError((error, stackTrace) {
      flutterToast(AppLocalizations.of(context)!.sorryAnErrorOccurred);
    });
  }

  static deleteComment({
    required BuildContext context,
    required String date,
  }) {
    databaseComment.child(date).remove().then((value) {
      flutterToast(AppLocalizations.of(context)!.commentDeleted);
    }).onError((error, stackTrace) {
      flutterToast(AppLocalizations.of(context)!.sorryAnErrorOccurred);
    });
  }

  static addOrder({
    required BuildContext context,
    required String courseId,
    required String courseTitle,
    required String amount,
    required String billReference,
    required String merchantId,
    required String transactionCurrency,
    required String transactionId,
    required String transactionReferenceNumber,
  }) {
    databaseTransaction.child(transactionId).set({
      'from': UserCacheData.userEmail,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'amount': amount,
      'billReference': billReference,
      'merchantId': merchantId,
      'transactionCurrency': transactionCurrency,
      'transactionId': transactionId,
      'transactionReferenceNumber': transactionReferenceNumber,
    }).then((value) {
      flutterToast(AppLocalizations.of(context)!.orderAddedSuccessfully);
    }).onError((error, stackTrace) {
      flutterToast(AppLocalizations.of(context)!.sorryAnErrorOccurred);
    });
  }

  static setDevice({
    required BuildContext context,
    required String token,
    required String id,
  }) {
    databaseDevice.child(id).set({
      'email': UserCacheData.userEmail,
      'token': token,
      'id': id,
    }).then((value) {
      // flutterToast('Device added');
    }).onError((error, stackTrace) {
      // flutterToast(AppLocalizations.of(context)!.sorryAnErrorOccurred);
    });
  }

  static List<String> interestsList() {
    List<String> interestList = [
      'Artificial Intelligence',
      'Machine Learning',
      'Data Science',
      'Cybersecurity',
      'Blockchain Technology',
      'Cloud Computing',
      'Internet of Things (IoT)',
      'Cryptography',
      'Quantum Computing',
      'Mobile App Development',
      'Web Development',
      'Game Development',
      'Computer Graphics',
      'Software Engineering',
      'Database Management',
    ];
    return interestList;
  }
}
