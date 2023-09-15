import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../base/markets_data.dart';
import 'verify_view.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade800,
      ),
      body: Consumer<MarketsData>(builder: (context, marketsData, i) {
        return Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "ادخل رقم الهاتف"),
            ),
            InkWell(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
                await marketsData.registerUser(controller.text, context);
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => VerifyView()));
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
