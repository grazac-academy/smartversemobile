import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final String? prefixIconPath;
  final IconData? prefixIconData;
  final String? suffixIconPath;
  final IconData? suffixIconData;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.prefixIconPath,
    this.prefixIconData,
    this.suffixIconPath,
    this.suffixIconData,
    this.validator,
    this.onChanged,
    this.keyboardType,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _isObscure = true;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Color get _currentColor => _focusNode.hasFocus
      ? AppColors.primary
      : widget.controller.text.isNotEmpty
          ? AppColors.usagePatternContainerText
          : AppColors.grey;

  OutlineInputBorder _buildBorder(Color color, [double width = 1.0]) =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: color, width: width));

  Widget? _buildPrefixIcon(Color color) {
    if (widget.prefixIconPath != null) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: SvgPicture.asset(widget.prefixIconPath!, colorFilter: ColorFilter.mode(color, BlendMode.srcIn), width: 24, height: 24),
      );
    }
    if (widget.prefixIconData != null) return Icon(widget.prefixIconData, color: color);
    return null;
  }

  Widget? _buildSuffixIcon(Color color) {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(_isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: color),
        onPressed: () => setState(() => _isObscure = !_isObscure),
      );
    }
    if (widget.suffixIconPath != null) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: SvgPicture.asset(widget.suffixIconPath!, colorFilter: ColorFilter.mode(color, BlendMode.srcIn), width: 24, height: 24),
      );
    }
    if (widget.suffixIconData != null) return Icon(widget.suffixIconData, color: color);
    return null;
  }


  @override
  Widget build(BuildContext context) {
    final currentColor = _currentColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontSize: 14, color: AppColors.black2)),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.isPassword ? _isObscure : false,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          validator: widget.validator,
          style: const TextStyle(color: AppColors.black),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            prefixIcon: _buildPrefixIcon(currentColor),
            suffixIcon: _buildSuffixIcon(currentColor),
            border: _buildBorder(currentColor),
            enabledBorder: _buildBorder(currentColor),
            focusedBorder: _buildBorder(currentColor, 1.5),
            errorBorder: _buildBorder(Colors.red),
            focusedErrorBorder: _buildBorder(Colors.red, 1.5),
          ),
        ),
      ],
    );
  }
}
