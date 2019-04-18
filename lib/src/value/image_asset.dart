import 'dart:typed_data';

class LottierImageAsset {

  LottierImageAsset(
    this.width,
    this.height,
    this.id,
    this.fileName,
    this.dirName,
  );

  final int width;
  final int height;
  final String id;
  final String fileName;
  final String dirName;
  
  Uint8List bitmap;

}