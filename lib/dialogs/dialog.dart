import 'package:flutter/material.dart';

Future<String?> inputDialog(BuildContext context) async {
  TextEditingController textController = TextEditingController();
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, textController.text);
                      },
                      child: const Text("GUARDAR")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("CANCEL·LAR")),
                ],
              )
            ],
          ),
        );
      });
}
