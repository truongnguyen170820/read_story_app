
class Chapters{
  List<String> links;
  String name;

  Chapters({this.links, this.name});

  Chapters.fromJson(Map<String, dynamic> json){
    if(json['Links'] != null)
      links = json['Link'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Link'] = this.links;
    data['Name'] = this.name;
    return data;
  }
}