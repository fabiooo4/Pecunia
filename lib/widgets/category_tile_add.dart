import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:pecunia/model/categories/categories_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryTileAdd extends ConsumerStatefulWidget {
  const CategoryTileAdd({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoryTileAddState();
}

class _CategoryTileAddState extends ConsumerState<ConsumerStatefulWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _iconController = TextEditingController();

  @override
  void initState() {
    _nameController.addListener(() => setState(() {}));
    _iconController.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _iconController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text(
                      "Add Category",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF072E08),
                      ),
                    ),
                    content: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: IconButton(
                            iconSize: 30,
                            padding: const EdgeInsets.all(15),
                            onPressed: () {
                              emojiPicker(setState);
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: const BorderSide(color: Colors.black26),
                                ),
                              ),
                            ),
                            icon: _iconController.text.isEmpty
                                ? const Icon(
                                    Icons.emoji_emotions,
                                    color: Colors.black54,
                                  )
                                : Text(
                                    _iconController.text,
                                    style: const TextStyle(fontSize: 25),
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextField(
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                              labelText: 'Category Name',
                              labelStyle: TextStyle(color: Color(0xFF072E08)),
                            ),
                            controller: _nameController,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _nameController.clear();
                          _iconController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          addCategory();
                          _nameController.clear();
                          _iconController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text("Add"),
                      ),
                    ],
                  );
                },
              );
            });
      },
      child: Card(
        elevation: 5,
        color: const Color.fromARGB(255, 142, 142, 142),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white),
          ],
        ),
      ),
    );
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
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _iconController.text = emoji.emoji;
                    });
                    Navigator.pop(context);
                  },
                  textEditingController: _iconController,
                  config: const Config(
                    columns: 7,
                    // Issue: https://github.com/flutter/flutter/issues/28894
                    emojiSizeMax: 20,
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
                    replaceEmojiOnLimitExceed: false,
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
        });
  }

  Future<void> addCategory() async {
    await Supabase.instance.client.from('categories').insert([
      {
        'user_id': Supabase.instance.client.auth.currentUser!.id,
        'name': _nameController.text,
        'icon': _iconController.text,
        'created_at': DateTime.now().toIso8601String(),
      }
    ]).then((value) {
      // ignore: unused_result
      ref.refresh(categoriesProvider);
    }).catchError((error) {
      print(error);
    });
  }
}
