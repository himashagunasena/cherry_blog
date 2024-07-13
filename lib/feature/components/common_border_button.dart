import '../../utils/constant.dart';
import 'package:flutter/material.dart';

class CommonBorderButton extends StatefulWidget {
  final String? name;
  final bool? isClick;
  final VoidCallback? click;

  const CommonBorderButton({
    super.key,
    this.name,
    this.click,
    this.isClick = false,
  });

  @override
  State<CommonBorderButton> createState() => _CommonBorderButtonState();
}

class _CommonBorderButtonState extends State<CommonBorderButton> {
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colorTheme.primary),
          color: colorTheme.background,
        ),
        child: Text(
          widget.name ?? "",
          textAlign: TextAlign.center,
          style: AppTextStyle().textLargeButtonPrimaryStyle(colorTheme.primary),
        ),
      ),
    );
  }
}
