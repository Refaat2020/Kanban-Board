import 'package:kanban_board/file_export.dart';

class RegularTextField extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final bool protectedText;
  final bool noBorder;
  final Color? fillColor;
  final Color? cursorColor;
  final Color? labelColor;
  final TextStyle? style;
  final TextStyle? styleController;
  final TextStyle? labelStyle;
  final String? Function(String?)? validator;
  final bool description;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final Function? onTap;
  final FocusNode? focusNode;
  final String Function(String?)? onSaved;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autoValidateMode;
  final String Function(String?)? onChange;
  final String? errorMessage;
  final Color? enableBorderColor;
  final double? sizedTitle;
  final bool? valid;
  final EdgeInsetsGeometry? contentPadding;

  const RegularTextField({
    super.key,
    this.keyboardType,
    this.autoValidateMode,
    this.labelStyle,
    this.label,
    this.valid,
    this.styleController,
    this.style,
    this.controller,
    this.textInputAction,
    this.noBorder = false,
    this.fillColor,
    this.cursorColor,
    this.labelColor,
    this.hintText = "Enter data here",
    this.prefix,
    this.suffix,
    this.protectedText = false,
    this.description = false,
    this.inputFormatters,
    this.readOnly = false,
    this.validator,
    this.onTap,
    this.onSaved,
    this.onChange,
    this.errorMessage,
    this.enableBorderColor,
    this.focusNode,
    this.sizedTitle,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      validator: validator,
      controller: controller,
      cursorColor: cursorColor,
      keyboardType: keyboardType,
      obscuringCharacter: "*",
      onTap: onTap as void Function()?,
      obscureText: protectedText,
      maxLines: description ? 5 : 1,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      autovalidateMode: autoValidateMode,
      style: styleController ?? context.textTheme.bodyLarge,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: Text(
          label ?? "",
          style: labelStyle ??
              Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: labelColor ?? AppColors.hintColor,
                    fontSize: 11,
                    height: .1,
                    fontWeight: FontWeight.w500,
                  ),
        ),
        isDense: false,
        filled: fillColor != null,
        contentPadding: contentPadding ?? EdgeInsets.only(bottom: 10, left: 15),
        prefix: prefix,
        suffixIcon: suffix,
        suffixIconConstraints: BoxConstraints(
          maxHeight: 55,
          minHeight: 30,
          maxWidth: 100,
          minWidth: 50,
        ),
        fillColor: fillColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(0),
          ),
          borderSide: BorderSide(
            color: Colors.black,
            width: noBorder ? 0.0 : 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(9),
          ),
          borderSide: BorderSide(
            color: enableBorderColor ?? const Color(0xFFC5CACD),
            width: noBorder ? 0.0 : 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(9),
          ),
          borderSide: BorderSide(
            color: noBorder ? Colors.transparent : Colors.red,
            width: noBorder ? 4.0 : 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(9),
          ),
          borderSide: BorderSide(
            color: noBorder ? Colors.transparent : AppColors.red1,
            width: noBorder ? 4.0 : 2.0,
          ),
        ),
        hintText: hintText,
        hintStyle: style ?? Theme.of(context).textTheme.labelSmall,
        errorText: errorMessage,
        errorMaxLines: 2,
      ),
      onSaved: onSaved,
      onChanged: onChange,
    );
  }
}
