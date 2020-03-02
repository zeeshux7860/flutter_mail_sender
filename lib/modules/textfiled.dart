import 'package:flutter/material.dart';

class TextFiledMaterial extends StatefulWidget {
  final name;
  final controller;

  const TextFiledMaterial({Key key, this.name, this.controller}) : super(key: key);
  @override
  _TextFiledMaterialState createState() => _TextFiledMaterialState();
}

class _TextFiledMaterialState extends State<TextFiledMaterial> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(padding: EdgeInsets.all(20.0),
    child: new  Text(widget.name,style: TextStyle(
      fontSize: 20.0
    ),),
    ),
        new Container(
          margin: EdgeInsets.only(left: 20.0,right: 20.0),
          color: Colors.grey[200],
          child: new TextFormField(
              // The validator receives the text that the user has entered.
  validator: (value) {
    if (value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  },
            controller: widget.controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10.0),
              hintText: widget.name,
              border: InputBorder.none
            ),
          ),
        ),
      ],
    );
  }
}