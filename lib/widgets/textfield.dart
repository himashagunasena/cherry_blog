import 'package:flutter/material.dart';

class TextFieldNew extends StatefulWidget {
  final String title;
  final String name;
  final Function(String) value;
  final double height;
  final double width;
  final int maxline;
  final TextEditingController controller;

  const TextFieldNew({
    super.key,
    required this.title,
    required this.value,
    required this.name,
    required this.height,
    required this.width,
    required this.maxline,
    required this.controller,
  });

  @override
  TextFieldNewState createState() => TextFieldNewState();
}

class TextFieldNewState extends State<TextFieldNew> {
  TextEditingController newTitle = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: widget.height,
            child: TextField(
              maxLines: widget.maxline,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.pinkAccent, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: widget.name,
                  fillColor: Colors.transparent,
                  labelStyle: const TextStyle(
                    color: Colors.green,
                  )),
              onChanged: widget.value,
              controller: widget.controller,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
