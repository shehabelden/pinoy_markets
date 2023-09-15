import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text("+02 01014695591"),
          const Text("تصحيح"),
          const Text("""
          سيتم ارسال رساله صوتيه لهذا الرقم تحتوي علي
          رمز تفعيل الحساب .
          يرجا التاكد من صحة الرقم قبل النقر علي متابعه 
          
          """),
          const Text("""
          ملاحظه: اذا كان مفتاح الدوله خطاء يرجي اعادة
          ادخل رقم مفتاح الدوله الصحيح          
          """),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 60,
                alignment: Alignment.center,
                color: Colors.purple.shade800,
                child: const Text("متابعه"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
