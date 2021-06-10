import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:read_story_app/comic.dart';

class HomPage extends StatefulWidget {
  @override
  _HomPageState createState() => _HomPageState();
}

class _HomPageState extends State<HomPage> {
  DatabaseReference _reference, _comicRef;

  @override
  void initState() {
    final FirebaseDatabase _database = FirebaseDatabase();
    _reference = _database.reference().child('Banners');
    _comicRef = _database.reference().child('Comic');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<String>>(
        future: getBanner(_reference),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CarouselSlider(
                    items: snapshot.data
                        .map((e) => Builder(builder: (context) {
                              return Image.network(e, fit: BoxFit.cover);
                            }))
                        .toList(),
                    options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        height: MediaQuery.of(context).size.height / 3)),
                Row(
                  children: [
                    Expanded(
                        flex: 4,
                        child: Container(
                          color: Colors.red,
                          padding: EdgeInsets.all(8),
                          child: Text("New Comic",
                              style: TextStyle(color: Colors.white)),
                        )),
                    Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.red,
                          padding: EdgeInsets.all(8),
                          child:
                              Text("", style: TextStyle(color: Colors.white)),
                        ))
                  ],
                ),
                FutureBuilder(
                    future: getComic(_comicRef),
                    builder: (context, snapshot) {
                      if(snapshot.hasError)
                        return Center(child: Text('${snapshot.error}'));
                      else if(snapshot.hasData){
                        List<Comic> comics = new List<Comic>();
                        snapshot.data.forEach((item){
                          var comic = Comic.fromJson(json.decode(json.encode(item)));
                          comics.add(comic);
                        });
                        return Expanded(child: GridView.count(crossAxisCount: 2,
                        childAspectRatio: 0.8,
                          padding: EdgeInsets.all(4),
                          mainAxisSpacing: 1,
                            crossAxisSpacing: 1,
                          children: comics.map((e){
                            return GestureDetector(
                              onTap: (){},
                              child: Card(
                                elevation: 12,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(e.image, fit: BoxFit.cover,)
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ));
                      }
                      return Center(child: CircularProgressIndicator());
                    })
              ],
            );
          else if (snapshot.hasError)
            return Center(child: Text('${snapshot.error}'));
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<List<dynamic>> getComic(DatabaseReference comicRef) {
    return _comicRef
        .once()
        .then((value) => value.value);
  }

  Future<List<String>> getBanner(DatabaseReference reference) {
    return _reference
        .once()
        .then((value) => value.value.cast<String>().toList());
  }
}
