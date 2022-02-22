import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faktura_nft_viewer/core/providers/providers.dart';
import 'package:faktura_nft_viewer/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';


class ReportBugsView extends ConsumerWidget {
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formMessage = GlobalKey<FormState>();
  final FirebaseStorage storage = FirebaseStorage.instance;
  String url = "";

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<String> upload(String path) async {
    File file = File(path);
    try {
      final Reference storageReference = FirebaseStorage.instance.ref();
      UploadTask uploadTask = storageReference
          .child('img-${DateTime.now().toString()}.jpg')
          .putFile(file);
      url = await (await uploadTask).ref.getDownloadURL();
      //print(url);
      return url;
    } on FirebaseException catch (e) {
      throw Exception('error upload: ${e.code}');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(themeProvider);
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;
    final dataState = ref.read(loginProvider.notifier);
    final data = ref.watch(loginProvider);
    final CollectionReference _feedbacks =
        FirebaseFirestore.instance.collection('feedback');
    String category = "";

    return Scaffold(
        backgroundColor: state.primaryColor,
        appBar: AppBar(
          iconTheme: state.primaryIconTheme,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: SingleChildScrollView(
                    child: Container(
                        height: _deviceHeight,
                        width: _deviceWidth,
                        child: Column(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Send us your feedback!",
                                  style: state.textTheme.caption,
                                )),
                            SizedBox(height: _deviceHeight * 0.03),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Do you have a suggestion or want to report a bug?\nLet us know in the field bellow.",
                                  style: state.textTheme.headline4,
                                )),
                            SizedBox(
                              height: _deviceHeight * 0.03,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Category : ",
                                  style: state.textTheme.subtitle2,
                                )),
                            Container(
                                height: _deviceHeight * 0.07,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Theme(
                                            data: state.copyWith(
                                                unselectedWidgetColor:
                                                    state.cardColor),
                                            child: Radio(
                                                value: 0,
                                                groupValue: data.val,
                                                onChanged: (dynamic value) {
                                                  dataState.setFeedBack(value);
                                                  _descriptionController.text =
                                                      "";
                                                  _emailController.text = "";
                                                }))),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "BUG",
                                          style: state.textTheme.bodyText2,
                                        )),
                                    SizedBox(
                                      width: _deviceWidth * 0.04,
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Theme(
                                            data: state.copyWith(
                                                unselectedWidgetColor:
                                                    state.cardColor),
                                            child: Radio(
                                                value: 1,
                                                groupValue: data.val,
                                                onChanged: (dynamic value) {
                                                  dataState.setFeedBack(value);
                                                  _descriptionController.text =
                                                      "";
                                                  _emailController.text = "";
                                                  // category = 'SUGGESTION';
                                                }))),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "SUGGESTION",
                                          style: state.textTheme.bodyText2,
                                        )),
                                    SizedBox(
                                      width: _deviceWidth * 0.04,
                                    ),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Theme(
                                            data: state.copyWith(
                                                unselectedWidgetColor:
                                                    state.cardColor),
                                            child: Radio(
                                                value: 2,
                                                groupValue: data.val,
                                                onChanged: (dynamic value) {
                                                  dataState.setFeedBack(value);
                                                  _descriptionController.text =
                                                      "";
                                                  _emailController.text = "";
                                                  //category = "OTHERS";
                                                }))),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "OTHERS",
                                          style: state.textTheme.bodyText2,
                                        )),
                                    SizedBox(
                                      width: _deviceWidth * 0.04,
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: _deviceHeight * 0.015,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Your email : ",
                                  style: state.textTheme.subtitle2,
                                )),
                            SizedBox(
                              height: _deviceHeight * 0.02,
                            ),
                            Form(
                                key: _formKey,
                                child: Stack(
                                  children: [
                                    Container(
                                        height: _deviceHeight * 0.07,
                                        width: _deviceWidth * 0.9,
                                        margin: EdgeInsets.only(
                                            left: (_deviceWidth * 0.04),
                                            right: (_deviceWidth * 0.04)),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: state.primaryColorDark),
                                            color: state.primaryColorDark,
                                            borderRadius:
                                                BorderRadius.circular(15.0))),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: (_deviceWidth * 0.04),
                                            right: (_deviceWidth * 0.04)),
                                        child: Center(
                                          child: TextFormField(
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            textAlign: TextAlign.center,
                                            controller: _emailController,
                                            style: state.textTheme.headline5,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your Email';
                                              }
                                              if (!RegExp(r'\S+@\S+\.\S+')
                                                  .hasMatch(value)) {
                                                return "Please enter a valid Email address";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "example@email.com",
                                              errorStyle: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily:
                                                      'FuturaPTLight.otf',
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.red),
                                              focusedErrorBorder:
                                                  new OutlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                              color: Colors.red,
                                                              width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                            ),
                                          ),
                                        )),
                                  ],
                                )),
                            SizedBox(
                              height: _deviceHeight * 0.03,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Message : ",
                                  style: state.textTheme.subtitle2,
                                )),
                            SizedBox(
                              height: _deviceHeight * 0.02,
                            ),
                            Form(
                                key: _formMessage,
                                child: Stack(
                                  children: [
                                    Container(
                                        height: _deviceHeight * 0.244,
                                        width: _deviceWidth * 0.9,
                                        margin: EdgeInsets.only(
                                            left: (_deviceWidth * 0.04),
                                            right: (_deviceWidth * 0.04)),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: state.primaryColorDark),
                                            color: state.primaryColorDark,
                                            borderRadius:
                                                BorderRadius.circular(15.0))),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: (_deviceWidth * 0.04),
                                            right: (_deviceWidth * 0.04)),
                                        child: Center(
                                          child: TextFormField(
                                            maxLines: 10,
                                            textAlign: TextAlign.center,
                                            controller: _descriptionController,
                                            style: state.textTheme.headline5,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Insert Describe';
                                              }
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  "describe your experience here",
                                              errorStyle: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily:
                                                      'FuturaPTLight.otf',
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.red),
                                              focusedErrorBorder:
                                                  new OutlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                              color: Colors.red,
                                                              width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                            ),
                                          ),
                                        )),
                                  ],
                                )),
                            SizedBox(
                              height: _deviceHeight * 0.015,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    height: _deviceHeight * 0.07,
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                dataState
                                                    .setFile(await getImage());
                                              },
                                              style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      state.indicatorColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0)),
                                                  fixedSize: Size(
                                                      (_deviceWidth * 0.3),
                                                      (_deviceHeight * 0.05))),
                                              child: Text("Add Attachment",
                                                  style: state
                                                      .textTheme.bodyText2)),
                                          SizedBox(
                                            width: _deviceWidth * 0.05,
                                          ),
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                data.file != null
                                                    ? "Attached File "
                                                    : "",
                                                style:
                                                    state.textTheme.bodyText2,
                                              )),
                                        ]))),
                            SizedBox(
                              height: _deviceHeight * 0.02,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate() &&
                                    _formMessage.currentState!.validate()) {
                                  if (data.val == 0) {
                                    category = "BUG";
                                  } else if (data.val == 1) {
                                    category = "SUGGESTION";
                                  } else {
                                    category = "OTHERS";
                                  }
                                  if (data.file != null) {
                                    await upload(data.file!.path);
                                  }
                                  final String? email = _emailController.text;
                                  final String? message =
                                      _descriptionController.text;
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  showAlertDialog2(
                                      context,
                                      state,
                                      _deviceHeight,
                                      _emailController,
                                      _descriptionController);

                                  await _feedbacks.add({
                                    "email": email,
                                    "message": message,
                                    "category": category,
                                    "time": Timestamp.now(),
                                    "url": url,
                                  });
                                }
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: state.indicatorColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  fixedSize: Size((_deviceWidth * 1.1),
                                      (_deviceHeight * 0.07))),
                              child: Text(
                                "SEND FEEDBACK",
                                style: state.textTheme.caption,
                              ),
                            ),
                          ],
                        ))),
              )),
        ));
  }
}

showAlertDialog2(BuildContext context, state, _deviceHeight, _emailController,
    _descriptionController) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: state.primaryColor,
          title: Center(
              child: Text("Feedback sent Success!",
                  style: state.textTheme.subtitle2)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Thanks for your feedback.",
                style: state.textTheme.headline5,
              ),
              SizedBox(
                height: _deviceHeight * 0.02,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: state.buttonColor),
                  child: Text("OK", style: state.textTheme.headline4),
                  onPressed: () {
                    _emailController.text = "";
                    _descriptionController.text = "";
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      });
}
