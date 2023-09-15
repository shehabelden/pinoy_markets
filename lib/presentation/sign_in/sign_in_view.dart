import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../base/markets_data.dart';
import '../home_page/home_page.dart';
import 'sign_up.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});
  @override
  Widget build(BuildContext context) {
    TextEditingController phone = TextEditingController();
    TextEditingController password = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade800,
      ),
      body: Consumer<MarketsData>(builder: (
        context,
        marketsData,
        v,
      ) {
        return Padding(
          padding: MediaQuery.of(context).size.width > 600
              ? EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 4, left: 400)
              : EdgeInsets.all(0.0),
          child: SizedBox(
            width:
                MediaQuery.of(context).size.width > 600 ? 700 : double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: phone,
                  decoration: const InputDecoration(hintText: "رقم الهاتف"),
                ),
                TextField(
                  controller: password,
                  decoration: const InputDecoration(hintText: "كلمة السر"),
                ),
                InkWell(
                  onTap: () {
                    marketsData.registerWithEmailAndPassword(
                        phone.text, password.text);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        width:
                            MediaQuery.of(context).size.width < 600 ? 400 : 400,
                        height: 60,
                        alignment: Alignment.center,
                        color: Colors.purple.shade800,
                        child: const Text("تسجيل دخول"),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    MaterialPageRoute(builder: (context) => SignUp());
                  },
                  child: Text(
                    "انشاء حساب جديد",
                    style:
                        TextStyle(color: Colors.purple.shade500, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
