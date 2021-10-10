
  import 'package:url_launcher/url_launcher.dart';

  openMetaMesk() async {
    var url = 'metamask://'; //Abrindo o app do METAMASK
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }