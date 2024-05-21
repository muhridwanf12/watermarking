import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watermarked/process/process_extract_watermark.dart';

class ExtractWatermark extends StatefulWidget {
  const ExtractWatermark({super.key});

  @override
  State<ExtractWatermark> createState() => _ExtractWatermarkState();
}

class _ExtractWatermarkState extends State<ExtractWatermark> {
  XFile? watermarkedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extract Watermarking',
            style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 42, 30, 26),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // * watermarked image
            const SizedBox(
                height: 30,
                width: 370,
                child: Text(
                  "Please upload watermarked image here",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Color.fromARGB(255, 125, 124, 124)),
                )),

            //* nama watermarked
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                watermarkedImage == null
                    ? Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!)),
                        child: const Center(
                          child: Text(
                            'No images uploaded',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      )
                    : Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!)),
                        child: Center(
                          child: Text(
                            watermarkedImage!.path.split('/').last,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),

                //*tombol upload watermarked
                ElevatedButton(
                  onPressed: () async {
                    watermarkedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                    setState(() {});
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 42, 30, 26)),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Colors.grey[300]!),
                    )),
                  ),
                  child: const Text(
                    "Watermarked Image",
                  ),
                ),
              ],
            ),

            //* menampikan watermarked
            SizedBox(height: watermarkedImage != null ? 20 : 0),
            SizedBox(
              child: watermarkedImage != null
                  ? SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.file(
                        File(watermarkedImage!.path),
                        fit: BoxFit.cover,
                      ))
                  : Container(),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                extract(watermarkedImage);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 42, 30, 26)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text(
                "Extract and Download Watermark",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
