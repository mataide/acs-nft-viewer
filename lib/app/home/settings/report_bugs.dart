import 'package:faktura_nft_viewer/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportBugsView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final _formDescription = GlobalKey<FormState>();
    final state = ref.watch(themeProvider);
    final _deviceHeight = MediaQuery.of(context).size.height;
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _NameController = TextEditingController();
    final _DescriptionController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          iconTheme: state.primaryIconTheme,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
                Text(
                  "REPORT BUGS",
                  style: state.textTheme.caption,
                ),
                SizedBox(height: _deviceHeight * 0.05),
                Center(
                    child: Row(
                  children: [
                    Text(
                      "Name Bug: ",
                      style: state.textTheme.caption,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: Form(
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
                                      border:
                                          Border.all(color: state.primaryColor),
                                      color: state.primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(15.0))),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: (_deviceWidth * 0.04),
                                      right: (_deviceWidth * 0.04)),
                                  child: Center(
                                    child: TextFormField(
                                      autofocus: true,
                                      textAlign: TextAlign.center,
                                      controller: _NameController,
                                      style: state.textTheme.headline5,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Name';
                                        }
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Insert Name",
                                        errorStyle: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'FuturaPTLight.otf',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.red),
                                        focusedErrorBorder:
                                            new OutlineInputBorder(
                                                borderSide: new BorderSide(
                                                    color: Colors.red,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                        //hintStyle: state.textTheme.headline5,
                                      ),
                                    ),
                                  )),
                            ],
                          )),
                    ),
                  ],
                )),
                SizedBox(
                  height: _deviceHeight * 0.05,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Description: ",
                      style: state.textTheme.subtitle2,
                    )),
                SizedBox(
                  height: _deviceHeight * 0.02,
                ),
                Container(
                    margin: EdgeInsets.only(
                        left: (_deviceWidth * 0.002),
                        right: (_deviceWidth * 0.002)),
                    color: state.primaryColorDark,
                    child: Flexible(
                        child: Form(
                            key: _formDescription,
                            child:Stack(
                    children: [
                            Container(
                                margin: EdgeInsets.only(
                                    left: (_deviceWidth * 0.01),
                                    right: (_deviceWidth * 0.01)),
                            decoration: BoxDecoration(
                                border:
                                Border.all(color: state.primaryColorDark),
                                color: state.primaryColor,
                                borderRadius:
                                BorderRadius.circular(15.0))),
                             Padding(
                                padding: EdgeInsets.only(
                                    left: (_deviceWidth * 0.04),
                                    right: (_deviceWidth * 0.04)),
                                child:TextFormField(
                              textAlign: TextAlign.left,
                              controller: _DescriptionController,
                              style: state.textTheme.headline5,
                              maxLines: 10,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Description';
                                }
                              },
                            ))])))),
                SizedBox(
                  height: _deviceHeight * 0.08,
                ),
                ButtonTheme(
                  height: 60.0,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _formDescription.currentState!.validate()) {
                        print("pressionei o botão");
                      }
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    child: Text(
                      "Enviar",
                      style: state.textTheme.bodyText2,
                    ),
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}
