/* By Abdullah As-Sadeed */

import 'package:flutter/material.dart';

class ApplicationToolBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  const ApplicationToolBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: <Widget>[],
      elevation: 4.0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
