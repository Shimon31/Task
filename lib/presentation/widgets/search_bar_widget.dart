import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String initialValue;

  const SearchBarWidget({
    super.key,
    required this.onChanged,
    this.initialValue = '',
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          setState(() {}); // rebuild to show/hide clear icon
          widget.onChanged(value);
        },
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon:
          Icon(Icons.search, color: Colors.grey.shade400, size: 20),
          suffixIcon: _controller.text.isNotEmpty
              ? GestureDetector(
            onTap: () {
              _controller.clear();
              widget.onChanged('');
              setState(() {});
            },
            child: Icon(Icons.close,
                color: Colors.grey.shade400, size: 18),
          )
              : null,
        ),
      ),
    );
  }
}