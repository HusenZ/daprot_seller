import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ExpandableText extends StatefulWidget {
  final String text;

  const ExpandableText(this.text, {super.key});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          maxLines: isExpanded ? 2 : 8,
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 12.sp,
                      color: const Color.fromARGB(146, 120, 117, 117),
                    ),
              ),
              const TextSpan(text: "\n", style: TextStyle(height: 1.2)),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? 'Show more' : 'Show less',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.blue,
                  fontSize: 10.sp,
                ),
          ),
        ),
      ],
    );
  }
}
