import '../../utils/constant.dart';
import 'package:flutter/material.dart';

class CommonListButton extends StatefulWidget {
  final String? name;
  final bool? isClick;
  final VoidCallback? click;

  const CommonListButton({
    super.key,
    this.name,
    this.click,
    this.isClick = false,
  });

  @override
  State<CommonListButton> createState() => _CommonListButtonState();
}

class _CommonListButtonState extends State<CommonListButton> {
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
        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colorTheme.primary),
          color: widget.isClick! ? colorTheme.primary : Colors.transparent,
        ),
        child: Text(
          widget.name ?? "",
          style: widget.isClick!
              ? AppTextStyle().textButtonWhiteStyle(context)
              : AppTextStyle().textButtonStyle(colorTheme.primary),
        ),
      ),
    );
  }
}
