import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RoomService {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  /// 4️⃣ إنشاء جروب جديد وتبقى Admin
  Future<void> createRoom(
    BuildContext context,
    String roomName,
    String dis,
    String? avatar,
  ) async {
    try {
      final user = auth.currentUser!;
      final uid = user.uid;

      // أ: إنشاء الغرفة
      final roomRef = await db.collection("rooms").add({
        "name": roomName,
        "dis": dis,
        "avatar_url": avatar,
        "created_at": FieldValue.serverTimestamp(),
        "created_by": uid, // اختياري
      });

      // ب: إضافة المستخدم كـ Admin
      await roomRef.collection("members").doc(uid).set({
        "role": "admin",
        "joined_at": FieldValue.serverTimestamp(),
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الجروب اتعمل وأنت الأدمن 👑")),
      );

      print("Room created successfully");
    } catch (e) {
      print("خطأ أثناء إنشاء الجروب: $e");
    }
  }

  /// 1️⃣ الانضمام لجروب
  Future<void> joinGroup(String roomId, String uid) async {
    try {
      await db
          .collection("rooms")
          .doc(roomId)
          .collection("members")
          .doc(uid)
          .set({
        "role": "member",
        "joined_at": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print("تم الانضمام للجروب بنجاح");
    } catch (e) {
      print("مشكلة أثناء الانضمام للجروب: $e");
    }
  }

  /// 2️⃣ جلب الجروبات اللي المستخدم عضو فيها (My Groups)
  Future<List<Map<String, dynamic>>> getMyGroups() async {
    try {
      final uid = auth.currentUser!.uid;

      final roomsSnapshot = await db.collection("rooms").get();

      List<Map<String, dynamic>> myRooms = [];

      for (var room in roomsSnapshot.docs) {
        final memberDoc =
            await room.reference.collection("members").doc(uid).get();

        if (memberDoc.exists) {
          myRooms.add({
            "id": room.id,
            ...room.data(),
            "role": memberDoc["role"],
          });
        }
      }

      return myRooms;
    } catch (e) {
      print("مش عارف أجيب الجروبات: $e");
      return [];
    }
  }

  /// 3️⃣ الخروج من الجروب
  Future<void> leaveGroup(String roomId) async {
    final uid = auth.currentUser!.uid;

    await db
        .collection("rooms")
        .doc(roomId)
        .collection("members")
        .doc(uid)
        .delete();
  }
}
