import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watermarked/process/process_watermarking.dart';

class Watermarking extends StatefulWidget {
  const Watermarking({super.key});

  @override
  State<Watermarking> createState() => _WatermarkingState();
}

class _WatermarkingState extends State<Watermarking> {
  XFile? mainImage;
  XFile? watermarkImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watermarking',
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
          children: [
            const SizedBox(height: 20),
            // * main image
            const SizedBox(
                height: 30,
                width: 370,
                child: Text(
                  "Please upload main image here",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Color.fromARGB(255, 125, 124, 124)),
                )),

            //* nama image
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                mainImage == null
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
                            mainImage!.path.split('/').last,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),

                // *tombol upload main image
                SizedBox(
                  width: 170,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      mainImage = await ImagePicker().pickImage(source: ImageSource.gallery);
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
                      "Main Image",
                    ),
                  ),
                ),
              ],
            ),

            // *menampilkan main image
            SizedBox(height: mainImage != null ? 20 : 0),
            SizedBox(
              child: mainImage != null
                  ? SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.file(
                        File(mainImage!.path),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
            ),

            const SizedBox(height: 20),
            // * watermarking image
            const SizedBox(
                height: 30,
                width: 370,
                child: Text(
                  "Please upload watermark image here",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Color.fromARGB(255, 125, 124, 124)),
                )),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                watermarkImage == null
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
                            watermarkImage!.path.split('/').last,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),

                //* tombol upload watermark image
                SizedBox(
                  width: 170,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      watermarkImage = await ImagePicker().pickImage(source: ImageSource.gallery);
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
                      "Watermark Image",
                    ),
                  ),
                ),
              ],
            ),

            //* menampilkan watermark image
            SizedBox(height: watermarkImage != null ? 20 : 0),
            SizedBox(
              child: watermarkImage != null
                  ? SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.file(
                        File(watermarkImage!.path),
                        fit: BoxFit.cover,
                      ))
                  : Container(),
            ),

            //* tombol download watermarked
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                watermarking(mainImage, watermarkImage);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 42, 30, 26)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text(
                "Download Watermarked Image",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
