import 'form_field_controller.dart';
import 'package:flutter/material.dart';
import 'flutter_flow_widgets.dart';

class FlutterFlowRadioButton extends StatefulWidget {
  const FlutterFlowRadioButton({
    super.key,
    required this.options,
    required this.onChanged,
    required this.controller,
    required this.optionHeight,
    required this.textStyle,
    this.optionWidth,
    this.selectedTextStyle,
    this.textPadding = EdgeInsets.zero,
    this.buttonPosition = RadioButtonPosition.left,
    this.direction = Axis.vertical,
    required this.radioButtonColor,
    this.inactiveRadioButtonColor,
    this.toggleable = false,
    this.horizontalAlignment = WrapAlignment.start,
    this.verticalAlignment = WrapCrossAlignment.start,
    this.focusBorder,
    this.focusBorderRadius,
    this.focusBorderPadding,
  });

  final List<String> options;
  final Function(String?)? onChanged;
  final FormFieldController<String> controller;
  final double optionHeight;
  final double? optionWidth;
  final TextStyle textStyle;
  final TextStyle? selectedTextStyle;
  final EdgeInsetsGeometry textPadding;
  final RadioButtonPosition buttonPosition;
  final Axis direction;
  final Color radioButtonColor;
  final Color? inactiveRadioButtonColor;
  final bool toggleable;
  final WrapAlignment horizontalAlignment;
  final WrapCrossAlignment verticalAlignment;
  final Border? focusBorder;
  final BorderRadius? focusBorderRadius;
  final EdgeInsetsGeometry? focusBorderPadding;

  @override
  State<FlutterFlowRadioButton> createState() => _FlutterFlowRadioButtonState();
}

class _FlutterFlowRadioButtonState extends State<FlutterFlowRadioButton> {
  bool get enabled => widget.onChanged != null;
  FormFieldController<String> get controller => widget.controller;
  void Function()? _listener;

  @override
  void initState() {
    super.initState();
    _maybeSetOnChangedListener();
  }

  @override
  void dispose() {
    _maybeRemoveOnChangedListener();
    super.dispose();
  }

  @override
  void didUpdateWidget(FlutterFlowRadioButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldWidgetEnabled = oldWidget.onChanged != null;
    if (oldWidgetEnabled != enabled) {
      _maybeRemoveOnChangedListener();
      _maybeSetOnChangedListener();
    }
  }

  void _maybeSetOnChangedListener() {
    if (enabled) {
      _listener = () => widget.onChanged!(controller.value);
      controller.addListener(_listener!);
    }
  }

  void _maybeRemoveOnChangedListener() {
    if (_listener != null) {
      controller.removeListener(_listener!);
      _listener = null;
    }
  }

  List<String> get effectiveOptions =>
      widget.options.isEmpty ? ['[Option]'] : widget.options;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<String>.builder(
      direction: widget.direction,
      groupValue: controller.value,
      onChanged: enabled ? (value) => controller.value = value : null,
      activeColor: widget.radioButtonColor,
      inactiveColor: widget.inactiveRadioButtonColor,
      toggleable: widget.toggleable,
      textStyle: widget.textStyle,
      selectedTextStyle: widget.selectedTextStyle ?? widget.textStyle,
      textPadding: widget.textPadding,
      optionHeight: widget.optionHeight,
      optionWidth: widget.optionWidth,
      horizontalAlignment: widget.horizontalAlignment,
      verticalAlignment: widget.verticalAlignment,
      items: effectiveOptions,
      itemBuilder: (item) =>
          RadioButtonBuilder(item, buttonPosition: widget.buttonPosition),
      focusBorder: widget.focusBorder,
      focusBorderRadius: widget.focusBorderRadius,
      focusBorderPadding: widget.focusBorderPadding,
    );
  }
}

enum RadioButtonPosition {
  right,
  left,
}

class RadioButtonBuilder<T> {
  RadioButtonBuilder(
    this.description, {
    this.buttonPosition = RadioButtonPosition.left,
  });

  final String description;
  final RadioButtonPosition buttonPosition;
}

class RadioButton<T> extends StatelessWidget {
  const RadioButton({
    super.key,
    required this.description,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.buttonPosition,
    required this.activeColor,
    this.inactiveColor,
    required this.toggleable,
    required this.textStyle,
    required this.selectedTextStyle,
    required this.textPadding,
    this.shouldFlex = false,
    this.focusBorder,
    this.focusBorderRadius,
    this.focusBorderPadding,
  });

  final String description;
  final T value;
  final T? groupValue;
  final void Function(T?)? onChanged;
  final RadioButtonPosition buttonPosition;
  final Color activeColor;
  final Color? inactiveColor;
  final bool toggleable;
  final TextStyle textStyle;
  final TextStyle selectedTextStyle;
  final EdgeInsetsGeometry textPadding;
  final bool shouldFlex;
  final Border? focusBorder;
  final BorderRadius? focusBorderRadius;
  final EdgeInsetsGeometry? focusBorderPadding;

  @override
  Widget build(BuildContext context) {
    final selectedStyle = selectedTextStyle;
    final isSelected = value == groupValue;
    
    Widget radioIcon = Icon(
      isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
      color: isSelected ? activeColor : (inactiveColor ?? Colors.grey),
      size: 24,
    );

    Widget radioButtonText = Padding(
      padding: textPadding,
      child: Text(
        description,
        style: isSelected ? selectedStyle : textStyle,
      ),
    );
    
    if (shouldFlex) {
      radioButtonText = Flexible(child: radioButtonText);
    }

    Widget radioButton = InkWell(

      borderRadius: BorderRadius.circular(20), 
      onTap: onChanged != null 
        ? () {
            if (toggleable && isSelected) {
              onChanged!(null);
            } else {
              onChanged!(value);
            }
          } 
        : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (buttonPosition == RadioButtonPosition.right) ...[
             radioButtonText,
             const SizedBox(width: 8),
          ],
          
          radioIcon, 
          
          if (buttonPosition == RadioButtonPosition.left) ...[
             const SizedBox(width: 8),
             radioButtonText,
          ],
        ],
      ),
    );

    if (focusBorder != null ||
        focusBorderRadius != null ||
        focusBorderPadding != null) {
      return FFFocusIndicator(
        border: focusBorder,
        borderRadius: focusBorderRadius,
        padding: focusBorderPadding,
        child: radioButton,
      );
    }

    return radioButton;
  }
}

class RadioGroup<T> extends StatelessWidget {
  const RadioGroup.builder({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.items,
    required this.itemBuilder,
    required this.direction,
    required this.optionHeight,
    required this.horizontalAlignment,
    required this.activeColor,
    this.inactiveColor,
    required this.toggleable,
    required this.textStyle,
    required this.selectedTextStyle,
    required this.textPadding,
    this.optionWidth,
    this.verticalAlignment = WrapCrossAlignment.center,
    this.focusBorder,
    this.focusBorderRadius,
    this.focusBorderPadding,
  });

  final T? groupValue;
  final List<T> items;
  final RadioButtonBuilder Function(T value) itemBuilder;
  final void Function(T?)? onChanged;
  final Axis direction;
  final double optionHeight;
  final double? optionWidth;
  final WrapAlignment horizontalAlignment;
  final WrapCrossAlignment verticalAlignment;
  final Color activeColor;
  final Color? inactiveColor;
  final bool toggleable;
  final TextStyle textStyle;
  final TextStyle selectedTextStyle;
  final EdgeInsetsGeometry textPadding;
  final Border? focusBorder;
  final BorderRadius? focusBorderRadius;
  final EdgeInsetsGeometry? focusBorderPadding;

  List<Widget> get _group => items.map(
        (item) {
          final radioButtonBuilder = itemBuilder(item);
          return SizedBox(
            height: optionHeight,
            width: optionWidth,
            child: RadioButton(
              description: radioButtonBuilder.description,
              value: item,
              groupValue: groupValue,
              onChanged: onChanged,
              buttonPosition: radioButtonBuilder.buttonPosition,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              toggleable: toggleable,
              textStyle: textStyle,
              selectedTextStyle: selectedTextStyle,
              textPadding: textPadding,
              shouldFlex: optionWidth != null,
              focusBorder: focusBorder,
              focusBorderRadius: focusBorderRadius,
              focusBorderPadding: focusBorderPadding,
            ),
          );
        },
      ).toList();

  @override
  Widget build(BuildContext context) => direction == Axis.horizontal
      ? Wrap(
          direction: direction,
          alignment: horizontalAlignment,
          children: _group,
        )
      : Wrap(
          direction: direction,
          crossAxisAlignment: verticalAlignment,
          children: _group,
        );
}