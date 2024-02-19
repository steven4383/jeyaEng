import 'package:flutter/material.dart';
import 'package:jeya_engineering/enum.dart';
import 'package:jeya_engineering/widgets/utilities.dart';

class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown(
      {Key? key, this.items, this.onChanged, this.value, required this.title, this.validator, this.selectedItemBuilder, this.hintText})
      : super(key: key);

  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final T? value;
  final String title;
  final String? Function(T?)? validator;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 376, maxWidth: 500),
      child: ListTile(
        title: Text(title),
        subtitle: Card(
          child: DropdownButtonFormField(
            decoration: const InputDecoration(
              hintText: '',
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
            ),
            validator: validator,
            items: items,
            onChanged: onChanged,
            value: value,
            isExpanded: true,
          ),
        ),
      ),
    );
  }
}

//
class QuoteDropdown<T> extends StatelessWidget {
  const QuoteDropdown(
      {Key? key, this.items, this.onChanged, this.value, required this.title, this.validator, this.selectedItemBuilder, this.hintText, this.expanded})
      : super(key: key);

  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final T? value;
  final String title;
  final String? Function(T?)? validator;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final String? hintText;
  final bool? expanded;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getWidth(context)*0.25,
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(title),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 8),
              filled: true,
              hintText: '',
              border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(4.0))),
            ),
            validator: validator,
            items: items,
            onChanged: onChanged,
            value: value,
            isExpanded: true,
          ),
        ),
      ),
    );
  }
}
