import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mailer2/mailer.dart';
import 'package:test_app/modules/textfiled.dart';
import 'package:test_app/src/images.dart';
import 'package:zefyr/zefyr.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ZefyrController _body = ZefyrController(NotusDocument());
  final FocusNode _focusNode = FocusNode();
  final _scaf  = GlobalKey<ScaffoldState>();
  File files;
  var attach = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController subject = TextEditingController();
  TextEditingController recipents = TextEditingController();
  TextEditingController sendmail = TextEditingController();
  TextEditingController bcc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaf,
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      appBar: new AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: new Text(
          "Email Sender",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ZefyrScaffold(
        child: Form(
          key: _formKey,
          child: new ListView(
            children: <Widget>[
              
              TextFiledMaterial(
                controller: subject,
                name: 'Subject',
              ),
              TextFiledMaterial(
                controller: recipents,
                name: 'Recipents',
              ),
           
              TextFiledMaterial(
                controller: bcc,
                name: 'BCC',
              ),
              ListTile(
                  onTap: () async {
                    File file = await FilePicker.getFile();

                    files = file;
                  },
                  title: new Text("Attached File"),
                  subtitle: files == null ? null : Text(files.toString())),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                color: Colors.grey[200],
                child: ZefyrField(
                  keyboardAppearance: Brightness.dark,
                  height: 200.0,
                  decoration: InputDecoration(
                    
                    labelText: 'Description',
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.black
                    )
                    ),
                  controller: _body,
                  focusNode: _focusNode,
                  autofocus: false,
                  imageDelegate: CustomImageDelegate(),
                  physics: ClampingScrollPhysics(),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: new FlatButton(
          padding: EdgeInsets.all(13.0),
          color: Colors.black,
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          onPressed: ()  async {
                if (_formKey.currentState.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.

    }
    
    var oks = NotusDocument.fromDelta(_body.document.toDelta());
        files == null ? 
send(oks.toPlainText().toString()) : sends(oks.toPlainText().toString()) ;

          },
         child: new Text("Send Mail",style: TextStyle(
           color: Colors.white,
           fontSize: 20.0
         ),)),
      ),
    );
  }

  void send(des) {
  // If you want to use an arbitrary SMTP server, go with `new SmtpOptions()`.
  // This class below is just for convenience. There are more similar classes available.
  var options = new GmailSmtpOptions()
    ..username = '' // enter your mail
    ..password = ''; // enter your app password 
    // Note: if you have Google's "app specific passwords" enabled,
                                        // you need to use one of those here.
                   //   NotusDocument()                  
  // How you use and store passwords is up to you. Beware of storing passwords in plain.

  // Create our email transport.
  var emailTransport = new SmtpTransport(options);

  // Create our mail/envelope.
  var envelope = new Envelope()
    ..from = bcc.text
    ..recipients.add(recipents.text)
    ..bccRecipients.add(bcc.text)
    ..subject = subject.text
//..attachments.add(new Attachment(file: files))
    ..text = 'This is a cool email message. Whats up?'
    ..html =  des.toString();

  // Email it.
  emailTransport.send(envelope)
    .then((envelope){
bcc.clear();
recipents.clear();
subject.clear();
_body.document.delete(0, _body.document.length);
setState(() {
  
});
_scaf.currentState.showSnackBar(SnackBar(content: new Text("Email sent!")));
    } )
    .catchError((e){
_scaf.currentState.showSnackBar(SnackBar(content: new Text("'Error occurred: $e")));

    } );
}

  void sends(des) {
  // If you want to use an arbitrary SMTP server, go with `new SmtpOptions()`.
  // This class below is just for convenience. There are more similar classes available.
  var options = new GmailSmtpOptions()
    ..username = ''
    ..password = ''; // Note: if you have Google's "app specific passwords" enabled,
                                        // you need to use one of those here.
                   //   NotusDocument()                  
  // How you use and store passwords is up to you. Beware of storing passwords in plain.

  // Create our email transport.
  var emailTransport = new SmtpTransport(options);

  // Create our mail/envelope.
  var envelope = new Envelope()
    ..from = bcc.text
    ..recipients.add(recipents.text)
    ..bccRecipients.add(bcc.text)
    ..subject = subject.text
..attachments.add(new Attachment(file: files))
    ..text = 'This is a cool email message. Whats up?'
    ..html =  des.toString();

  // Email it.
  emailTransport.send(envelope)
    .then((envelope){
bcc.clear();
recipents.clear();
subject.clear();
_body.document.delete(0, _body.document.length);
files.delete();
setState(() {
  
});

_scaf.currentState.showSnackBar(SnackBar(content: new Text("Email sent!")));
    } )
    .catchError((e){
_scaf.currentState.showSnackBar(SnackBar(content: new Text("'Error occurred: $e")));

    } );
}

}

