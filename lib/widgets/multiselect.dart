// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class _TheState {}

var _theState = RM.inject(() => _TheState());

class _SelectRow extends StatelessWidget {
  final Function(bool) onChange;
  final bool selected;
  final String text;

  const _SelectRow(
      {Key? key,
      required this.onChange,
      required this.selected,
      required this.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onChange(!selected);
        _theState.notify();
      },
      leading: Checkbox(
          value: selected,
          onChanged: (x) {
            onChange(x!);
            _theState.notify();
          }),
      title: Text(text),
    );
  }
}

///
/// A Dropdown multiselect menu
///
///
class MultiSelect<T> extends StatefulWidget {
  /// The options form which a user can select
  final List<T> options;

  /// Selected Values
  final List<T> selectedValues;

  /// This function is called whenever a value changes
  final Function(List<T>) onChanged;

  /// defines whether the field is dense
  final bool isDense;

  /// defines whether the widget is enabled;
  final bool enabled;

  /// Input decoration
  final InputDecoration? decoration;

  /// this text is shown when there is no selection
  final String? whenEmpty;

  ///Empty Value
  final T empty;

  /// a function to build custom childern
  final Widget Function(List<T?> selectedValues)? childBuilder;

  /// a function to build custom menu items
  final Widget Function(T? option)? menuItembuilder;

  const MultiSelect({
    Key? key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    required this.whenEmpty,
    this.childBuilder,
    this.menuItembuilder,
    this.isDense = false,
    this.enabled = true,
    this.decoration,
    required this.empty,
  }) : super(key: key);
  @override
  _MultiSelectState createState() => _MultiSelectState<T>();
}

class _MultiSelectState<T> extends State<MultiSelect<T>> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          _theState.rebuilder(() => widget.childBuilder != null
              ? widget.childBuilder!(widget.selectedValues)
              : Align(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: Text(
                        ((widget.selectedValues.length == widget.options.length)
                                ? "All"
                                : widget.selectedValues.length.toString()) +
                            " selected"),
                  ),
                  alignment: Alignment.centerLeft)),
          Align(
            alignment: Alignment.centerLeft,
            child: DropdownButtonFormField<T>(
              isExpanded: true,
              alignment: Alignment.bottomCenter,
              decoration: widget.decoration ??
                  InputDecoration(
                    fillColor:
                        widget.enabled ? Colors.white : Colors.grey.shade200,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                  ),
              isDense: true,
              onChanged: widget.enabled ? (x) {} : null,
              value: null,
              selectedItemBuilder: (context) {
                return widget.options
                    .map((e) => DropdownMenuItem<T>(
                          child: Container(),
                        ))
                    .toList();
              },
              items: getMenu(),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<T>> getMenu() {
    var list = widget.options
        .map((x) => DropdownMenuItem<T>(
              enabled: false,
              child: _theState.rebuilder(() {
                return _SelectRow(
                  selected: widget.selectedValues.contains(x),
                  text: x.toString(),
                  onChange: (isSelected) {
                    if (isSelected) {
                      var ns = widget.selectedValues;
                      ns.add(x);
                      widget.onChanged(ns);
                    } else {
                      var ns = widget.selectedValues;
                      ns.remove(x);
                      widget.onChanged(ns);
                    }
                  },
                );
              }),
              value: x,
              onTap: () {},
            ))
        .toList();
    list.insert(
        0,
        DropdownMenuItem<T>(
          child: _theState.rebuilder(() {
            return _SelectRow(
              selected: widget.selectedValues.length == widget.options.length,
              text: "ALL",
              onChange: (isSelected) {
                if (isSelected) {
                  var ns = widget.selectedValues;
                  ns.clear();
                  ns.addAll(widget.options);
                  widget.onChanged(ns);
                } else {
                  var ns = widget.selectedValues;
                  ns.clear();
                  widget.onChanged(ns);
                }
              },
            );
          }),
          enabled: false,
          value: widget.empty,
          onTap: null,
        ));
    return list;
  }
}
