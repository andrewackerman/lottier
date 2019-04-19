import 'dart:convert';

import '../composition.dart';
import '../model/marker.dart';
import '../model/layer/layer.dart';
import '../model/data/image_asset.dart';
import '../utility/utility.dart';
import '../model/font_character.dart';

class LottierCompositionParser {

  static LottierComposition fromString(String jsonString) {
    try {
      final map = json.decode(jsonString);
      return fromMap(map);
    } catch(ex) {
      throw ArgumentError('Error parsing JSON string: $ex');
    }
  }

  static LottierComposition fromMap(Map<String, dynamic> jsonMap) {
    var scale = Utility.dpScale;
    var startFrame = 0.0;
    var endFrame = 0.0;
    var frameRate = 0.0;
    var layerMap = <Layer>[];
    var width = 0;
    var height = 0;
    var precomps = <String, List<Layer>>{};
    var images = <String, LottierImageAsset>{};
    var markers = <Marker>[];
    var characters = <int, FontCharacter>{};

    var composition = LottierComposition();

    for (var key in jsonMap.keys) {
      dynamic value = jsonMap[key];

      switch(key) {
        case 'w':
          width = value as int;
          break;

        case 'h':
          height = value as int;
          break;

        case 'ip':
          startFrame = value as double;
          break;

        case 'op':
          endFrame = value as double;
          break;

        case 'fr':
          frameRate = value as double;
          break;

        case 'v':
          String version = value as String;
          final versions = version.split('.');
          final majorVersion = int.tryParse(versions[0]);
          final minorVersion = int.tryParse(versions[1]);
          final patchVersion = int.tryParse(versions[2]);
          if (!Utility.isAtLeastVersion(majorVersion, minorVersion, patchVersion, 4, 4, 0)) {
            composition.addWarning('Lottier only supports bodymovin >= 4.4.0');
          }
          break;

        case 'layers':
          break;

        case 'assets':
          break;

        case 'fonts':
          break;

        case 'chars':
          break;

        case 'markers':
          break;

      }
    }
  }

}