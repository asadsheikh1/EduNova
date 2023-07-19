import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:edu_nova/screens/sign_in_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});
  static const routeName = '/on-board';

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  double percent = 0.34;

  List<Map<String, dynamic>> sliderList = [
    {
      "icon": 'assets/images/onboard1.png',
      "title": 'Welcome To EduNova',
      "description": 'EduNova is a comprehensive and user-friendly mobile application designed to revolutionize the way you learn and enhance your educational journey.',
    },
    {
      "icon": 'assets/images/onboard2.png',
      "title": 'Explore Your New Skill',
      "description":
          'Explore Your New Skills with EduNova, the ultimate learning companion that empowers you to discover, develop, and master a wide range of new skills. Seamlessly integrating the features of both an exploration app and a comprehensive course platform.',
    },
    {
      "icon": 'assets/images/onboard3.png',
      "title": 'Ready To Find A Course?',
      "description":
          'Get ready to embark on an exciting educational journey with the Ready to Find a Course app. This intuitive mobile application is designed to help you discover the perfect course that matches your interests, goals, and learning preferences. Whether you\'re seeking to expand your knowledge, enhance your skills, or pursue a new career path.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
              child: FilledButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => false);
                },
                child: Text(AppLocalizations.of(context)!.skip),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  height: size(context).height * 0.6,
                  width: size(context).width,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                        itemCount: sliderList.length,
                        controller: pageController,
                        onPageChanged: (int index) {
                          currentIndexPage = index;
                        },
                        itemBuilder: (_, index) {
                          return Column(
                            children: [
                              Image.asset(
                                sliderList[index]['icon'],
                                fit: BoxFit.fill,
                                height: 340,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                child: Text(
                                  sliderList[index]['title'],
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                        color: kMainSwatchColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: SizedBox(
                                  child: Text(
                                    sliderList[index]['description'],
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size(context).height * 0.2,
                  width: size(context).width,
                  child: CircularPercentIndicator(
                    progressColor: kMainSwatchColor,
                    radius: 50.0,
                    lineWidth: 5.0,
                    percent: percent,
                    animation: true,
                    center: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentIndexPage < 2 ? percent = percent + 0.33 : percent = 1.0;
                          currentIndexPage < 2
                              ? pageController.nextPage(duration: const Duration(microseconds: 3000), curve: Curves.bounceInOut)
                              : Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => false);
                        });
                      },
                      child: Container(
                        height: size(context).height * 0.2,
                        width: size(context).width,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.keyboard_double_arrow_right_sharp,
                          color: kMainSwatchColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
