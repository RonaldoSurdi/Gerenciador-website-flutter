import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hwscontrol/core/components/models/youtube_model.dart';

class YoutubeMetaData {
  static Future<YoutubeModel> getData(String link) async {
    final Uri uri =
        Uri.parse("https://www.youtube.com/oembed?url=$link&format=json");

    http.Response result;

    try {
      result = await http.get(uri);
    } catch (e) {
      rethrow;
    }

    final Map<String, dynamic> resultJson = json.decode(result.body);

    return YoutubeModel.fromMap(resultJson);
  }
}
