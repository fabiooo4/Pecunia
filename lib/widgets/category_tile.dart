import 'package:flutter/material.dart';

class CategoryTile extends StatefulWidget {
  const CategoryTile({Key? key, required this.name, required this.onTap})
      : super(key: key);

  final String name;
  final VoidCallback onTap;

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
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

    return GestureDetector(
      onLongPressStart: (LongPressStartDetails details) {
        final RenderBox overlay =
            Overlay.of(context)!.context.findRenderObject() as RenderBox;
        final RenderBox box = context.findRenderObject() as RenderBox;
        final Offset target = box.localToGlobal(Offset.zero);

        final relativePosition = RelativeRect.fromRect(
          Rect.fromPoints(
            details.globalPosition,
            details.globalPosition,
          ),
          Offset.zero & overlay.size,
        );

        showMenu(
          context: context,
          position: relativePosition,
          items: <PopupMenuEntry>[
            PopupMenuItem(
              value: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Edit Category"),
                          content: TextField(
                            decoration: InputDecoration(
                              labelText: "Current name: ${widget.name}",
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
                                print(_nameController.text);
                              },
                              child: const Text("Save"),
                            ),
                          ],
                        );
                      });
                },
                child: const ListTile(
                  leading: Icon(Icons.edit),
                  title: Text("Edit"),
                ),
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Category"),
                          content: Text(
                            "Are you sure you want to delete ${widget.name}?",
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
                                print("Delete ${widget.name}");
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      });
                },
                child: const ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("Delete"),
                ),
              ),
            ),
          ],
        );
      },
      child: Card(
        elevation: 5,
        color: Colors.lightGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.category, color: Colors.white),
            SizedBox(
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
            ),
          ],
        ),
      ),
    );
  }
}
