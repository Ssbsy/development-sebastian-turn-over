import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final bool isPassword;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final VoidCallback? onSubmit;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? padding;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.validator,
    this.isPassword = false,
    this.focusNode,
    this.nextFocusNode,
    this.onSubmit,
    this.keyboardType,
    this.padding,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscuredText = true;

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPassword != widget.isPassword) {
      setState(() {
        _obscuredText = widget.isPassword;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _obscuredText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final borderStyle = OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
      borderRadius: BorderRadius.circular(8.0),
    );

    final errorBorderStyle = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red.shade700,
      ),
      borderRadius: BorderRadius.circular(8.0),
    );

    final Widget leadingIcon = widget.isPassword
        ? Image.asset("lib/images/Group.png")
        : Image.asset("lib/images/fluent_person-16-regular.png");

    return Container(
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        color: const Color(0xFFEEE4F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType ??
            (widget.isPassword
                ? TextInputType.text
                : TextInputType.emailAddress),
        obscureText: widget.isPassword ? _obscuredText : false,
        decoration: InputDecoration(
          hintText: widget.hint,
          focusedBorder: borderStyle,
          enabledBorder: borderStyle,
          errorBorder: errorBorderStyle,
          focusedErrorBorder: errorBorderStyle,
          prefixIcon: leadingIcon,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscuredText ? Icons.visibility_off : Icons.visibility,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscuredText = !_obscuredText;
                    });
                  },
                )
              : null,
        ),
        validator: widget.validator,
        textInputAction: widget.nextFocusNode != null
            ? TextInputAction.next
            : TextInputAction.done,
        onFieldSubmitted: (value) {
          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          } else {
            FocusScope.of(context).unfocus();
            if (widget.onSubmit != null) {
              widget.onSubmit!();
            }
          }
        },
      ),
    );
  }
}
