import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onChange;
  final String? text;
  final bool? isFocus;
  final FocusNode? focusNode;

  const SearchWidget(
      {super.key,
      this.controller,
      required this.text,
      this.isFocus,
      this.focusNode,
      required this.onChange, required onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Theme.of(context).primaryColor,
      controller: controller,
      focusNode: focusNode,
      autofocus: isFocus!,
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: Colors.grey.shade100,
        ),
        hintText: "Search",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: text!.isNotEmpty
            ? GestureDetector(
                child: const Icon(Icons.close),
                onTap: () {
                  controller!.clear();
                  onChange('');
                  FocusScope.of(context).requestFocus(
                    FocusNode(),
                  );
                },
              )
            : null,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onChanged: onChange,
    );
  }
}







    //  Padding(
    //   padding: const EdgeInsets.all(18.0),
    //   child: TextField(
    //            // onChanged: (value) => _runFilter(value),
    //             decoration: InputDecoration(
    //               contentPadding:
    //                   const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
    //               hintText: "Search",
    //               suffixIcon: const Icon(Icons.search),
    //               // prefix: Icon(Icons.search),
    //               border: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(20.0),
    //                 borderSide: const BorderSide(),
    //               ),
    //             ),
    //           ),
    // );
 