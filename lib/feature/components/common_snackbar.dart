import 'package:flutter/material.dart';

class CommonSnackBar extends StatefulWidget {
  final String? title;
  final String? description;
  final VoidCallback onClose;
  final bool success;

  const CommonSnackBar({
    super.key,
    this.title,
    this.description,
    required this.onClose,
    required this.success,
  });

  @override
  State<CommonSnackBar> createState() => _CommonSnackBarState();
}

class _CommonSnackBarState extends State<CommonSnackBar> {
  @override
  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.success
            ? Colors.green.withOpacity(0.15)
            : colorTheme.error.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            widget.success? Icons.verified:  Icons.warning_rounded,
            color:widget.success?Colors.green: colorTheme.error,
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.title ?? "",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.description ?? "",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(
              Icons.close_outlined,
            ),
          )
        ],
      ),
    );
  }
}
