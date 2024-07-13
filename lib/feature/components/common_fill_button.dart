import '../../utils/constant.dart';
import 'package:flutter/material.dart';

class CommonFillButton extends StatefulWidget {
  final String? name;
  final bool? isClick;
  final VoidCallback? click;

  const CommonFillButton({
    super.key,
    this.name,
    this.click,
    this.isClick = false,
  });

  @override
  State<CommonFillButton> createState() => _CommonFillButtonState();
}

class _CommonFillButtonState extends State<CommonFillButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: widget.click,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding:
        const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorTheme.primary,
        ),
        child: Text(
         widget.name??"",
          textAlign: TextAlign.center,
          style: AppTextStyle().textLargeButtonWhiteStyle(context),
        ),
      ),
    );
  }
}
