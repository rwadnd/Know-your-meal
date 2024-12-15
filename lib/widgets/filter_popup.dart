import 'package:flutter/material.dart';

class FilterPopup extends StatefulWidget {
  final Function(List<String>) onApply; // Callback for applying filters

  const FilterPopup({
    required this.onApply,
    super.key,
  });

  @override
  _FilterPopupState createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  final List<String> availableFilters = [
    'vegan',
    'low calorie',
    'gluten-free',
    'lactose-free',
    'high-protein',
    'vegetarian'
  ];

  final Set<String> selectedFilters = {}; // Track selected filters

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filters'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: availableFilters.map((filter) {
          return CheckboxListTile(
            title: Text(filter),
            value: selectedFilters.contains(filter),
            onChanged: (bool? isChecked) {
              setState(() {
                if (isChecked == true) {
                  selectedFilters.add(filter);
                } else {
                  selectedFilters.remove(filter);
                }
              });
            },
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply(
                selectedFilters.toList()); // Pass selected filters back
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
