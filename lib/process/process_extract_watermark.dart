import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

Future<void> extract(XFile? watermarkedImage) async {
  if (watermarkedImage == null) {
    print('No image selected.');
    return;
  }

  final watermarked = img.decodeImage(await watermarkedImage.readAsBytes());

  if (watermarked == null) {
    print('Error decoding image.');
    return;
  }

  // Apply DWT to each color channel of the watermarked image
  final dwtWatermarkedR = applyDWT(getColorChannel(watermarked, Channel.red));
  final dwtWatermarkedG = applyDWT(getColorChannel(watermarked, Channel.green));
  final dwtWatermarkedB = applyDWT(getColorChannel(watermarked, Channel.blue));

  // Extract the watermark from the DWT coefficients of each color channel
  final extractedDWTR = extractWatermarkChannel(dwtWatermarkedR);
  final extractedDWTG = extractWatermarkChannel(dwtWatermarkedG);
  final extractedDWTB = extractWatermarkChannel(dwtWatermarkedB);

  // Inverse DWT to get the extracted watermark image for each color channel
  final extractedWatermarkR = inverseDWT(extractedDWTR);
  final extractedWatermarkG = inverseDWT(extractedDWTG);
  final extractedWatermarkB = inverseDWT(extractedDWTB);

  // Combine color channels to form the final extracted watermark image
  var extractedWatermarkImage = combineColorChannels(extractedWatermarkR, extractedWatermarkG, extractedWatermarkB);

  String? outputPath = await FilePicker.platform.getDirectoryPath();

  if (outputPath != null) {
    final extractedWatermarkFilePath = '$outputPath/extracted_watermark.png';
    final extractedWatermarkFile = File(extractedWatermarkFilePath);
    extractedWatermarkFile.writeAsBytesSync(img.encodePng(extractedWatermarkImage));
    print('Extracted watermark saved at: $extractedWatermarkFilePath');
  } else {
    print('No folder selected.');
  } 
}

List<List<double>> extractWatermarkChannel(List<List<double>> dwtWatermarked) {
  final height = dwtWatermarked.length;
  final width = dwtWatermarked[0].length;

  final result = List.generate(height, (y) => List<double>.filled(width, 0));

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      result[y][x] = dwtWatermarked[y][x] * 20.0; // Scale factor to extract watermark
    }
  }

  return result;
}

List<List<double>> applyDWT(List<List<double>> channel) {
  final int rows = channel.length;
  final int cols = channel[0].length;

  for (int i = 0; i < rows; i++) {
    channel[i] = dwt1D(channel[i]);
  }

  for (int j = 0; j < cols; j++) {
    final column = List<double>.generate(rows, (i) => channel[i][j]);
    final transformedColumn = dwt1D(column);
    for (int i = 0; i < rows; i++) {
      channel[i][j] = transformedColumn[i];
    }
  }

  return channel;
}

List<double> dwt1D(List<double> data) {
  final int length = data.length;
  final List<double> result = List<double>.filled(length, 0);

  final int half = length ~/ 2;
  for (int i = 0; i < half; i++) {
    result[i] = (data[2 * i] + data[2 * i + 1]) / 2;
    result[half + i] = (data[2 * i] - data[2 * i + 1]) / 2;
  }

  return result;
}

List<List<double>> inverseDWT(List<List<double>> transformed) {
  final int rows = transformed.length;
  final int cols = transformed[0].length;
  final List<List<double>> result = List.generate(rows, (_) => List<double>.filled(cols, 0));

  for (int j = 0; j < cols; j++) {
    final column = List<double>.generate(rows, (i) => transformed[i][j]);
    final inverseColumn = inverseDwt1D(column);
    for (int i = 0; i < rows; i++) {
      transformed[i][j] = inverseColumn[i];
    }
  }

  for (int i = 0; i < rows; i++) {
    result[i] = inverseDwt1D(transformed[i]);
  }

  return result;
}

List<double> inverseDwt1D(List<double> data) {
  final int length = data.length;
  final List<double> result = List<double>.filled(length, 0);

  final int half = length ~/ 2;
  for (int i = 0; i < half; i++) {
    result[2 * i] = data[i] + data[half + i];
    result[2 * i + 1] = data[i] - data[half + i];
  }

  return result;
}

List<List<double>> getColorChannel(img.Image image, Channel channel) {
  final width = image.width;
  final height = image.height;
  final result = List.generate(height, (_) => List<double>.filled(width, 0));

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final pixel = image.getPixel(x, y);
      switch (channel) {
        case Channel.red:
          result[y][x] = img.getRed(pixel).toDouble();
          break;
        case Channel.green:
          result[y][x] = img.getGreen(pixel).toDouble();
          break;
        case Channel.blue:
          result[y][x] = img.getBlue(pixel).toDouble();
          break;
      }
    }
  }

  return result;
}

img.Image combineColorChannels(List<List<double>> red, List<List<double>> green, List<List<double>> blue) {
  final height = red.length;
  final width = red[0].length;
  final result = img.Image(width, height);

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final r = red[y][x].toInt().clamp(0, 255);
      final g = green[y][x].toInt().clamp(0, 255);
      final b = blue[y][x].toInt().clamp(0, 255);
      result.setPixel(x, y, img.getColor(r, g, b));
    }
  }

  return result;
}

enum Channel { red, green, blue }

