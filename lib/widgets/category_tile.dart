import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/categories/categories_provider.dart';
import '../model/transactions/transactions_provider.dart';

class CategoryTile extends ConsumerStatefulWidget {
  const CategoryTile(
      {Key? key,
      required this.id,
      required this.name,
      required this.icon,
      required this.onTap})
      : super(key: key);

  final String id;
  final String name;
  final String icon;
  final VoidCallback onTap;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryTileState();
}

class _CategoryTileState extends ConsumerState<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    @override
    void initState() {
      nameController.addListener(() => setState(() {}));

      super.initState();
    }

    @override
    void dispose() {
      nameController.dispose();

      super.dispose();
    }

    return GestureDetector(
      onLongPressStart: (LongPressStartDetails details) {
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
                          title: Text(
                            // name from widget
                            'Edit "${widget.name}"',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF072E08),
                            ),
                          ),
                          content: TextField(
                            decoration: InputDecoration(
                              labelText: widget.name,
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                            ),
                            controller: nameController,
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
                                print(nameController.text);
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
                          title: Text(
                            'Delete "${widget.name}"',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF072E08),
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Are you sure you want to delete "${widget.name}"?',
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'All transactions under this category will be assigned an empty category.',
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'This action cannot be reversed!',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
                                Navigator.pop(context);
                                deleteCategory(widget.id);
                                ref.invalidate(categoriesProvider);
                                ref.invalidate(transactionsProvider);
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
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
        elevation: 0,
        color: const Color.fromARGB(100, 139, 195, 74),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != '') ...[
              Text(
                widget.icon,
                style: const TextStyle(
                    color: Color(0xFF072E08),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      color: Color(0xFF072E08),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ] else ...[
              SizedBox(
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    color: Color(0xFF072E08),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> deleteCategory(String id) async {
    await Supabase.instance.client
        .from('categories')
        .delete()
        .match({'id': id});
  }
}
