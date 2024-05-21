import 'package:flutter/material.dart';
import 'package:watermarked/extract_watermark.dart';
import 'package:watermarked/watermarking.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PicGuard",
          style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 42, 30, 26),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png'),
            const SizedBox(
              width: 400,
              child: Center(
                  child: Text(
                "Welcome to PicGuard",
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              )),
            ),
            const SizedBox(height: 8),
            const SizedBox(
              width: 300,
              child: Center(
                  child: Text(
                "Secure Your Photos Here",
                style: TextStyle(fontStyle: FontStyle.italic),
              )),
            ),
            const SizedBox(height: 20),

            // *button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Watermarking()),
                    );
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(160, 40)),
                  child: const Text(
                    "Watermarking",
                    style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ExtractWatermark()),
                    );
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(160, 40)),
                  child: const Text(
                    "Extract Watermark",
                    style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // *footer
      bottomNavigationBar: const BottomAppBar(
        color: Color.fromARGB(241, 42, 30, 26),
        child: SizedBox(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '© 2024 ButaCoders.',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
