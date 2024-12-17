import 'package:flutter/material.dart';

class IngredientsPopup extends StatelessWidget {
  final Function(List<String>) onFilter;

  const IngredientsPopup({
    required this.onFilter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: const Text('Ingredients'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Enter comma-separated list of ingredients (all must match partially):',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'E.g., rice, chicken, oil',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Parse user input into a list of trimmed, lowercase ingredients
            final inputIngredients = controller.text
                .split(',')
                .map((ingredient) => ingredient.trim().toLowerCase())
                .toList();

            onFilter(inputIngredients); // Pass the list of ingredients back
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
