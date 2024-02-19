import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jeya_engineering/widgets/utilities.dart';

import '../enum.dart';

final format = DateFormat.yMd('es');

class QuoteDate extends StatelessWidget {
  const QuoteDate({Key? key, required this.title, this.date, this.onPressed}) : super(key: key);
  final String title;
  final DateTime? date;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 376, maxWidth: 500),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(title),
        ),
        subtitle: Card(
          elevation: 5,
          shadowColor: Colors.grey,
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: Row(
              children: [
                Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(date != null ? format.format(date!) : ''),
                    )),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    onPressed: onPressed,
                    icon: const Icon(Icons.calendar_month_outlined),
                  ),
                ),
              ],
            ),
          ),
        ),
        // trailing: IconButton(onPressed: () {}, icon: Icon(Icons.calendar_month_outlined)),
      ),
    );
  }
}

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
    this.title,
    required this.nullable,
    this.date,
  }) : super(key: key);

  final Function()? onTap;
  final bool readOnly;
  final DateTime? date;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? trailing;
  final void Function()? onPressed;
  final String? title;
  final bool nullable;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getWidth(context)*0.25,

      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(title ?? ''),
        ),
        trailing: trailing,
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: TextEditingController(text: date == null ? ' ' : format.format(date!)),
            onChanged: onChanged,
            validator: (string) {
              if ((!nullable) && date == null) {
                return "Please select a date";
              }
            },
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
                errorBorder:
                    OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(4.0)), borderSide: BorderSide(color: Colors.red))),
          ),
        ),
      ),
    );
  }
}

class CustomDateBox extends StatelessWidget {
  const CustomDateBox(
      {Key? key,
      this.onTap,
      this.readOnly = true,
      this.hintText,
      this.validator,
      this.onChanged,
      this.trailing,
      this.onPressed,
      this.controler,
      this.title})
      : super(key: key);

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
      subtitle: Card(
        color: onPressed == null ? Colors.grey.shade200 : Colors.white,
        elevation: 5,
        shadowColor: Colors.grey,
        child: SizedBox(
          child: TextFormField(
            controller: controler,
            onChanged: onChanged,
            validator: validator,
            onTap: onTap,
            readOnly: readOnly,
            decoration: InputDecoration(
                hintText: hintText,
                contentPadding: const EdgeInsets.only(left: 8, top: 16),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
                errorBorder:
                    const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)), borderSide: BorderSide(color: Colors.red)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_month_outlined),
                  onPressed: onPressed,
                )),
          ),
        ),
      ),
    );
  }
}
