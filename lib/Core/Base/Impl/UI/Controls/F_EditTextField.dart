

import 'package:flutter/material.dart';
import '../../Utils/ColorConstants.dart';
import '../../Utils/FontConstants.dart';

class F_EditTextField extends StatefulWidget
{
  /// Optional controller
  final TextEditingController? controller;

  /// Optional onChanged
  final ValueChanged<String>? onChanged;

  /// Placeholder / hint text
  final String placeholder;

  final double fontSize;
  final String fontFamily;
  final bool isPassword;

  final Color backgroundColor;
  final Color normalBorderColor;
  final Color focusedBorderColor;
  final double borderWidth;

  final double minHeight;
  final double horizontalPadding;

  const F_EditTextField({
    super.key,
    required this.placeholder,
    this.controller,
    this.onChanged,
    this.fontSize = 15,
    this.fontFamily = FontConstants.RegularFont,
    this.isPassword = false,
    this.backgroundColor = Colors.white,
    this.normalBorderColor = Colors.transparent,
    this.focusedBorderColor = ColorConstants.PrimaryColor,
    this.borderWidth = 2,
    this.minHeight = 45,
    this.horizontalPadding = 20,
  }) : assert(controller != null || onChanged != null, 'Either controller or onChanged must be provided', );

  @override
  State<F_EditTextField> createState() => _F_EditTextFieldState();
}

class _F_EditTextFieldState extends State<F_EditTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      // Rebuild only when focus changes (for border color)
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    final borderColor = _focusNode.hasFocus
        ? widget.focusedBorderColor
        : widget.normalBorderColor;

    return SizedBox(
      height: widget.minHeight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.minHeight / 2),
          border: Border.all(
            color: borderColor,
            width: widget.borderWidth,
          ),
        ),
        alignment: Alignment.center,
        child: TextField(
          focusNode: _focusNode,
          controller: widget.controller,
          onChanged: widget.onChanged,
          obscureText: widget.isPassword,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _focusNode.unfocus(),
          style: TextStyle(
            fontSize: widget.fontSize,
            fontFamily: widget.fontFamily,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: widget.fontSize,
              fontFamily: widget.fontFamily,
            ),
            border: InputBorder.none,
            isDense: true,
          ),
        ),
      ),
    );
  }
}