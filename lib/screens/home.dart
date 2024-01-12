import 'dart:io';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chatter/dialogs/dialog.dart';
import 'package:chatter/providers/message_provider.dart';
import 'package:chatter/screens/pdf_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../styles/app_styles.dart';
import 'splash.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName:
                  Text(FirebaseAuth.instance.currentUser!.displayName ?? "---"),
              accountEmail:
                  Text(FirebaseAuth.instance.currentUser!.email ?? "---"),
              currentAccountPicture: Image.network(
                  FirebaseAuth.instance.currentUser!.photoURL ??
                      "https://static.thenounproject.com/png/5034901-200.png"),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Editar nom"),
              onTap: () async {
                String? newName = await inputDialog(context);
                if (newName != null && newName.isNotEmpty) {
                  await FirebaseAuth.instance.currentUser!
                      .updateDisplayName(newName);
                  setState(() {});
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Editar imatge de perfil"),
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? xFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (xFile != null) {
                  final storageRef = FirebaseStorage.instance.ref();
                  var fileRef = storageRef.child(
                      'profile/${FirebaseAuth.instance.currentUser!.uid}');
                  await fileRef.putFile(File(xFile.path));
                  String photoURL = await fileRef.getDownloadURL();
                  await FirebaseAuth.instance.currentUser!
                      .updatePhotoURL(photoURL);
                  setState(() {});
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text("Obrir PDF"),
              onTap: () async {
                Reference ref = FirebaseStorage.instance
                    .ref()
                    .child('pdf')
                    .child('01-CincPometes.pdf');

                final Directory tempDir = await getTemporaryDirectory();
                File tempFile = File("${tempDir.path}/temp.pdf");

                final downloadTask = ref.writeToFile(tempFile);
                downloadTask.snapshotEvents.listen((taskSnapshot) {
                  switch (taskSnapshot.state) {
                    case TaskState.running:
                      debugPrint("Descargando PDF");
                      break;
                    case TaskState.paused:
                      debugPrint("Pausando PDF");
                      break;
                    case TaskState.success:
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PdfViewer(pdfPath: tempFile.path)));
                      break;
                    case TaskState.canceled:
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Error descargando PDF"),
                        ),
                      );
                      break;
                    case TaskState.error:
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Error descargando PDF"),
                        ),
                      );
                      break;
                  }
                });
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sortir"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Splash(),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
      appBar: AppBar(title: const Text("Chatter")),
      body: Center(
        child: Column(
          children: [
            const Icon(Icons.chat, size: 48, color: AppStyles.orange),
            Text(
              FirebaseAuth.instance.currentUser!.displayName ?? "---",
              style: AppStyles.mediumText,
            ),
            Text(
              FirebaseAuth.instance.currentUser!.email ?? "---",
              style: AppStyles.mediumText,
            ),
            Expanded(
              child: Consumer<MessageProvider>(
                  builder: (context, messageProvider, child) {
                return Container(
                  color: AppStyles.orange.withOpacity(0.1),
                  child: ListView(
                    reverse: true,
                    children: [
                      for (var message in messageProvider.messages.reversed)
                        Column(
                          crossAxisAlignment: message.authorId ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            AppStyles.chatSeparator,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(message.authorName),
                            ),
                            BubbleSpecialOne(
                              text: message.text,
                              isSender: message.authorId ==
                                  FirebaseAuth.instance.currentUser!.uid,
                              color: Colors.purple.shade100,
                              textStyle: AppStyles.chatText,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                  "${message.dateTime.hour}:${message.dateTime.minute}"),
                            )
                          ],
                        ),
                    ],
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textEditingController,
                onSubmitted: (value) {
                  Provider.of<MessageProvider>(context, listen: false)
                      .addMessage(value);
                  textEditingController.text = "";
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
