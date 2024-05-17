import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../master/general_utils/common_stuff.dart';

class ReadMoreText extends StatefulWidget {
  final String htmlContent;
  final int maxLines;
  final String readMoreText;

  const ReadMoreText({
    super.key,
    required this.htmlContent,
    this.maxLines = 3,
    this.readMoreText = "Read More",
  });

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Html(
            data: widget.htmlContent,
            onLinkTap: (url, attributes, document) {
              printMessage(url!);
              launchUrl(Uri.parse(url));
              //open URL in webview, or launch URL in browser, or any other logic here
            }),
        if (!expanded)
          GestureDetector(
            onTap: () {
              setState(() {
                expanded = true;
              });
            },
            child: Text(
              widget.readMoreText,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
      ],
    );
  }
}
