import 'package:flutter/material.dart';

class RemoveOverScrollEffect extends StatelessWidget {
  const RemoveOverScrollEffect({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();

        return true;
      },
      child: child,
    );
  }
}
