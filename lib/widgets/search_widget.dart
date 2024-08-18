import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onChange;
  final String? text;
  final bool isFocus;
  final FocusNode? focusNode;

  const SearchWidget({
    Key? key,
    this.controller,
    required this.text,
    this.isFocus = false,
    this.focusNode,
    required this.onChange, required onChanged,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Add listener to the text controller to update the search state
    widget.controller?.addListener(() {
      setState(() {
        _isSearching = widget.controller?.text.isNotEmpty ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Theme.of(context).primaryColor,
      controller: widget.controller,
      focusNode: widget.focusNode,
      autofocus: widget.isFocus,
      decoration: InputDecoration(
        hintText: "Search",
        hintStyle: TextStyle(
          color: Colors.grey.shade600,
        ),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _isSearching
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  widget.controller!.clear();
                  widget.onChange('');
                  setState(() {
                    _isSearching = false;
                  });
                  FocusScope.of(context).unfocus();
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      onChanged: (text) {
        widget.onChange(text);
        setState(() {
          _isSearching = text.isNotEmpty;
        });
      },
    );
  }
}
