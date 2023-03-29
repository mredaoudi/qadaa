import '../components/prayer_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.pushNamed(context, '/setup_user');
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.only(top: 100),
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      globalFooter: const SizedBox(
        width: double.infinity,
        height: 60,
      ),
      pages: [
        PageViewModel(
          title: "ٱلسَّلَامُ عَلَيْكُمْ\n As-salāmu ʿalaykum",
          body:
              "Welcome to the Qadaa app, an app to help you catch up to and keep with your religious duties.",
          image: _buildImage('icon/icon.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "الصَّلَاةُ \nKeep track of your missed mandatory prayers",
          body:
              "Qadaa app features a counter for each of the five daily prayers to help Muslims keep track of their missed prayers.",
          image: _buildImage('pray1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "الصَّوْمُ \nKeep track of your missed mandatory fasts",
          body: "Qadaa also allows users to easily log missed fasts.",
          image: _buildImage('sunset.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Multiple profiles",
          body:
              "Finally, Qadaa allows users to manage multiple profiles within the app, which is useful for helping you keep track of missed prayers and fasts for other people as well. ",
          image: _buildImage('pray2.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
