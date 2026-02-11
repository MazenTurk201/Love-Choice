import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../data/db_helper.dart';
import '../main.dart';
import '../modules/popMenu.dart';
import '../style/styles.dart';

final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;
final firebaseauth = FirebaseAuth.instance;
final TurkUserID = "20120120-2011-2011-2011-201201201201";

enum TurkBubbleType { left, right, center }

class OnlineChatPage extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String roomBio;
  final String? roomImage;
  const OnlineChatPage({
    super.key,
    required this.roomId,
    required this.roomName,
    required this.roomImage,
    required this.roomBio,
  });

  @override
  // ignore: library_private_types_in_public_api
  _OnlineChatPageState createState() => _OnlineChatPageState();
}

class _OnlineChatPageState extends State<OnlineChatPage> {
  // final roomId = widget.roomId; // ثابت لمثال واحد على واحد
  final msgController = TextEditingController();
  final picker = ImagePicker();
  late final userId = firebaseauth.currentUser!.uid;
  String? userImageUrl;
  String tablee = "ahl_choices";
  List<Map<String, dynamic>> orderItems = [
    {
      "name": "أهل",
      "dis": "التجمع الحلو والقعدة الأحلى",
      "root": "ahl_choices",
    },
    {"name": "شلة", "dis": "يلا بينا نفك الملل", "root": "shella_choices"},
    {"name": "بيستات", "dis": "مين حبيب اخوه؟", "root": "bestat_choices"},
    {"name": "تعارف", "dis": "الصحاب اللي على قلبك", "root": "t3arof_choices"},
    {
      "name": "كابلز",
      "dis": "ايدي ف ايدك نرجع البدايات",
      "root": "couples_choices",
    },
    {"name": "مخطوبين", "dis": "نفهم بعض قبل الجد", "root": "ma5toben_choices"},
  ];

  Future TurkMessage(String table) async {
    table = tablee; // تأكد إنك بتستخدم المتغير اللي بيتغير مش ثابت
    final data = (await DBHelper.getRandUsers(table)).first;

    try {
      await db
          .collection("rooms")
          .doc(widget.roomId)
          .collection("messages")
          .add({
            'sender': TurkUserID, // الـ UID اللي متعرف فوق
            'text': "السؤال:\n${data["choice"]}",
            // 'text': "السؤال:\n${data["choice"]}\n\nالتحدي:\n${data["dare"]}",
            'disname': "The Turk",
            'created_at': FieldValue.serverTimestamp(), // وحدنا الاسم هنا
          });
      msgController.clear();
      setState(() {});
    } catch (e) {
      print("خطأ في الإرسال: $e");
    }
  }

  Future sendMessage() async {
    // FocusScope.of(context).unfocus();
    if (msgController.text.isEmpty) return;
    String disname = user!.displayName ?? user!.email!.split("@")[0];
    try {
      await db
          .collection("rooms")
          .doc(widget.roomId)
          .collection("messages")
          .add({
            'sender': userId, // الـ UID اللي متعرف فوق
            'text': msgController.text.trim(),
            'disname': disname,
            'created_at': FieldValue.serverTimestamp(), // وحدنا الاسم هنا
          });
      msgController.clear();
      setState(() {});
    } catch (e) {
      print("خطأ في الإرسال: $e");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream() {
    return db
        .collection("rooms")
        .doc(widget.roomId)
        .collection("messages")
        .orderBy("created_at", descending: true)
        .snapshots();
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
            title: Hero(
              tag: "name_${widget.roomId}",
              child: Text(widget.roomName),
            ),
            actions: [
              TurkPopMenu(
                popMenuType: TurkPopMenuType.chat,
                id: widget.roomId,
                name: widget.roomName,
                bio: widget.roomBio,
                img: widget.roomImage,
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

                        //                   return ListView(
                        // children: snapshot.data!.docs.map((doc) {
                        //   final data = doc.data() as Map<String, dynamic>;
                        //   return ListTile(
                        //     title: Text(data["disname"]),
                        //     subtitle: Text(data["text"]),
                        //   );
                        // }).toList(),

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          reverse: true,
                          itemCount: messages.size,
                          itemBuilder: (context, index) {
                            final doc =
                                messages.docs[index]; // هنجيب الـ Document نفسه
                            final msg = doc.data();
                            final String messageId =
                                doc.id; // هنا الـ ID الحقيقي مش Null

                            // معالجة الوقت عشان ميبقاش Null ويضرب
                            DateTime? createdAt;
                            if (msg['created_at'] != null) {
                              createdAt = (msg['created_at'] as Timestamp)
                                  .toDate();
                            } else {
                              createdAt =
                                  DateTime.now(); // حل مؤقت لحد ما السيرفر يرد
                            }

                            return defBubble(
                              msg["sender"] == userId
                                  ? TurkBubbleType.right
                                  : msg["sender"] == TurkUserID
                                  ? TurkBubbleType.center
                                  : TurkBubbleType.left,
                              context,
                              messageId, // بعتنا الـ ID الصح
                              DateFormat(
                                'h:mm a',
                              ).format(createdAt), // تحويل الوقت لـ String
                              msg["disname"]?.toString() ?? "Unknown",
                              Text(
                                msg["text"] ?? "",
                                style: const TextStyle(color: Colors.white),
                                textAlign: msg["sender"] == userId
                                    ? TextAlign.right
                                    : msg["sender"] == TurkUserID
                                    ? TextAlign.center
                                    : TextAlign.left,
                              ),
                              widget.roomId,
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
                              builder: (context) => AlertDialog(
                                title: Text(
                                  "أنواع الأسئلة",
                                  style: TextStyle(
                                    fontFamily: "TurkFont",
                                    fontSize: 22,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  height: 300,
                                  child: ListView(
                                    children: [
                                      for (
                                        int index = 0;
                                        index < orderItems.length;
                                        index++
                                      )
                                        ListTile(
                                          onTap: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              tablee =
                                                  orderItems[index]["root"];
                                            });
                                          },
                                          title: Text(
                                            orderItems[index]["name"],
                                            textDirection:
                                                TextUtils.getTextDirection(
                                                  orderItems[index]["name"],
                                                ),
                                            style: TextStyle(
                                              fontFamily: "TurkFont",
                                              color: TurkStyle().textColor2,
                                            ),
                                          ),
                                          subtitle: Text(
                                            orderItems[index]["dis"],
                                            style: TextStyle(
                                              fontFamily: "TurkFont",
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "فاكس",
                                      style: TextStyle(fontFamily: "TurkFont"),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          onTap: () => TurkMessage(tablee),
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
  String roomId,
) {
  return SizedBox(
    width: double.infinity,
    child: GestureDetector(
      onLongPress: () {
        if (isUser != TurkBubbleType.left) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("حذف الرسالة؟"),
              actions: [
                TextButton(
                  onPressed: () async {
                    // تأكد إنك عامل import للـ cloud_firestore
                    await db
                        .collection("rooms")
                        .doc(roomId)
                        .collection("messages")
                        .doc(messageid)
                        .delete();

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
