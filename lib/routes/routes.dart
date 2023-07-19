import 'package:edu_nova/screens/checkout_screen.dart';
import 'package:edu_nova/screens/course_detail_screen.dart';
import 'package:edu_nova/screens/create_course_screen.dart';
import 'package:edu_nova/screens/edit_profile_screen.dart';
import 'package:edu_nova/screens/failure_screen.dart';
import 'package:edu_nova/screens/feedback_screen.dart';
import 'package:edu_nova/screens/image_screen.dart';
import 'package:edu_nova/screens/likes_screen.dart';
import 'package:edu_nova/screens/my_course_screen.dart';
import 'package:edu_nova/screens/notifications_screen.dart';
import 'package:edu_nova/screens/onboard_screen.dart';
import 'package:edu_nova/screens/sign_in_screen.dart';
import 'package:edu_nova/screens/sign_up_one_screen.dart';
import 'package:edu_nova/screens/splash_screen.dart';
import 'package:edu_nova/screens/subscribers_screen.dart';
import 'package:edu_nova/screens/success_screen.dart';
import 'package:edu_nova/screens/tabs_screen.dart';
import 'package:edu_nova/screens/user_channel_screen.dart';
import 'package:edu_nova/screens/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:edu_nova/screens/home_screen.dart';
import 'package:edu_nova/screens/profile_screen.dart';
import 'package:edu_nova/screens/subscriptions_screen.dart';
import 'package:edu_nova/screens/settings_screen.dart';

class PageRoutes {
  Map<String, WidgetBuilder> routes() {
    return {
      SplashScreen.routeName: (context) => const SplashScreen(),
      OnBoardScreen.routeName: (context) => const OnBoardScreen(),
      SignInScreen.routeName: (context) => const SignInScreen(),
      SignUpOneScreen.routeName: (context) => const SignUpOneScreen(),
      TabsScreen.routeName: (context) => const TabsScreen(),
      HomeScreen.routeName: (context) => const HomeScreen(),
      SubscriptionsScreen.routeName: (context) => const SubscriptionsScreen(),
      ProfileScreen.routeName: (context) => const ProfileScreen(),
      ImageScreen.routeName: (context) => const ImageScreen(),
      SuccessScreen.routeName: (context) => const SuccessScreen(),
      FailureScreen.routeName: (context) => const FailureScreen(),
      MyCourseScreen.routeName: (context) => const MyCourseScreen(),
      SubscribersScreen.routeName: (context) => const SubscribersScreen(),
      LikesScreen.routeName: (context) => const LikesScreen(),
      UserChannelScreen.routeName: (context) => const UserChannelScreen(),
      SettingsScreen.routeName: (context) => const SettingsScreen(),
      EditProfileScreen.routeName: (context) => const EditProfileScreen(),
      FeedbackScreen.routeName: (context) => const FeedbackScreen(),
      NotificationsScreen.routeName: (context) => const NotificationsScreen(),
      CreateCourseScreen.routeName: (context) => const CreateCourseScreen(),
      CourseDetailScreen.routeName: (context) => const CourseDetailScreen(),
      CheckoutScreen.routeName: (context) => const CheckoutScreen(),
      VideoPlayerScreen.routeName: (context) => const VideoPlayerScreen(),
    };
  }
}
