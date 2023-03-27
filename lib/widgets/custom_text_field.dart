import 'package:flutter/material.dart';

import '../constants/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.focusNode,
    this.controller,
    this.onSubmitted,
    this.onPressed,
  }) : super(key: key);

  final FocusNode? focusNode;

  final TextEditingController? controller;

  final Function(String)? onSubmitted;

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(11),
      child: Material(
        shadowColor: Colors.cyan,
        borderRadius: BorderRadius.circular(16),
        color: cardColor,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                cursorColor: Colors.white,
                obscureText: false,
                autofocus: false,
                focusNode: focusNode,
                style: const TextStyle(color: Colors.white),
                controller: controller,
                onSubmitted: onSubmitted,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10),
                  border: InputBorder.none,
                  isCollapsed: true,
                  hintText: null,
                ),
              ),
            ),
            IconButton(
              splashColor: const Color.fromARGB(255, 255, 0, 149),
              splashRadius: 15,
              onPressed: onPressed,
              icon: const Icon(
                Icons.send_outlined,
                color: Color(0xFF00B181),
                size: 21,
              ),
            )
          ],
        ),
      ),
    );
  }
}
