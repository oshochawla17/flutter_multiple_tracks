import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class ClickableText extends StatefulWidget {
  final int number;
  final int min, max;
  final Function(String) onValueChanged;
  final String Function(String) formatText;
  const ClickableText(
      {super.key,
      required this.number,
      required this.onValueChanged,
      required this.formatText,
      required this.min,
      required this.max});

  @override
  State<ClickableText> createState() => _ClickableTextState();
}

class _ClickableTextState extends State<ClickableText> {
  bool _isEditing = false;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController =
        TextEditingController(text: widget.number.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      // width: 100,
      height: 30,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isEditing = true;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: _isEditing ? _buildEditableText() : _buildText(),
      ),
    );
  }

  Widget _buildText() {
    return Center(
      child: Text(
        widget.formatText(widget.number.toString()),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEditableText() {
    return TextFormField(
      inputFormatters: const [
        PitchInputFormatter(
          decimalRange: 2,
        ),
      ],
      textInputAction: TextInputAction.done,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: true),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      controller: _textEditingController,
      autofocus: true,
      onFieldSubmitted: (value) {
        setState(() {
          _isEditing = false;
          widget.onValueChanged(value);
          var tryParse = num.tryParse(value);
          if (tryParse != null) {
            if (tryParse < widget.min) {
              _textEditingController.text = widget.min.toString();
            } else if (tryParse > widget.max) {
              _textEditingController.text = widget.max.toString();
            }
          }
        });
      },
      onEditingComplete: () {
        setState(() {
          _isEditing = false;
          widget.onValueChanged(_textEditingController.text);
        });
      },
    );
  }
}

class PitchInputFormatter extends TextInputFormatter {
  const PitchInputFormatter({
    required this.decimalRange,
  });

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    // Remove non-numeric characters from the input
    final numericRegex = RegExp(r'^-?(\d+)?\.?(\d{0,2})?$');
    if (!numericRegex.hasMatch(truncated)) {
      // If the input contains non-numeric characters, revert to the previous value
      return oldValue;
    }

    String value = newValue.text;

    // Check if the value exceeds the maximum allowed value

    // Check for the decimal point and limit the decimal digits
    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}
