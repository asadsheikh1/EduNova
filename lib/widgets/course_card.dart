import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/screens/course_detail_screen.dart';
import 'package:edu_nova/themes/colors.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final Map<dynamic, dynamic> course;

  const CourseCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(CourseDetailScreen.routeName, arguments: course);
      },
      child: Card(
        margin: const EdgeInsets.all(4),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                FadeInImage.assetNetwork(
                  placeholder: 'assets/images/image-loading.png',
                  image: course['imageUrl'].toString(),
                  height: 240,
                  width: size(context).width,
                  fit: BoxFit.fitHeight,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/error-image.png',
                      height: 240,
                      width: size(context).width,
                      fit: BoxFit.fitHeight,
                    );
                  },
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FittedBox(
                child: Text(
                  course['title'].toString(),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: kMainSwatchColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
