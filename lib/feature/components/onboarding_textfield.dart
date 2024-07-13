import '../../utils/helper.dart';
import 'package:flutter/material.dart';

class OnBoardingTextField extends StatefulWidget {
  final String? label;
  final int? maxLine;
  final TextEditingController textEditingController;
  final bool obscure;

  const OnBoardingTextField({
    super.key,
    this.label,
    this.maxLine,
    required this.textEditingController,  this.obscure=false,
  });

  @override
  State<OnBoardingTextField> createState() => _OnBoardingTextFieldState();
}

class _OnBoardingTextFieldState extends State<OnBoardingTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textEditingController,
      obscureText: widget.obscure,
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
        labelStyle: const TextStyle(fontSize: 16),

      ),
    );
  }
}
