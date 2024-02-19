import 'package:flutter/material.dart';
import 'package:jeya_engineering/enum.dart';
import 'package:jeya_engineering/widgets/utilities.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({Key? key, required this.title, required this.value, this.onChanged, this.color, this.leading, this.subtitle}) : super(key: key);

  final String title;
  final bool value;
  final void Function(bool)? onChanged;
  final Color? color;
  final Widget? leading;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isMobile(context)
            ? getWidth(context) - 32
            : isTablet(context)
                ? (getWidth(context) / 2) - 64
                : getWidth(context) / 4,
      ),
      child: ListTile(
        leading: leading,
        title: Text(title),
        subtitle: subtitle,
        trailing: Switch(


            activeColor: color,
            value: value, onChanged: onChanged),
      ),
    );
  }
}
