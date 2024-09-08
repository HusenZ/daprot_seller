import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class IButton extends StatelessWidget {
  const IButton({
    super.key,
    required this.tooltipkey,
    required this.message,
  });

  final GlobalKey<TooltipState> tooltipkey;
  final String message;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final dynamic tooltip = tooltipkey.currentState;
        tooltip.ensureTooltipVisible();
      },
      child: Tooltip(
        message: message,
        showDuration: const Duration(seconds: 3),
        padding: EdgeInsets.all(8.sp),
        triggerMode: TooltipTriggerMode.manual,
        preferBelow: true,
        key: tooltipkey,
        verticalOffset: 48,
        child: const Icon(Icons.info),
      ),
    );
  }
}
