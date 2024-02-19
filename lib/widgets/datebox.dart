import 'package:flutter/material.dart';

class QuoteDateBox extends StatelessWidget {
  QuoteDateBox({
    Key? key,
    this.onTap,
    this.readOnly = true,
    this.hintText,
    this.validator,
    this.onChanged,
    this.trailing,
    this.onPressed,
    this.controler,
    this.title,
  }) : super(key: key);

  final Function()? onTap;
  final bool readOnly;

  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? trailing;
  final void Function()? onPressed;
  final TextEditingController? controler;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(title ?? ''),
      ),
      trailing: trailing,
      subtitle: TextFormField(
        controller: controler,
        onChanged: onChanged,
        validator: validator,
        onTap: onTap,
        readOnly: readOnly,
        decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_month_outlined),
              onPressed: onPressed,
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(4.0))),
            errorBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(4.0)), borderSide: BorderSide(color: Colors.red))),
      ),
    );
  }
}
