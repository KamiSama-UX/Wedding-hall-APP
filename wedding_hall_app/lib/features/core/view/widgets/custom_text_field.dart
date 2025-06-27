import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KTextForm extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String? value)? validator;
  final void Function()? onTap;
  final TextInputType? type;
  final bool justNumbers;
  final bool isNumberPhone;
  final bool isEnabled;
  final int? minLines;
  final int? maxLines;
  final bool readOnly;
  final Widget? prefixIcon;

  const KTextForm({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.minLines,
    this.maxLines = 1,
    this.onTap,
    this.isNumberPhone = false,
    this.type = TextInputType.text,
    this.isEnabled = true,
    this.readOnly = false,
    this.justNumbers = false,
    this.prefixIcon,
  });

  @override
  State<KTextForm> createState() => _KTextFormState();
}

class _KTextFormState extends State<KTextForm> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      minLines: widget.minLines,
      maxLines: _isObscureText() ? 1 : widget.maxLines,
      enabled: widget.isEnabled,
      readOnly: widget.readOnly,
      keyboardType: widget.type,
      validator: widget.validator,
      inputFormatters: checkJustNumbers(),
      obscureText: _isObscureText(),
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.black54),
        prefixIcon: widget.prefixIcon,
        suffixIcon: suffixIcon(),
      ),
    );
  }

  List<TextInputFormatter>? checkJustNumbers() {
    if (widget.justNumbers) {
      return [FilteringTextInputFormatter.digitsOnly];
    }
    return null;
  }

  bool _isObscureText() {
    if (widget.type == TextInputType.visiblePassword) {
      return isHidden;
    } else {
      return false;
    }
  }

  Widget? suffixIcon() {
    if (widget.type == TextInputType.visiblePassword) {
      return IconButton(
        splashColor: Colors.transparent,
        onPressed: () {
          setState(() {
            isHidden = !isHidden;
          });
        },
        icon: Icon(
          isHidden ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey,
        ),
      );
    } else {
      return null;
    }
  }
}
