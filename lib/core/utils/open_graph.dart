import 'package:html/parser.dart';
import 'package:html/dom.dart' as _dom;
import 'package:http/http.dart' as _http;

class OpenGraphRepository {
  ///

  /// fetch opengraph / `og` data from a url by parsing
  /// the html of the webpage
  static Future<Map<String, String>> openGraphData(String url) async {
    /// set user agent to null
    /// user agent should be specified at the google bot or else some
    /// website like amazon won't expose the open graph tags

    //
    final Uri videoUrl = Uri.parse(url);
    final Map<String, String> headers = {
      'User-Agent':
          "mozilla/5.0 (compatible; googlebot/2.1; +http://www.google.com/bot.html)"
    };

    /// fetch html body
    _http.Response response;
    try {
      response = await _http.get(videoUrl, headers: headers);
    } catch (_) {
      rethrow;
    }
    final Map<String, String> og = {};

    /// parse html body
    final _dom.Document doc = parse(response.body);
    doc.getElementsByTagName('meta').forEach((element) {
      if (element.attributes['property'] == "og:description") {
        og['description'] = element.attributes['content'] ?? "";
      }
      if (element.attributes['property'] == "og:url") {
        og['url'] = element.attributes['content'] ?? "";
      }
    });

    return og;
  }
}
