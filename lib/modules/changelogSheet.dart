import 'package:flutter/material.dart';
import 'package:love_choice/style/styles.dart';

enum ChangeLogType { feature, imporvment, bugfix }

class ChangeLogSheet extends StatelessWidget {
  const ChangeLogSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TurkStyle().mainColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: const [
              BoxShadow(color: Colors.black, blurRadius: 15, spreadRadius: 2),
            ],
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 75.0),
                child: Container(
                  width: 10,
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 12),
              const Text(
                'سجل التغيرات والشكر',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      'شكر خاص:',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.new_releases, color: Colors.white),
                  ],
                ),
              ),
              Text(
                'الله عز وجل'
                '\nأمي'
                '\nاكبر داعم: مريم'
                '\nمختبر: ياسين'
                '\n قاعدة البيانات: ياسين'
                '\nالديزاين: شهد'
                '\nاختبار الموقع: فويد',
                style: TextStyle(fontSize: 18, color: Colors.white70),
                textDirection: TextDirection.rtl,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      'سجل التغيرات:',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.new_releases, color: Colors.white),
                  ],
                ),
              ),
              ChangeLogItem('اونلاين', ChangeLogType.feature),
              ChangeLogItem('التحكم بعرض الصفحات', ChangeLogType.feature),
              ChangeLogItem('انميشن', ChangeLogType.feature),
              ChangeLogItem('اعلانات', ChangeLogType.feature),
              ChangeLogItem('سجل التغيرات والشكر', ChangeLogType.feature),
              ChangeLogItem('الصلاحيات', ChangeLogType.bugfix),
              ChangeLogItem('ملف المطور', ChangeLogType.imporvment),
              // Add more changelog entries here
            ],
          ),
        );
      },
    );
  }

  Padding ChangeLogItem(String title, ChangeLogType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: switch (type) {
                ChangeLogType.feature => Colors.greenAccent,
                ChangeLogType.imporvment => Colors.orangeAccent,
                ChangeLogType.bugfix => Colors.grey,
              },
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SizedBox(width: 4),
                Text(switch (type) {
                  ChangeLogType.feature => 'ميزة',
                  ChangeLogType.imporvment => 'تحسين',
                  ChangeLogType.bugfix => 'تصليح',
                }, style: TextStyle(fontSize: 12, color: Colors.white)),

                SizedBox(width: 4),
                switch (type) {
                  ChangeLogType.feature => const Icon(Icons.add_rounded),
                  ChangeLogType.imporvment => const Icon(Icons.update, size: 20),
                  ChangeLogType.bugfix => const Icon(Icons.build, size: 20),
                },
              ],
            ),
          ),
        ],
      ),
    );
  }
}
