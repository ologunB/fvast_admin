import 'package:flutter/material.dart';
import 'package:fvast_admin/constants/styles.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final FocusNode focusNode;
  final int maxLength;
  final int maxLines;
  final bool enabled;
  final bool autoFocus;
  final String labelText;
  final String hintText;
  final Widget suffixIcon;
  final Function(String) validator;
  final Function(String) onChanged;
  final bool obscure;

  const CustomTextField(
      {Key key,
      this.controller,
      this.enabled = true,
      this.autoFocus = false,
      this.inputType,
      this.inputAction,
      this.focusNode,
      this.maxLength,
      this.maxLines,
      this.labelText,
      this.suffixIcon,
      this.validator,
      this.onChanged,
      this.hintText,
      this.obscure})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscure;

  @override
  void initState() {
    obscure = widget.obscure;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.inputType,
      controller: widget.controller,
      textInputAction: widget.inputAction,
      maxLength: widget.maxLength,
      autofocus: widget.autoFocus,
      enabled: widget.enabled,
      maxLines: widget.maxLines,obscureText: obscure ?? false,
      cursorColor: Colors.black,
      style:
          GoogleFonts.nunito(color: Styles.colorBlack, fontWeight: FontWeight.w600, fontSize: 15),
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        labelText: widget.labelText,
        fillColor: Styles.colorGreyDark.withOpacity(0.05),
        filled: true,
        hintStyle: GoogleFonts.nunito(
            color: Styles.colorGreyDark, fontWeight: FontWeight.w400, fontSize: 12),
        labelStyle: GoogleFonts.nunito(
            color: Styles.colorGreyDark, fontWeight: FontWeight.w400, fontSize: 14),
        hintText: widget.hintText,
        errorStyle: TextStyle(
          color: Color(0xff222222),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Styles.appCanvasBlue, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Styles.colorBlack.withOpacity(0.2), width: 1.2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        counterText: '',
        suffixIcon: obscure == null
            ? null
            : IconButton(
                icon: obscure
                    ? Icon(Icons.visibility_off, color: Styles.colorGreyDark)
                    : Icon(Icons.visibility, color: Styles.appCanvasBlue),
                onPressed: () {
                  setState(
                    () {
                      obscure = !obscure;
                    },
                  );
                },
              ),
      ),
      validator: widget.validator,
    );
  }
}
