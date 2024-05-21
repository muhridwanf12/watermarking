import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

Future<void> watermarking(XFile? mainImage, XFile? watermarkImage) async {

  final original = img.decodeImage(await mainImage!.readAsBytes());
  final watermark = img.decodeImage(await watermarkImage!.readAsBytes());


  // Resize watermark to fit the original image
  final resizedWatermark = img.copyResize(watermark!, width: original!.width, height: original.height);

  // Apply DWT to each color channel
  final dwtOriginalRed = applyDWT(getColorChannel(original, 'red'));
  final dwtOriginalGreen = applyDWT(getColorChannel(original, 'green'));
  final dwtOriginalBlue = applyDWT(getColorChannel(original, 'blue'));

  final dwtWatermarkRed = applyDWT(getColorChannel(resizedWatermark, 'red'));
  final dwtWatermarkGreen = applyDWT(getColorChannel(resizedWatermark, 'green'));
  final dwtWatermarkBlue = applyDWT(getColorChannel(resizedWatermark, 'blue'));

  // Embed the watermark into the original image
  final embeddedDWT_Red = embedWatermark(dwtOriginalRed, dwtWatermarkRed);
  final embeddedDWT_Green = embedWatermark(dwtOriginalGreen, dwtWatermarkGreen);
  final embeddedDWT_Blue = embedWatermark(dwtOriginalBlue, dwtWatermarkBlue);

  // Inverse DWT to get the watermarked image
  var watermarkedImage = inverseDWT(embeddedDWT_Red, embeddedDWT_Green, embeddedDWT_Blue);

  String? outputPath = await FilePicker.platform.getDirectoryPath();

  if (outputPath != null) {
    final watermarkedFilePath = '$outputPath/watermarked_image.png';
    final watermarkedFile = File(watermarkedFilePath);
    watermarkedFile.writeAsBytesSync(img.encodePng(watermarkedImage));
    print('Watermarked image saved at: $watermarkedFilePath');
  } else {
    print('No folder selected.');
  }
}

List<List<double>> getColorChannel(img.Image image, String channel) {
  final width = image.width;
  final height = image.height;
  final result = List.generate(height, (_) => List<double>.filled(width, 0));

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final pixel = image.getPixel(x, y);
      switch (channel) {
        case 'red':
          result[y][x] = img.getRed(pixel).toDouble();
          break;
        case 'green':
          result[y][x] = img.getGreen(pixel).toDouble();
          break;
        case 'blue':
          result[y][x] = img.getBlue(pixel).toDouble();
          break;
      }
    }
  }

  return result;
}

List<List<double>> applyDWT(List<List<double>> channel) {
  final height = channel.length;
  final width = channel[0].length;
  final result = List.generate(height, (_) => List<double>.filled(width, 0));

  for (int y = 0; y < height; y++) {
    result[y] = dwt1D(channel[y]);
  }

  for (int x = 0; x < width; x++) {
    final column = List<double>.generate(height, (y) => result[y][x]);
    final transformedColumn = dwt1D(column);
    for (int y = 0; y < height; y++) {
      result[y][x] = transformedColumn[y];
    }
  }

  return result;
}

List<double> dwt1D(List<double> data) {
  final length = data.length;
  final result = List<double>.filled(length, 0);

  final half = length ~/ 2;
  for (int i = 0; i < half; i++) {
    result[i] = (data[2 * i] + data[2 * i + 1]) / 2;
    result[half + i] = (data[2 * i] - data[2 * i + 1]) / 2;
  }

  return result;
}

List<List<double>> embedWatermark(List<List<double>> original, List<List<double>> watermark) {
  final height = original.length;
  final width = original[0].length;

  final result = List.generate(height, (y) => List<double>.from(original[y]));

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      result[y][x] += watermark[y][x] * 0.1;
    }
  }

  return result;
}

img.Image inverseDWT(List<List<double>> redChannel, List<List<double>> greenChannel, List<List<double>> blueChannel) {
  final height = redChannel.length;
  final width = redChannel[0].length;
  final result = img.Image(width, height);

  // Apply inverse 1D DWT to each color channel column-wise
  for (int x = 0; x < width; x++) {
    final redColumn = List<double>.generate(height, (y) => redChannel[y][x]);
    final greenColumn = List<double>.generate(height, (y) => greenChannel[y][x]);
    final blueColumn = List<double>.generate(height, (y) => blueChannel[y][x]);

    final inverseRedColumn = inverseDwt1D(redColumn);
    final inverseGreenColumn = inverseDwt1D(greenColumn);
    final inverseBlueColumn = inverseDwt1D(blueColumn);

    for (int y = 0; y < height; y++) {
      redChannel[y][x] = inverseRedColumn[y];
      greenChannel[y][x] = inverseGreenColumn[y];
      blueChannel[y][x] = inverseBlueColumn[y];
    }
  }

  // Apply inverse 1D DWT to each color channel row-wise
  for (int y = 0; y < height; y++) {
    final inverseRedRow = inverseDwt1D(redChannel[y]);
    final inverseGreenRow = inverseDwt1D(greenChannel[y]);
    final inverseBlueRow = inverseDwt1D(blueChannel[y]);

    for (int x = 0; x < width; x++) {
      final red = inverseRedRow[x].toInt().clamp(0, 255);
      final green = inverseGreenRow[x].toInt().clamp(0, 255);
      final blue = inverseBlueRow[x].toInt().clamp(0, 255);

      result.setPixel(x, y, img.getColor(red, green, blue));
    }
  }

  return result;
}

List<double> inverseDwt1D(List<double> data) {
  final length = data.length;
  final result = List<double>.filled(length, 0);

  final half = length ~/ 2;
  for (int i = 0; i < half; i++) {
    result[2 * i] = data[i] + data[half + i];
    result[2 * i + 1] = data[i] - data[half + i];
  }

  return result;
}



