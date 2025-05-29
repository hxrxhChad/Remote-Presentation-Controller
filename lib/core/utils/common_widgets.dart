import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonTextFormField extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final String labelText;
  final String? hintText;
  final TextEditingController controller;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool isEnabled;
  final TextInputType keyboardType;
  final IconData? suffixIcon;
  final void Function()? onTap;
  final String? Function(String?)? validator;

  const CommonTextFormField({
    super.key,
    this.margin,
    required this.labelText,
    this.hintText,
    required this.controller,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.isEnabled = true,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.onTap,
    this.validator,
  });

  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isEmpty = widget.controller.text.isEmpty;

    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap:
            widget.onTap ??
            () => FocusScope.of(context).requestFocus(_focusNode),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: double.infinity),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.labelText,
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: widget.controller,
                              focusNode: _focusNode,
                              enabled: widget.isEnabled && widget.onTap == null,
                              maxLines: widget.maxLines,
                              minLines: widget.minLines,
                              maxLength: widget.maxLength,
                              keyboardType: widget.keyboardType,
                              validator: widget.validator,
                              onTap: widget.onTap,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                isCollapsed: true,
                                hintText: isEmpty ? widget.hintText : null,
                                hintStyle: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  right: widget.suffixIcon != null ? 40.w : 0,
                                ),
                              ),
                            ),
                          ),
                          if (widget.suffixIcon != null) ...[
                            SizedBox(width: 20.w),
                            Icon(widget.suffixIcon, size: 20.r),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
