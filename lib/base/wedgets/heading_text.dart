import 'package:flutter/material.dart';
import 'package:inflights_pro/base/res/styles/app_styles.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final TextAlign align;
  final bool? isColor;
  const HeadingText({super.key, required this.text, this.align = TextAlign.start, this.isColor});

  @override
  Widget build(BuildContext context) {
    return  Text(
      text,
      textAlign: align,
      style:isColor==null? AppStyles.headLineStyle4
          .copyWith(color: Colors.white):AppStyles.headLineStyle4,

    )
    ;
  }
}
