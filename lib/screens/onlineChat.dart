import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../data/db_helper.dart';
import '../style/styles.dart';

final supabase = Supabase.instance.client;
final TurkUserID = "20120120-2011-2011-2011-201201201201";

enum TurkBubbleType { left, right, center }

class OnlineChatPage extends StatefulWidget {
  final String roomId;
  const OnlineChatPage({super.key, required this.roomId});

  @override
  // ignore: library_private_types_in_public_api
  _OnlineChatPageState createState() => _OnlineChatPageState();
}

class _OnlineChatPageState extends State<OnlineChatPage> {
  // final roomId = widget.roomId; // ثابت لمثال واحد على واحد
  final msgController = TextEditingController();
  final picker = ImagePicker();
  late final userId = supabase.auth.currentUser!.id;
  String? userImageUrl;

  Future TurkMessage(String table) async {
    final data = (await DBHelper.getRandUsers(table)).first;
    await supabase.from('messages').insert({
      'room_id': widget.roomId,
      'sender': TurkUserID,
      // 'text': "السؤال:\n${data["choice"]}\n\nالتحدي:\n${data["dare"]}",
      'text': "السؤال:\n${data["choice"]}",
      'disname': "The Turk",
    });
    setState(() {});
  }

  Future sendMessage() async {
    String disname =
        supabase.auth.currentUser!.userMetadata?['display_name'] ??
        supabase.auth.currentUser!.userMetadata?['name'] ??
        supabase.auth.currentUser!.userMetadata?['full_name'] ??
        supabase.auth.currentUser!.email!.split("@")[0];

    if (msgController.text.isEmpty) return;
    await supabase.from('messages').insert({
      'room_id': widget.roomId,
      'sender': userId,
      'text': msgController.text,
      'disname': disname,
    });
    msgController.clear();
    setState(() {});
  }

  Stream<List<Map<String, dynamic>>> messagesStream() {
    return supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', widget.roomId)
        .order('created_at')
        .map((rows) {
          return rows.map<Map<String, dynamic>>((row) {
            return Map<String, dynamic>.from(row as Map);
          }).toList();
        });
  }

  Future pickAvatar() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);

      final storagePath =
          'avatars/${supabase.auth.currentUser!.email!.split("@")[0]}.jpg';

      // رفع الملف
      await supabase.storage.from('avatars').upload(storagePath, file);

      // الحصول على الرابط العام
      final url = supabase.storage.from('avatars').getPublicUrl(storagePath);
      // print("URL → $url");

      // تحديث profile
      await supabase
          .from('profiles')
          .update({'avatar_url': url})
          .eq('id', supabase.auth.currentUser!.id);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    supabase
        .from('profiles')
        .select("avatar_url")
        .eq('username', supabase.auth.currentUser!.email as Object)
        .then((value) {
          setState(() {
            userImageUrl = value[0]['avatar_url'];
          });
          // userImageUrl = value[0]['avatar_url'];
          // print("USER IMAGE URL → $userImageUrl");
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, "/onlineHome");
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/onlineHome");
                // supabase.auth.signOut();
              },
            ),
            centerTitle: true,
            backgroundColor: TurkStyle().mainColor,
            title: Text("Chat Room"),
            actions: [
              PopupMenuButton<String>(
                color: TurkStyle().hoverColor.withOpacity(0.7), // خلفية المنيو
                onSelected: (value) {
                  if (value == 'settings') {
                    //
                  } else if (value == 'report') {
                    //
                  } else if (value == 'delete') {
                    //
                  } else if (value == 'share') {
                    SharePlus.instance.share(
                      ShareParams(
                        text:
                            "تعال الروم بتاعنا\nhttps://mazenturk201.github.io/Love-Choice/invite/?roomid=${widget.roomId}",
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings_rounded, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Settings", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'contacts',
                    child: Row(
                      children: [
                        Icon(Icons.pest_control, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Contacts", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'website',
                    child: Row(
                      children: [
                        Icon(Icons.insert_link_rounded, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Website", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share_rounded, color: Colors.white),
                        SizedBox(width: 8),
                        Text("share", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: ClipOval(
                    child: Image.network(
                      userImageUrl ?? "",
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) {
                        return IconButton(
                          icon: Icon(Icons.account_circle, size: 40),
                          onPressed: pickAvatar,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Positioned(
                child: Image.asset("images/main2.jpg", fit: BoxFit.cover),
              ),
              Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: messagesStream(),
                      builder: (context, snapshot) {
                        // print("DATA FROM STREAM → ${snapshot.data}");

                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final messages = snapshot.data!;

                        return ListView.builder(
                          reverse: true,
                          scrollDirection: Axis.vertical,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final msg = messages[index];

                            // print("ROW → $msg (${msg.runtimeType})");

                            // return Text("${msg.toString()} \n");
                            return defBubble(
                              msg["sender"] == userId
                                  ? TurkBubbleType.right
                                  : msg["sender"] == TurkUserID
                                  ? TurkBubbleType.center
                                  : TurkBubbleType.left,
                              context,
                              msg["id"],
                              DateFormat('h:mm a').format(
                                DateTime.parse(
                                  msg['created_at'],
                                ).add(Duration(hours: 2)),
                              ),
                              msg["disname"].toString(),
                              Text(
                                msg["text"],
                                style: TextStyle(color: Colors.white),
                                textAlign: msg["sender"] == userId
                                    ? TextAlign.right
                                    : msg["sender"] == TurkUserID
                                    ? TextAlign.center
                                    : TextAlign.left,
                                textDirection: TextUtils.getTextDirection(
                                  msg["text"],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        InkWell(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  AlertDialog(title: Text("اختار الداتا")),
                            );
                          },
                          onTap: () => TurkMessage("bestat_choices"),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.transparent,
                            foregroundImage: AssetImage(
                              "images/ic_launcher.png",
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            textAlign: TextAlign.right,
                            controller: msgController,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: TurkStyle().turkFont,
                            ),
                            cursorColor: TurkStyle().hoverColor,
                            decoration: InputDecoration(
                              hintText: "اكتب رسالتك هنا...",
                              hintTextDirection: TextUtils.getTextDirection(
                                "اكتب رسالتك هنا...",
                              ),
                              alignLabelWithHint: true,
                              // hintTextDirection: TextDirection.rtl,
                              hintStyle: TextStyle(
                                fontFamily: TurkStyle().turkFont,
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onSubmitted: (value) => sendMessage(),
                            textInputAction: TextInputAction.newline,
                            maxLines: null,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            // textDirection: TextDirection.rtl,
                            textDirection: TextUtils.getTextDirection(
                              "اكتب رسالتك هنا...",
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: TurkStyle().textColor2),
                          onPressed: sendMessage,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

SizedBox defBubble(
  TurkBubbleType isUser,
  BuildContext context,
  String messageid,
  String time,
  String disname,
  Widget widget,
) {
  return SizedBox(
    width: double.infinity,
    child: GestureDetector(
      onLongPress: () {
        if (isUser == TurkBubbleType.right) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("حذف الرسالة؟"),
              actions: [
                TextButton(
                  onPressed: () async {
                    await supabase
                        .from('messages')
                        .delete()
                        .eq("id", messageid);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                  child: Text("حذف"),
                ),
              ],
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        alignment: isUser == TurkBubbleType.right
            ? Alignment.centerRight
            : isUser == TurkBubbleType.left
            ? Alignment.centerLeft
            : Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            // العرض هيكون على قد الكلام لحد 3/4 الشاشة كحد أقصى
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(150, 0, 0, 0), width: 2),
              gradient: isUser == TurkBubbleType.right
                  ? const LinearGradient(
                      colors: [Colors.black, Color.fromARGB(150, 150, 0, 0)],
                    )
                  : isUser == TurkBubbleType.center
                  ? const LinearGradient(
                      colors: [
                        Color.fromARGB(150, 255, 0, 0),
                        Color.fromARGB(150, 255, 247, 0),
                      ],
                    )
                  : const LinearGradient(
                      colors: [Color.fromARGB(150, 0, 0, 150), Colors.black],
                    ),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(25),
                topRight: const Radius.circular(25),
                bottomLeft: isUser == TurkBubbleType.left
                    ? Radius.zero
                    : const Radius.circular(25),
                bottomRight: isUser == TurkBubbleType.right
                    ? Radius.zero
                    : const Radius.circular(25),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                widget,
                Text(
                  "$disname $time",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: TurkStyle().turkFont,
                    fontSize: 10,
                    color: Colors.white70,
                    shadows: const [
                      Shadow(
                        color: Colors.black,
                        offset: Offset.zero,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
