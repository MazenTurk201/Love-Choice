// ignore_for_file: unused_element

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/db_helper.dart';
import '../screens/home.dart';
import '../main.dart';

Color textColor = Color.fromARGB(255, 248, 206, 255);
Color appBarColor = Color.fromARGB(255, 55, 0, 255);
TextStyle iconTextS = TextStyle(
  fontFamily: "TurkFont",
  color: textColor,
  fontSize: 15,
);

class TurkAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String tablee;

  const TurkAppBar({super.key, required this.tablee});

  @override
  State<TurkAppBar> createState() => _TurkAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _TurkAppBarState extends State<TurkAppBar> {
  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void deleteUser(String index) async {
    await DBHelper.deleteUser(widget.tablee, index);
    loadUsers();
  }

  void loadUsers() async {
    final data = await DBHelper.getUsers(widget.tablee);
    setState(() => users = data);
  }

  void addUser(String quiz, String dare) async {
    // final quiz = first_input.text.trim();
    await DBHelper.insertUser(widget.tablee, quiz, dare);
    clearFields();
    loadUsers();
  }

  void editUser(String quiz, String dare, int index) async {
    await DBHelper.updateUser(widget.tablee, quiz, dare, index);
    clearFields();
    loadUsers();
  }

  Future<Map<String, dynamic>?> geteditUser(int index) async {
    Map<String, dynamic>? data = await DBHelper.getupdateUser(
      widget.tablee,
      index - 1,
    );
    // loadUsers();
    return data;
  }

  void clearFields() {
    add_quiz_input.clear();
    add_dare_input.clear();
    del_quiz_input.clear();
  }

  TextField Input(
    TextEditingController controler,
    TextInputType type,
    String hint,
    String lable,
    bool next_node,
    Function fun,
  ) {
    return TextField(
      keyboardType: type,
      onSubmitted: (value) async {
        if (next_node) {
          TextInputAction.next;
        } else {
          fun();
        }
      },
      cursorColor: Color.fromARGB(255, 55, 0, 255),
      textInputAction: next_node ? TextInputAction.next : TextInputAction.done,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 55, 0, 255),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 55, 0, 255),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        hint: Text(
          hint,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
        label: Text(
          lable,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontFamily: "TurkFont"),
        ),
      ),
      cursorHeight: 30,
      style: TextStyle(fontFamily: "TurkFont"),
      textAlign: TextAlign.center,
      controller: controler,
    );
  }

  List<Map<String, dynamic>> users = [];
  late String userUpdate;
  final first_input = TextEditingController();
  final second_input = TextEditingController();
  TextEditingController add_quiz_input = TextEditingController();
  TextEditingController add_dare_input = TextEditingController();
  TextEditingController del_quiz_input = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/main");
        },
      ),
      title: Text(
        "Love Choice",
        style: TextStyle(
          fontFamily: "TurkLogo",
          fontSize: 35,
          color: Colors.white,
        ),
      ),
      backgroundColor: appBarColor,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => CupertinoAlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(
                                    "اضافة سؤال",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: "TurkFont"),
                                  ),
                                  content: SizedBox(
                                    height: 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Input(
                                            add_quiz_input,
                                            TextInputType.text,
                                            "سؤال؟",
                                            "اكتب السؤال اللي يعجبك",
                                            true,
                                            () {},
                                          ),
                                        ),
                                        Expanded(
                                          child: Input(
                                            add_dare_input,
                                            TextInputType.text,
                                            "التاني؟",
                                            "اكتب الشيء اللي يعجبك",
                                            false,
                                            () {
                                              if (add_dare_input.text
                                                      .trim()
                                                      .isNotEmpty ||
                                                  add_quiz_input.text
                                                      .trim()
                                                      .isNotEmpty) {
                                                addUser(
                                                  add_quiz_input.text.trim(),
                                                  add_dare_input.text.trim(),
                                                );
                                                clearFields();
                                              } else {
                                                clearFields();
                                                add_quiz_input.text = "الرجاء";
                                                add_dare_input.text = "الملئ";
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        clearFields();
                                      },
                                      child: Text("فاكس", style: iconTextS),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (add_dare_input.text
                                                .trim()
                                                .isNotEmpty ||
                                            add_quiz_input.text
                                                .trim()
                                                .isNotEmpty) {
                                          addUser(
                                            add_quiz_input.text.trim(),
                                            add_dare_input.text.trim(),
                                          );
                                          clearFields();
                                        } else {
                                          clearFields();
                                          add_quiz_input.text = "الرجاء";
                                          add_dare_input.text = "الملئ";
                                        }
                                      },
                                      child: Text("ودي", style: iconTextS),
                                    ),
                                  ],
                                  actionsAlignment: MainAxisAlignment.center,
                                ),
                              );
                            },
                            child: Text(
                              "اضافة سؤال",
                              style: iconTextS,
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(
                                    "عرض الكل",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: "TurkFont"),
                                  ),
                                  content: ListView.builder(
                                    itemCount: users.length,
                                    itemBuilder: (_, i) {
                                      final user = users[i];
                                      return Text(
                                        // "${"=" * 10}\n السؤال رقم: ${i + 1}\n\nالسؤال: ${user['choice']}\n\nالتحدي: ${user['dare']}\n${"=" * 10}\n",
                                        "${"=" * 5} ${i + 1} ${"=" * 5}\n\nالسؤال: ${user['choice']}\n\nالتحدي: ${user['dare']}\n\n${"=" * 15}\n",
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.center,
                                      );
                                    },
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "ماثي",
                                        style: TextStyle(
                                          fontFamily: "TurkFont",
                                        ),
                                      ),
                                    ),
                                  ],
                                  actionsAlignment: MainAxisAlignment.center,
                                ),
                              );
                            },
                            child: Text(
                              "عرض الكل",
                              style: iconTextS,
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialogWithState(context);
                            },
                            child: Text(
                              "تعديل سؤال",
                              style: iconTextS,
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(
                                    "طير انت",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: "TurkFont"),
                                  ),
                                  content: Input(
                                    del_quiz_input,
                                    TextInputType.number,
                                    "ID?",
                                    "اكتب ID من عرض الكل",
                                    false,
                                    () {
                                      deleteUser(del_quiz_input.text);
                                      clearFields();
                                    },
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("فاكس", style: iconTextS),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        deleteUser(del_quiz_input.text);
                                        clearFields();
                                      },
                                      child: Text("ودي", style: iconTextS),
                                    ),
                                  ],
                                  actionsAlignment: MainAxisAlignment.center,
                                ),
                              );
                            },
                            child: Text(
                              "حذف سؤال",
                              style: iconTextS,
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    ElevatedButton(
                      onPressed: () {
                        _launchUrl('https://wa.me/+201092130013?text=Hi+Turk');
                      },
                      child: Text(
                        "شاركنا رأيك",
                        style: iconTextS,
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          icon: Icon(Icons.more_vert, color: Colors.white, size: 30),
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  void showDialogWithState(BuildContext context) {
    TextEditingController new_edit_quiz_input = TextEditingController();
    TextEditingController new_edit_dare_input = TextEditingController();
    TextEditingController edit_quiz_input = TextEditingController();
    void onsub() async {
      try {
        Map<String, dynamic>? result = await geteditUser(
          int.parse(edit_quiz_input.text),
        );
        new_edit_quiz_input.text = result?['choice'] ?? '';
        new_edit_dare_input.text = result?['dare'] ?? '';
      } catch (e) {
        null;
      }
    }

    bool editstate = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "لاموءخذة",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: "TurkFont"),
              ),
              content: editstate
                  ? SizedBox(
                      height: 150,
                      child: Column(
                        children: [
                          Expanded(
                            child: Input(
                              new_edit_quiz_input,
                              TextInputType.text,
                              "عدل براحتك",
                              "عدل على شوقك",
                              true,
                              () {},
                            ),
                          ),
                          Expanded(
                            child: Input(
                              new_edit_dare_input,
                              TextInputType.text,
                              "عدل براحتك",
                              "عدل على شوقك",
                              false,
                              () {
                                setState(() {
                                  editUser(
                                    new_edit_quiz_input.text,
                                    new_edit_dare_input.text,
                                    int.parse(edit_quiz_input.text) - 1,
                                  );
                                  edit_quiz_input.clear();
                                  editstate = false;
                                });
                                clearFields();
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Input(
                      edit_quiz_input,
                      TextInputType.number,
                      "ID?",
                      "احذفه رقم السؤال",
                      false,
                      () {
                        setState(() {
                          editstate = true;
                          onsub();
                        });
                        clearFields();
                      },
                    ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("فاكس", style: iconTextS),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (editstate) {
                        editUser(
                          new_edit_quiz_input.text,
                          new_edit_dare_input.text,
                          int.parse(edit_quiz_input.text) - 1,
                        );
                        edit_quiz_input.clear();
                        editstate = false;
                      } else {
                        editstate = true;
                        onsub();
                      }
                    });
                    // editUser(quiz, dare, index)
                    clearFields();
                  },
                  child: Text(editstate ? "ودي" : "هات", style: iconTextS),
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
            );
          },
        );
      },
    );
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch URL: $url');
  }
}
