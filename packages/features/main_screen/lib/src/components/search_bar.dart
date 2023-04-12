import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.text,
    // required this.onChanged
  }) : super(key: key);
  final TextEditingController controller;
  final FocusNode focusNode;
  final String text;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: TextField(
        controller: widget.controller,
        // focusNode: widget.focusNode,
        autofocus: false,
        onChanged: (val) {
          setState(() {});
        },
        decoration: InputDecoration(
            hintText: 'Search...',
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      // FocusScope.of(context).requestFocus(widget.focusNode);
                      setState(() {
                        widget.controller.clear();
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            filled: false),
      ),
    );
  }
}
