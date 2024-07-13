
import 'package:flutter/material.dart';

import '../../utils/helper.dart';

class CommonTextField extends StatefulWidget {
  final String? label;
  final int? maxLine;
  final TextEditingController textEditingController;

  const CommonTextField({
    super.key,
    this.label,
    this.maxLine,
    required this.textEditingController,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textEditingController,
      cursorColor:isDarkMode(context)
        ? Colors.white.withOpacity(0.6): Colors.black45,
      maxLines: widget.maxLine ?? 1,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        enabledBorder: OutlineInputBorder(
          borderSide:  BorderSide(  color: isDarkMode(context)
              ? Colors.white.withOpacity(0.6)
              : Colors.black, width: 0.0),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:  BorderSide(color: isDarkMode(context)
              ? Colors.white.withOpacity(0.6)
              : Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        alignLabelWithHint: true,
        labelText: widget.label,
      ),
    );
  }
}
