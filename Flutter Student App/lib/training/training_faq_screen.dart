import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/training/controller/your_account_controller.dart';
import 'package:opencentric_lms/utils/styles.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
            'FAQ',
          style: robotoRegular.copyWith(fontSize: 28)
        ),
      ),
      body: GetBuilder<YourAccountController>(builder: (controller) {
        return mainUI(context, controller);
      }),
    ));
  }

  Widget mainUI(BuildContext context, YourAccountController controller) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: controller.listFaq.length,
        itemBuilder: (context, index) {
          final faq = controller.listFaq[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(10),
            color: Colors.white,
            child: ExpansionTile(
              childrenPadding: const EdgeInsets.all(15),
              shape: const RoundedRectangleBorder(side: BorderSide.none),
              expansionAnimationStyle: AnimationStyle(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.linear
              ),
              trailing: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  child: const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.black,

                  )
              ),
              title: Html(data: faq.question, style: {
                "span": Style.fromTextStyle(const TextStyle(
                    backgroundColor: Colors.transparent, color: Colors.black, fontWeight: FontWeight.bold)),
              }),
              children: [
                Html(
                  shrinkWrap: true,
                  data: faq.answer,
                  style: {
                    "p": Style(
                      lineHeight: const LineHeight(1.2),
                      fontSize: FontSize(16),
                      backgroundColor: Colors.transparent,
                      textDecorationColor: Colors.transparent,
                      color: Colors.black
                      
                    ),
                    "span": Style.fromTextStyle(
                        const TextStyle(
                          backgroundColor: Colors.transparent,
                          fontSize: 16,
                          color: Colors.black)),
                  },
                ),
              ],
            ),
          );
        });
  }
}
