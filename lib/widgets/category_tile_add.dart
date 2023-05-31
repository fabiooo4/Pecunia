import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class CategoryTileAdd extends StatefulWidget {
  const CategoryTileAdd({Key? key, required this.onTap}) : super(key: key);

  final VoidCallback onTap;

  @override
  State<CategoryTileAdd> createState() => _CategoryTileAddState();
}

class _CategoryTileAddState extends State<CategoryTileAdd> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _iconController = TextEditingController();

  String defaultEmoji = "😀";

  @override
  void initState() {
    _nameController.addListener(() => setState(() {}));
    _iconController.addListener(() => setState(() {}));

    _iconController.text = defaultEmoji;

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
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text("Add Category"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: 'Category Name',
                              labelStyle: const TextStyle(color: Colors.black),
                              prefixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: IconButton(
                                      onPressed: () {
                                        emojiPicker(setState);
                                      },
                                      icon: Text(
                                        _iconController.text,
                                        style: const TextStyle(fontSize: 20),
                                      )))),
                          controller: _nameController,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _nameController.clear();
                          _iconController.text = defaultEmoji;
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          print("Add ${_nameController.text}");
                          _nameController.clear();
                          _iconController.text = defaultEmoji;
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
}
