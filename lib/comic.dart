import 'package:read_story_app/chaters.dart';

class Comic{
  String category, name, image;
  List<Chapters> chapters;

  Comic({this.category, this.name, this.image, this.chapters});

  Comic.fromJson(Map<String, dynamic> json){
    category = json['Category'];
    if(json['Chapters'] != null){
      chapters = new List<Chapters>();
      json['Chapters'].forEach((v){
        chapters.add(new Chapters.fromJson(v));
      });
    }
    image = json['Image'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Category'] = this.category;
    if(this.chapters != null){
      data['Chaters'] = this.chapters.map((e) => e.toJson()).toList();
    }
    data['Image'] = this.image;
    data['Name'] = this.name;
    return data;
  }
}