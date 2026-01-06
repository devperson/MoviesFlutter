import 'package:flutter/material.dart';
import '../../Utils/ColorConstants.dart';
import '../../Utils/FontConstants.dart';

class F_MultilineEditTextField extends StatefulWidget
{
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String placeholder;

  final double fontSize;
  final String fontFamily;

  final Color backgroundColor;
  final Color normalBorderColor;
  final Color focusedBorderColor;
  final double borderWidth;

  final double minHeight;
  final double horizontalPadding;
  final double verticalPadding;

  const F_MultilineEditTextField({
    super.key,
    required this.placeholder,
    this.controller,
    this.onChanged,
    this.fontSize = 15,
    this.fontFamily = FontConstants.RegularFont,
    this.backgroundColor = Colors.white,
    this.normalBorderColor = Colors.transparent,
    this.focusedBorderColor = ColorConstants.PrimaryColor,
    this.borderWidth = 2,
    this.minHeight = 120,
    this.horizontalPadding = 16,
    this.verticalPadding = 12,
  }) : assert(
  controller != null || onChanged != null,
  'Either controller or onChanged must be provided',
  );

  @override
  State<F_MultilineEditTextField> createState() =>
      _F_MultilineEditTextFieldState();
}

class _F_MultilineEditTextFieldState
    extends State<F_MultilineEditTextField>
{
  late final FocusNode _focusNode;

  @override
  void initState()
  {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose()
  {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    final borderColor = _focusNode.hasFocus
        ? widget.focusedBorderColor
        : widget.normalBorderColor;

    // Approximate min lines from height
    final minLines =
    (widget.minHeight / (widget.fontSize * 1.4)).ceil();

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: widget.minHeight,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.horizontalPadding,
          vertical: widget.verticalPadding,
        ),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: widget.borderWidth,
          ),
        ),
        child: Scrollbar(
          thumbVisibility: false,
          child: TextField(
            focusNode: _focusNode,
            controller: widget.controller,
            onChanged: widget.onChanged,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            minLines: minLines,
            maxLines: null, // unlimited
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
      ),
    );
  }
}
