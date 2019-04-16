import 'dart:ui';

import 'package:flutter/widgets.dart';

class LottierAnimation extends StatefulWidget {

  final String path;

  LottierAnimation({
    GlobalKey key,
    @required this.path,
  }) : super(key: key);

  @override
  State createState() => LottierAnimationState();
  
}

class LottierAnimationState extends State<LottierAnimation> {
  bool _isInitialized = false;

  @override
  void initState() {
    _initializeAnimation();
    super.initState();
  }

  Future<void> _initializeAnimation() async {

    setState(() => _isInitialized = true);
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }

}