import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_viewer/photoview.dart';

void main() {
  runApp(MaterialApp(
    home: Gallery(),
  ));
}



class Gallery extends StatefulWidget {

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List data = [];
  List smallurls = [];
  List username = [];
  List description = [];
  List fullurls = [];
  bool showing = false;


  getData() async{
    http.Response response = await http.get('https://api.unsplash.com/photos/?client_id=DfI1HgwLR4xO1HrISwOfeVx0WdhGhKZsBO--b04KNg0');
    data = jsonDecode(response.body);
    create();
    setState(() {
      showing = true;
    });
    }

    create() {
      for (int i = 0; i < data.length; i++) {
        smallurls.add(data.elementAt(i)['urls']['small']);
        fullurls.add(data.elementAt(i)['urls']['full']);
        username.add(data.elementAt(i)['user']['username']);
        String temp = data.elementAt(i)['description'];
        if (temp == null){
          temp = 'no name';
        }
        description.add(temp);
    }
//    img = Image.asset('assets/night.png');
//    print(Image.network(fullurls[0]);

  }


  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return RawMaterialButton(
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(
                  builder: (context) => PhotoView(
                    fullImg: fullurls[index],
                  )));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Container(
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        child: !showing ? CircularProgressIndicator() : Image.network(smallurls[index]),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),

                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Title:',
                                  style: TextStyle(
                                    letterSpacing: 1,
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  child: Text(
                                    description[index],
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontStyle: FontStyle.italic,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  ('Author:'),
                                  style: TextStyle(
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  username[index],
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: data.length,
      ),
    );
  }
}
