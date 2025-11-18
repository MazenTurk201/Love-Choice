import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../style/styles.dart';

final supabase = Supabase.instance.client;

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

  Future sendMessage() async {
    if (msgController.text.isEmpty) return;
    await supabase.from('messages').insert({
      'room_id': widget.roomId,
      'sender': userId,
      'text': msgController.text,
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
              ClipOval(
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
            ],
          ),
          body: Column(
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
                          msg["sender"] == userId,
                          context,
                          msg["text"],
                          DateFormat('h:mm a').format(
                            DateTime.parse(
                              msg['created_at'],
                            ).add(Duration(hours: 2)),
                          ),
                          Text(msg["text"]),
                        );
                      },
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: msgController,
                      decoration: InputDecoration(hintText: "Type a message"),
                    ),
                  ),
                  IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
                  IconButton(
                    icon: Icon(Icons.chat_bubble_outline_rounded),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

SizedBox defBubble(
  bool isUser,
  BuildContext context,
  String message,
  String time,
  Widget widget,
) {
  return SizedBox(
    width: double.infinity,
    child: Container(
      margin: const EdgeInsets.all(10),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          // العرض هيكون على قد الكلام لحد 3/4 الشاشة كحد أقصى
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(150, 0, 0, 0), width: 2),
            gradient: isUser
                ? const LinearGradient(
                    colors: [Colors.black, Color.fromARGB(150, 0, 180, 150)],
                  )
                : const LinearGradient(
                    colors: [Color.fromARGB(150, 0, 0, 150), Colors.black],
                  ),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(25),
              topRight: const Radius.circular(25),
              bottomLeft: isUser ? const Radius.circular(25) : Radius.zero,
              bottomRight: !isUser ? const Radius.circular(25) : Radius.zero,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              widget,
              Text(
                time,
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
  );
}
