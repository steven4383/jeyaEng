import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jeya_engineering/enum.dart';
import 'package:jeya_engineering/widgets/utilities.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox(
      {Key? key,
      this.onTap,
      this.readOnly = false,
      this.controller,
      this.hintText,
      this.validator,
      this.onChanged,
      this.trailing,
      this.maxConstraints,
      this.maxLines,
      this.suffixicon})
      : super(key: key);

  final Function()? onTap;
  final bool readOnly;
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? trailing;
  final int? maxLines;
  final Widget? suffixicon;

  final bool? maxConstraints;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getWidth(context)*0.25,

      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(hintText ?? ''),
        ),
        trailing: trailing,
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            maxLines: maxLines,
            onChanged: onChanged,
            validator: validator,
            onTap: onTap,
            readOnly: readOnly,
            controller: controller,
            decoration: InputDecoration(
                suffixIcon: suffixicon,
                fillColor: Colors.white,
                hintText: hintText,
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
                errorBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)), borderSide: BorderSide(color: Colors.red))),
          ),
        ),
      ),
    );
  }
}

class TypeAhead extends StatelessWidget {
  const TypeAhead(
      {Key? key,
      this.onSelected,
      required this.optionsBuilder,
      required this.title,
      this.text,
      this.optionsViewBuilder,
      this.validator,
      this.onChanged})
      : super(key: key);

  final void Function(String)? onSelected;
  final FutureOr<Iterable<String>> Function(TextEditingValue) optionsBuilder;
  final String title;
  final String? text;
  final Widget Function(BuildContext, void Function(String), Iterable<String>)? optionsViewBuilder;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(title),
      ),
      subtitle: Card(
        color: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey,
        child: Autocomplete<String>(
          initialValue: TextEditingValue(text: text ?? ''),
          optionsBuilder: optionsBuilder,
          onSelected: onSelected,
          optionsViewBuilder: optionsViewBuilder,
          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: textEditingController,
              onChanged: onChanged,
              validator: validator,
              focusNode: focusNode,
              decoration: InputDecoration(
                  hintText: title,
                  contentPadding: const EdgeInsets.only(left: 8),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  errorBorder:
                      const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)), borderSide: BorderSide(color: Colors.red))),
            );
          },
        ),
      ),
    );
  }
}
