import 'package:faktura_nft_viewer/controllers/home/settings/settings_login_controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  color: state.primaryColorDark,
                  border: Border.all(color: state.primaryColorDark),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0))),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                SizedBox(height: height * 0.0185),
                Row(
                  children: [
                    SizedBox(width: width * 0.13),
                    Text("wallet",
                        style: state.textTheme.bodyText2),
                    SizedBox(width: width * 0.08,),
                    Expanded(
                        child: Text(
                            dataState.listAddress.toString().length > 8
                                ? dataState.listAddress.toString().substring(1,
                                    dataState.listAddress.toString().length - 8)
                                : dataState.listAddress.toString(),
                            maxLines: 1,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: state.textTheme.bodyText2)),
                    Expanded(
                        child: Text(
                      dataState.listAddress.toString().length > 8
                          ? dataState.listAddress.toString().substring(
                              dataState.listAddress.toString().length - 8)
                          : '',
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      softWrap: false,
                          style: state.textTheme.bodyText2,
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
                        style: state.textTheme.headline5,
                        textAlign: TextAlign.center,
                      ),
                    ]),
                    onPressed: (){

                    }

                  ),
                ),
                SizedBox(height: height * 0.0185),
              ]));


        });

  }

}
