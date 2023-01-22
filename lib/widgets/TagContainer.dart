import 'package:flutter/material.dart';

class TagContainer extends StatefulWidget {
  final String title;
  final List<String> selectedTags;
  bool isSelected;
  bool isFilterItem;
  List<String> selectedFilterTags = [];
  Function updateParentState;
  TagContainer({
    required this.title,
    required this.selectedTags,
    required this.isSelected,
    required this.isFilterItem,
    required this.updateParentState,
    required this.selectedFilterTags,
    Key? key,
  }) : super(key: key);

  @override
  State<TagContainer> createState() => _TagContainerState();
}

class _TagContainerState extends State<TagContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        if (widget.isSelected) {
          widget.isSelected = false;
          widget.selectedTags.remove(widget.title);

          if (widget.isFilterItem) {
            widget.selectedFilterTags.remove(widget.title);
            widget.updateParentState();
          }
        } else {
          widget.isSelected = true;
          widget.selectedTags.add(widget.title);
          if (widget.isFilterItem) {
            widget.selectedFilterTags.add(widget.title);
            widget.updateParentState();
          }
        }
      }),
      child: Container(
        decoration: BoxDecoration(
            color: widget.isSelected ? Colors.green : Colors.grey, borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(widget.title)),
        ),
      ),
    );
  }
}