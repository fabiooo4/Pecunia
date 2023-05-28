import 'package:flutter/material.dart';
import 'package:pecunia/model/categories/categories_provider.dart';
import 'package:pecunia/widgets/category_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Categories extends ConsumerStatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends ConsumerState<Categories> {
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
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 7, 46, 8),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: categories.when(
                data: (accountListdata) => accountListdata.length,
                loading: () => 0,
                error: (error, stackTrace) => 0,
              ),
              itemBuilder: (context, index) {
                final category = categories.when(
                  data: (accountListdata) => accountListdata[index],
                  loading: () => null,
                  error: (error, stackTrace) => null,
                );
                return CategoryTile(
                  name: category!.name.toString(),
                  onTap: () {
                    print('Category $category.name tapped');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
