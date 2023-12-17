import 'http.dart';

class Services extends Api {
  String urlBase = '192.168.1.8:3000';
  getList([filter, search]) async {
    var url2 = '/api/places/list';
    var res = await super.get(urlBase, url2);
    return res;
  }

 Future <bool> addOrUpdatePlace(int ? idPlace, Map obj)async {
     if(idPlace != null){
    var url2 = '/api/places/update/$idPlace';
     await super.putForm(urlBase, url2, obj);
     }else {
    var url2 = '/api/places/add';
     await super.postForm(urlBase, url2, obj);
     }
     return true;
  }

  Future deletePlace(int idPlace)async{
    var url2 = '/api/places/delete/$idPlace';
    var res = await super.delete(urlBase, url2);
    return res;
  }

  getPlaceData(int idPlace)async{
    var url2 = '/api/places/data/$idPlace';
    var res = await super.get(urlBase, url2);
    return res;
  }

  getPlaceImageUrl(String nameImage){
   var url2 = '/api/midia/$nameImage';
   var fullUrl =  super.getFullURL(urlBase, url2);
   return fullUrl;
  }
}