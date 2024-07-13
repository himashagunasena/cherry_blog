import 'package:flutter/material.dart';

import '../../utils/constant.dart';
import '../../utils/constant.dart';
import 'common_border_button.dart';
import 'common_fill_button.dart';

class CommonAlert extends StatefulWidget {
  final String? warning;
  final String? name;
  final String? negativeName;
  final VoidCallback? click;
  final VoidCallback? negativeClick;

  const CommonAlert({
    super.key,
    this.name,
    this.click,
    this.negativeClick, this.negativeName, this.warning,
  });

  @override
  State<CommonAlert> createState() => _CommonAlertState();
}

class _CommonAlertState extends State<CommonAlert> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return Dialog(
      backgroundColor: colorTheme.background,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 28),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.warning??"",style: AppTextStyle().textBodyStyle,),
            const SizedBox(height: 24),
            CommonFillButton(name: widget.name,click: widget.click,),
            const SizedBox(height: 8),
            CommonBorderButton(name: widget.negativeName,click: widget.negativeClick,),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
