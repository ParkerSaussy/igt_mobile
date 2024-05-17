import 'package:flutter/material.dart';

class PersistentTabs extends StatelessWidget {
  const PersistentTabs(
      {required this.screenWidgets, this.currentTabIndex = 0, Key? key})
      : super(key: key);
  final int? currentTabIndex;
  final List<Widget> screenWidgets;

  List<Widget> _buildOffstageWidgets() {
    return screenWidgets
        .map(
          (w) => Offstage(
            offstage: currentTabIndex != screenWidgets.indexOf(w),
            child: Navigator(
              onGenerateRoute: (routeSettings) {
                return MaterialPageRoute(builder: (_) => w);
              },
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _buildOffstageWidgets(),
    );
  }
}
