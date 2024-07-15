import 'package:flutter/material.dart';
import 'package:path/path.dart';
class Dailog extends StatefulWidget {
  @override
  _DailogState createState() => _DailogState();
}

class _DailogState extends State<Dailog> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(onPressed:(){
              showDialog<String>(
                context: context,
                builder:(BuildContext context)=> SimpleDialog(
                  title: Text("Filter by format ?",style:TextStyle(fontWeight: FontWeight.bold)),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    height: 160.0,
                                    width: (MediaQuery.of(context).size.width -80)/2,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage("assets/image.png"),fit: BoxFit.fill,),
                                      borderRadius:BorderRadius.circular(1.0),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 80.0,),
                                          Text("Image",style:TextStyle(fontSize: 16.0,color:Colors.white,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: (){},
                                ),
                                GestureDetector(
                                  child: Container(
                                    height: 160.0,
                                    width: (MediaQuery.of(context).size.width -80)/2,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage("assets/video.png"),fit: BoxFit.fill,),
                                      borderRadius:BorderRadius.circular(1.0),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 80.0,),
                                          Text("Video",style:TextStyle(fontSize: 16.0,color:Colors.white,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: (){},
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    height: 160.0,
                                    width: (MediaQuery.of(context).size.width -80)/2,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage("assets/text.png"),fit: BoxFit.fill,),
                                      borderRadius:BorderRadius.circular(1.0),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 80.0,),
                                          Text("Text",style:TextStyle(fontSize: 16.0,color:Colors.white,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: (){},
                                ),
                                GestureDetector(
                                  child: Container(
                                    height: 160.0,
                                    width: (MediaQuery.of(context).size.width -80)/2,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage("assets/article.png"),fit: BoxFit.fill,),
                                      borderRadius:BorderRadius.circular(1.0),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(height: 80.0,),
                                          Text("Article",style:TextStyle(fontSize: 16.0,color:Colors.white,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: (){},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                )
              );
            })
          ],
        ),
      ),
    );
  }


}
