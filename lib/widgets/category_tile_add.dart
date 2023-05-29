import 'package:flutter/material.dart';

class CategoryTileAdd extends StatefulWidget {
  const CategoryTileAdd({Key? key, required this.onTap}) : super(key: key);

  final VoidCallback onTap;

  @override
  State<CategoryTileAdd> createState() => _CategoryTileAddState();
}

class _CategoryTileAddState extends State<CategoryTileAdd> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    _nameController.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Add Category"),
            content: TextField(
              decoration: const InputDecoration(
                labelText: "Category Name",
                hintText: "Enter Category Name",
              ),
              controller: _nameController,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  print("Add ${_nameController.text}");
                },
                child: const Text("Add"),
              ),
            ],
          ),
        );
      },
      child: Card(
        elevation: 5,
        color: const Color.fromARGB(255, 142, 142, 142),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: Colors.white),
            /* SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ), */
          ],
        ),
      ),
    );
  }
}
