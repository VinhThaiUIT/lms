import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ExpandableHtml extends StatefulWidget {
  final String data;
  final int maxLines;

  const ExpandableHtml({Key? key, required this.data, this.maxLines = 5})
      : super(key: key);

  @override
  _ExpandableHtmlState createState() => _ExpandableHtmlState();
}

class _ExpandableHtmlState extends State<ExpandableHtml> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(
          text: widget.data,
          style: DefaultTextStyle.of(context).style,
        );

        final tp = TextPainter(
          text: span,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        );

        tp.layout(maxWidth: constraints.maxWidth);

        if (!tp.didExceedMaxLines) {
          return Html(data: widget.data);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Html(
              data: isExpanded
                  ? widget.data
                  : widget.data.substring(
                          0,
                          tp
                              .getPositionForOffset(Offset(tp.width, tp.height))
                              .offset) +
                      "...",
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  isExpanded ? 'Show less' : 'See more',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
