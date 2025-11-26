import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomService {
  final supabase = Supabase.instance.client;

  // 4. فنكشن تعمل جروب جديد وتخليك الأدمن بتاعه
  Future<void> createRoom(
    BuildContext context,
    String roomName,
    String dis,
    String? avatar,
  ) async {
    try {
      final userId = supabase.auth.currentUser!.id;

      // أ: بنكريت الجروب وبنرجع الداتا بتاعته
      final data = await supabase
          .from('rooms')
          .insert({
            'name': roomName,
            'dis': dis,
            'avatar_url': avatar,
            // 'created_by': userId, // لو كنت ضفت العمود ده في الجدول، شيل الكومنت
          })
          .select()
          .single(); // مهمة جداً عشان ترجعلك صف واحد مش لستة

      // ب: بناخد الـ ID بتاع الجروب الجديد
      final newRoomId = data['id'];

      // ج: بنضيفك كـ "أدمن" في الجروب ده
      await supabase.from('room_members').insert({
        'room_id': newRoomId,
        'user_id': userId,
        'role': 'admin', // بص يا باشا، بقيت أدمن أهو
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("الجروب اتعمل وأنت بقيت الكبير بتاعه!")),
      );
      print("الجروب اتعمل وأنت بقيت الكبير بتاعه!");
    } catch (e) {
      print("في حاجة غلط حصلت وأنت بتعمل الجروب: $e");
    }
  }

  // 1. فنكشن عشان تدخل جروب جديد (Join Group)
  Future<void> joinGroup(String roomId) async {
    try {
      final userId = supabase.auth.currentUser!.id;

      await supabase.from('room_members').insert({
        'room_id': roomId,
        'user_id': userId,
        'role': 'member', // الديفولت بتاعنا
      });

      print("تم الانضمام للجروب بنجاح يا ريس!");
    } catch (e) {
      print("حصل مشكلة وأنت بتدخل الجروب: $e");
    }
  }

  // 2. فنكشن تجيب الجروبات اللي أنا مشترك فيها بس (My Groups)
  Future<List<Map<String, dynamic>>> getMyGroups() async {
    try {
      final userId = supabase.auth.currentUser!.id;

      // التريكاية هنا: بنقوله هات الـ rooms بشرط إن جدول الـ room_members يكون فيه اليوزر ده
      // كلمة !inner دي معناها (Hate rooms ONLY IF connection exists)
      final data = await supabase
          .from('rooms')
          .select('*, room_members!inner(*)')
          .eq('room_members.user_id', userId);

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print("مش عارف اجيب الجروبات: $e");
      return [];
    }
  }

  // 3. فنكشن تخرج من الجروب (Leave Group)
  Future<void> leaveGroup(String roomId) async {
    final userId = supabase.auth.currentUser!.id;

    await supabase
        .from('room_members')
        .delete()
        .eq('room_id', roomId)
        .eq('user_id', userId);
  }
}
