import 'package:flutter/material.dart';

class CategoryTile extends StatefulWidget {
  const CategoryTile({Key? key, required this.name, required this.onTap})
      : super(key: key);

  final String name;
  final VoidCallback onTap;

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
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
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.lightGreen,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Edit Category"),
                        content: TextField(
                          decoration: InputDecoration(
                            labelText: "Category Name",
                            hintText: "Current Category Name: ${widget.name}",
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
                              print("Edit ${widget.name}");
                            },
                            child: const Text("Edit"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Icon(Icons.edit,
                      color: Color.fromARGB(255, 7, 46, 8)),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text("Delete Category"),
                              content: const Text(
                                  "Are you sure you want to delete this category?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    print("Delete ${widget.name}");
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            ));
                  },
                  child: const Icon(Icons.delete,
                      color: Color.fromARGB(255, 196, 0, 0)),
                ),
                const SizedBox(width: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
