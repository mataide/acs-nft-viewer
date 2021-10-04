
import 'package:re_walls/core/utils/models/user_models.dart';
import 'package:re_walls/database_helper/rest_data.dart';


abstract class LoginContract{
  void onLoginSuccess(User user);
  void onLoginError(String error);
}

class LoginPagePresenter {
  LoginContract _view;
  RestData api = new RestData();
  LoginPagePresenter(this._view);

//Simulator login
  doLogin(String email, String password){
    api
        .login(null,password, null,null,null,null,email)
        .then((user) => _view.onLoginSuccess(user))
        .catchError((onError) => _view.onLoginError(onError));
  }
}