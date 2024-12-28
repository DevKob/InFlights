import 'package:fluent_ui/fluent_ui.dart';
import 'package:inflights_pro/base/wedgets/text_style_fourth.dart';
import 'package:inflights_pro/base/wedgets/text_style_third.dart';

class AppColumnTextLayout extends StatelessWidget {
  final String topText;
  final String bottomText;
  final bool? isColor;
  final CrossAxisAlignment textAlign;
  const AppColumnTextLayout({super.key, required this.topText, required this.bottomText, required this.textAlign, this.isColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: textAlign,
      children: [
        TextStyleThird(text: topText, isColor: isColor,),
        SizedBox(height: 5,),
        TextStyleFourth(text: bottomText, isColor: isColor,),
      ],
    );
  }
}
