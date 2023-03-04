import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? image;

  void pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? imgPick =
        await imagePicker.pickImage(source: ImageSource.gallery);
    image = File(imgPick!.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
/*     double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
 */
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Traducir pantalla'),
        centerTitle: true,
      ),
      body: Container(
        //width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: image == null
                    ? const Text('Soy uma imagen',)
                    : Image.file(
                        image!,
                      ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Traducir'),
            )
          ],
        ),
      ),
    );
  }
}
