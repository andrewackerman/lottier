import 'dart:typed_data';

class DocumentData {

  DocumentData(
    this.text,
    this.fontName,
    this.size,
    this.justification,
    this.tracking,
    this.lineHeight,
    this.baselineShift,
    this.color,
    this.strokeColor,
    this.strokeWidth,
    this.strokeOverFill,
  );

  final String text;
  final String fontName;
  final double size;
  final Justification justification;
  final int tracking;
  final double lineHeight;
  final double baselineShift;
  final int color;
  final int strokeColor;
  final double strokeWidth;
  final bool strokeOverFill;

  bool operator == (Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    int result;
    int temp;
    result = text.hashCode;
    result = 31 * result + fontName.hashCode;
    result = 31 * result + size.hashCode;
    result = 31 * result + justification.hashCode;
    result = 31 * result + tracking;
    temp = (ByteData.view(Uint8List(8).buffer)..setFloat64(0, lineHeight)).getInt64(0);
    result = 31 * result + (temp ^ (temp >> 32));
    result = 31 * result + color;
    return result;
  }

}

enum Justification {
  leftAlign,
  rightAlign,
  center,
}