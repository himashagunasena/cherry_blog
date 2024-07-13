import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InitialImage extends StatefulWidget {
  final String? name;
  final TextStyle? fontStyle;
  final double size;

  const InitialImage({
    super.key,
    this.name,
    this.fontStyle, required this.size,
  });

  @override
  State<InitialImage> createState() => _InitialImageState();
}

class _InitialImageState extends State<InitialImage> {
  @override
  void initState() {
    getInitial();
    super.initState();
  }

  String? getInitial() {
    if (widget.name!.isNotEmpty) {
      if (widget.name!.split(" ").length == 1) {
        return " ${widget.name![0]} ";
      }
      return widget.name
          ?.trim()
          .split(RegExp(' +'))
          .map((s) => s[0])
          .take(2)
          .join();
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return Container(
      width: widget.size,
      height: widget.size,
      padding: const EdgeInsets.all(12),
      decoration:  BoxDecoration(
        shape: BoxShape.circle,
        color: colorTheme.shadow,
      ),
      child: Center(
        child: Text(
          getInitial() ?? "",
          style: GoogleFonts.playfairDisplay(
            fontSize: widget.size/3,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
