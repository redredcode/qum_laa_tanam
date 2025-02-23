import 'package:flutter/material.dart';

class CustomSpinBox extends StatefulWidget {
  final double min;
  final double max;
  final double initialValue;
  final Function(double) onChanged; // Callback for value changes
  final int decimals; // Number of decimal places

  const CustomSpinBox({
    super.key,
    required this.min,
    required this.max,
    required this.initialValue,
    required this.onChanged,
    this.decimals = 0, // Default to integer values
  });

  @override
  State<CustomSpinBox> createState() => _CustomSpinBoxState();
}

class _CustomSpinBoxState extends State<CustomSpinBox> {
  late TextEditingController _controller;
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _controller = TextEditingController(text: _formatValue(_currentValue));
  }

  String _formatValue(double value) {
    return value.toStringAsFixed(widget.decimals);
  }

  void _increment() {
    if (_currentValue + 1 <= widget.max) {
      setState(() {
        _currentValue += 1;
        _controller.text = _formatValue(_currentValue);
      });
      widget.onChanged(_currentValue);
    }
  }

  void _decrement() {
    if (_currentValue - 1 >= widget.min) {
      setState(() {
        _currentValue -= 1;
        _controller.text = _formatValue(_currentValue);
      });
      widget.onChanged(_currentValue);
    }
  }

  void _onFieldSubmitted(String value) {
    final parsedValue = double.tryParse(value);
    if (parsedValue != null &&
        parsedValue >= widget.min &&
        parsedValue <= widget.max) {
      setState(() {
        _currentValue = parsedValue;
      });
      widget.onChanged(_currentValue);
    } else {
      _controller.text = _formatValue(_currentValue); // Reset to valid value
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark background color
        border: Border.all(color: Colors.grey[700]!), // Border color
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: Row(
        children: [
          // Text field for displaying and editing the value
          Expanded(
            flex: 3, // Give more space to the text field
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white, // White text
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none, // Remove default borders
                contentPadding: EdgeInsets.symmetric(vertical: 8), // Padding inside text field
              ),
              keyboardType: TextInputType.number,
              onSubmitted: _onFieldSubmitted,
            ),
          ),

          // Up and down arrow buttons
          Expanded(
            flex: 1, // Less space for the buttons
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _increment, // Increment on tap
                  child: const Icon(
                    Icons.arrow_drop_up,
                    size: 20,
                    color: Colors.grey, // Light arrow color
                  ),
                ),
                GestureDetector(
                  onTap: _decrement, // Decrement on tap
                  child: const Icon(
                    Icons.arrow_drop_down,
                    size: 20,
                    color: Colors.grey, // Light arrow color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
