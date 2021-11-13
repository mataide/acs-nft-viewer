import 'package:flutter/material.dart';

class ModalConnected {
  modalConnected(BuildContext context, state, dataState) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          final width = MediaQuery.of(context).size.width;
          final height = MediaQuery.of(context).size.height;

          return Container(
              margin:
                  EdgeInsets.only(left: (width * 0.02), right: (width * 0.02)),
              //padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                  color: state.primaryColor,
                  border: Border.all(color: state.primaryColor),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0))),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                SizedBox(height: height * 0.0185),
                Row(
                  children: [
                    SizedBox(width: width * 0.13),
                    Text("wallet",
                        style: TextStyle(
                            fontFamily: "MavenPro-Regular",
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0)),
                    Expanded(
                        child: Text(
                            dataState.listAddress.toString().length > 8
                                ? dataState.listAddress.toString().substring(0,
                                    dataState.listAddress.toString().length - 8)
                                : dataState.listAddress.toString(),
                            maxLines: 1,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                                fontFamily: "MavenPro-Regular",
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0))),
                    Expanded(
                        child: Text(
                      dataState.listAddress.toString().length > 8
                          ? dataState.listAddress.toString().substring(
                              dataState.listAddress.toString().length - 8)
                          : '',
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      softWrap: false,
                    )),
                  ],
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: (width * 0.04), right: (width * 0.04)),
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: state.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        fixedSize: Size((width * 1.1), (height * 0.08)),
                        side: BorderSide(color: Colors.red),
                        alignment: Alignment.center),
                    child: Row(children: [
                      SizedBox(
                        width: width * 0.24,
                      ),
                      Icon(Icons.delete_outlined, color: Colors.red),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      Text(
                        "Remove wallet",
                        style: TextStyle(
                            color: state.textTheme.bodyText1!.color,
                            fontSize: 16.0,
                            fontFamily: "MavenPro-Regular",
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ]),
                    onPressed: () {},
                  ),
                ),
                SizedBox(height: height * 0.0185),
              ]));
        });
  }
}