import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onChange;
  final String? text;
  final bool isFocus;
  final FocusNode? focusNode;

  const SearchWidget({
    super.key,
    this.controller,
    required this.text,
    this.isFocus = false,
    this.focusNode,
    required this.onChange,
  });

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(() {
      setState(() {
        _isSearching = widget.controller?.text.isNotEmpty ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: TextField(
        cursorColor: Theme.of(context).primaryColor,
        controller: widget.controller,
        focusNode: widget.focusNode,
        autofocus: widget.isFocus,
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  color: Colors.grey,
                  onPressed: () {
                    widget.controller?.clear();
                    widget.onChange('');
                    setState(() {
                      _isSearching = false;
                    });
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (text) {
          widget.onChange(text);
          setState(() {
            _isSearching = text.isNotEmpty;
          });
        },
      ),
    );
  }
}
