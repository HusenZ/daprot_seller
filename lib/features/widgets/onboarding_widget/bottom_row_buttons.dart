import 'package:gozip_seller/features/widgets/common_widgets/delevated_button.dart';
import 'package:flutter/material.dart';

class BottomButtons extends StatelessWidget {
  const BottomButtons({
    super.key,
    required PageController controller,
    required this.width,
  }) : _controller = controller;

  final PageController _controller;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DelevatedButton(
            onTap: () {
              _controller.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
            text: 'Next',
          ),
        ],
      ),
    );
  }
}
