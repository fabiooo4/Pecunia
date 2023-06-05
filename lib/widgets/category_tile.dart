import 'package:animations/animations.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pecunia/model/categories/category.dart' as categoryModel;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/accounts/accounts_provider.dart';
import '../model/categories/categories_provider.dart';
import '../model/transactions/transactions_provider.dart';
import '../screens/dashboard/category_expenses.dart';

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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController iconController = TextEditingController();

  String? errorMessage;

  @override
  void initState() {
    nameController.addListener(() => setState(() {}));
    iconController.addListener(() => setState(() {}));

    nameController.text = widget.name;
    iconController.text = widget.icon;

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    iconController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionList = ref.watch(transactionsProvider);
    final accountList = ref.watch(accountsProvider);

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
                        return StatefulBuilder(
                          builder: (context, setState) {
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
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height:
                                    MediaQuery.of(context).size.width * 0.18,
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        iconSize: 30,
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () {
                                          emojiPicker(setState);
                                        },
                                        icon: iconController.text.isEmpty
                                            ? const Icon(
                                                Icons.emoji_emotions,
                                                color: Colors.black54,
                                              )
                                            : Text(
                                                iconController.text,
                                                style: const TextStyle(
                                                    fontSize: 25),
                                              ),
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.black26),
                                            ),
                                            border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.black26),
                                            ),
                                            labelText: 'Category Name',
                                            labelStyle: const TextStyle(
                                                color: Color(0xFF072E08)),
                                            errorText: errorMessage,
                                          ),
                                          controller: nameController,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
                                    if (validateName()) {
                                      setState(() {
                                        errorMessage = null;
                                      });
                                      editCategory(
                                          widget.id,
                                          nameController.text,
                                          iconController.text);
                                      ref.invalidate(categoriesProvider);
                                      ref.invalidate(transactionsProvider);
                                      Navigator.pop(context);
                                    } else {
                                      setState(() {
                                        errorMessage = 'Please enter a name';
                                      });
                                    }
                                  },
                                  child: const Text("Save"),
                                ),
                              ],
                            );
                          },
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
      onTap: widget.onTap,
      child: OpenContainer(
        closedElevation: 0,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        transitionDuration: const Duration(milliseconds: 500),
        openBuilder: (context, _) => CategoryTransactions(
          params: CategoryTransactionsParams(
            category: categoryModel.Category(
              id: widget.id,
              name: widget.name,
              icon: widget.icon,
            ),
            transactions: transactionList.when(
              data: (data) => data,
              loading: () => [],
              error: (err, stack) => [],
            ),
            accounts: accountList.when(
              data: (data) => data,
              loading: () => [],
              error: (err, stack) => [],
            ),
          ),
        ),
        closedBuilder: (context, _) {
          return Card(
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
          );
        },
      ),
    );
  }

  Future<void> deleteCategory(String id) async {
    await Supabase.instance.client
        .from('categories')
        .delete()
        .match({'id': id});
  }

  void editCategory(String id, String newName, String icon) async {
    await Supabase.instance.client
        .from('categories')
        .update({'name': newName, 'icon': icon}).match({'id': id});
  }

  void emojiPicker(setState) {
    showModalBottomSheet(
      enableDrag: false,
      context: context,
      barrierColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(0),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.36,
          width: MediaQuery.of(context).size.width,
          child: SizedBox(
              height: 250,
              child: EmojiPicker(
                onBackspacePressed: () {
                  setState(() {
                    iconController.text = '';
                  });
                },
                onEmojiSelected: (category, emoji) {
                  setState(() {
                    iconController.text = emoji.emoji;
                  });
                  Navigator.pop(context);
                },
                textEditingController: iconController,
                config: const Config(
                  columns: 7,
                  // Issue: https://github.com/flutter/flutter/issues/28894
                  emojiSizeMax: 30,
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  gridPadding: EdgeInsets.zero,
                  bgColor: Color(0xFFF2F2F2),
                  indicatorColor: Colors.green,
                  iconColor: Colors.grey,
                  iconColorSelected: Colors.green,
                  backspaceColor: Colors.green,
                  skinToneDialogBgColor: Colors.white,
                  skinToneIndicatorColor: Colors.grey,
                  enableSkinTones: true,
                  categoryIcons: CategoryIcons(),
                  buttonMode: ButtonMode.MATERIAL,
                  showRecentsTab: true,
                  recentsLimit: 28,
                  replaceEmojiOnLimitExceed: true,
                  noRecents: Text(
                    'No Recents',
                    style: TextStyle(fontSize: 20, color: Colors.black26),
                    textAlign: TextAlign.center,
                  ),
                  loadingIndicator: SizedBox.shrink(),
                  tabIndicatorAnimDuration: kTabScrollDuration,
                  checkPlatformCompatibility: true,
                ),
              )),
        );
      },
    );
  }

  bool validateName() {
    if (nameController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
