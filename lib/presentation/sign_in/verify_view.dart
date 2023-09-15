import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../base/markets_data.dart';

class VerifyView extends StatelessWidget {
  const VerifyView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController smsCode = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade800,
      ),
      body: Consumer<MarketsData>(builder: (
        context,
        marketsData,
        v,
      ) {
        return Column(
          children: [
            TextField(
              controller: smsCode,
              decoration: const InputDecoration(hintText: "ادخل رقم الرساله"),
            ),
            InkWell(
              onTap: () {
                marketsData.login(smsCode.text, context);
              },
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
        );
      }),
    );
  }
}
