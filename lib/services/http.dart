import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart' as parser;
import 'package:dio/dio.dart';

class Api {
  Future get( urlbase, url2, [Map <String, dynamic> ? queryObj]) async {
    try {
    var fullUrl = Uri.http(urlbase, url2, queryObj );  
    var response = await http.get(fullUrl);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
    }
   catch(e){ return null; }
  }

  Future post(urlbase, url2, obj, [bool ? isMap, headers]) async {
    var fullUrl = Uri.http(urlbase, url2);
    var response = await http.post(fullUrl, body: isMap ?? false? json.encode(obj) : obj);
    if (response.statusCode == 200) {
      try {
       return json.decode(response.body); 
      }
      catch(e) {
        return response.body;
      }
    } else {
      return null;
    }
  }

Future postForm(urlbase, url2, obj) async {
    var fullUrl = Uri.http(urlbase, url2);
    try {
        final formData = FormData.fromMap({
          "name_place": obj["name_place"],
          'image': getMultiPartImage(obj),
        });
        final response = await Dio().post(
          fullUrl.toString(),
          data: formData,
        );
                    print(obj);

        return response.statusCode == 200 ? response.data : null;
    } catch (e) {
            print(e);

      return null;
    }
  }

Future putForm(urlbase, url2, obj) async {
    var fullUrl = Uri.http(urlbase, url2);
    try {
        final formData = FormData.fromMap({
          "name_place": obj["name_place"],
          'image':getMultiPartImage(obj),
        });
        final response = await Dio().put(
          fullUrl.toString(),
          data: formData,
        );
        return response.statusCode == 200 ? response.data : null;
    } catch (e) {
      print(e);
      return null;
    }
  }


  Future delete( urlbase, url2) async {
    try {
    var fullUrl = Uri.http(urlbase, url2 );  
    var response = await http.delete(fullUrl);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
    }
   catch(e){ return null; }
  }

 getMultiPartImage(Map obj){
  return obj["image_bytes"] != null && obj["image_mime_type"] != null ?   MultipartFile.fromBytes(obj["image_bytes"]!,
              filename: obj["image_name"]!,
              contentType: parser.MediaType.parse(obj["image_mime_type"])) : null;
}

  getFullURL(urlBase, url2){
    var fullUrl = Uri.http(urlBase, url2 ).toString();  
     return fullUrl;
  }

}
