import 'package:bookify/helpers/auth_helper.dart';
import 'package:bookify/screens/bookshop_owner_screens/owner_home_screen.dart';
import 'package:bookify/screens/widgets/auth_input_field.dart';
import 'package:bookify/screens/widgets/custom_button.dart';
import 'package:bookify/utils/constants.dart';
import 'package:bookify/utils/static_info.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailCon = TextEditingController(),
      passwordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              AuthInputField(
                hint: "Email",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                controller: emailCon,
              ),
              SizedBox(height: 10),
              AuthInputField(
                hint: "Password",
                icon: Icons.lock,
                obscure: true,
                controller: passwordCon,
              ),
              SizedBox(height: 50),
              Container(
                width: double.infinity,
                child: CustomButton(
                  text: "Login".toUpperCase(),
                  onPressed: () => _login(context),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  "Forgot password?".toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: const Color(0xff4c3f58),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  _login(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());

    String email = emailCon.text.trim();
    String password = passwordCon.text;

    if (email.isEmpty || password.isEmpty) {
      Toast.show("Fill all fields", context, duration: 3);
      return;
    } else if (!GetUtils.isEmail(email)) {
      Toast.show("Invalid email address", context, duration: 3);
      return;
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      ProgressDialog dialog = ProgressDialog(context);
      dialog.style(
        progressWidget: CircularProgressIndicator(),
        message: "Please wait",
      );
      dialog.show();

      var result = await AuthHelper().login(email, password);
      print(result);
      dialog.hide();
      if (result == Constants.success) {
        Widget page;
        if (StaticInfo.user.accountType == Constants.user) {
        } else if (StaticInfo.user.accountType == Constants.owner) {
          // page = OwnerHomeScreen();
        } else if (StaticInfo.user.accountType == Constants.admin) {}
        page = OwnerHomeScreen();

        Get.offAll(page);
      } else {
        if (result == AuthStatus.ERROR_INVALID_EMAIL) {
          Toast.show("Email address is invalid", context, duration: 3);
        } else if (result == AuthStatus.ERROR_WRONG_PASSWORD) {
          Toast.show("Wrong password", context, duration: 3);
        } else if (result == AuthStatus.ERROR_USER_NOT_FOUND) {
          Toast.show("User not found", context, duration: 3);
        } else {
          Toast.show("$result", context, duration: 3);
        }
      }
    } else {
      Toast.show("Check your internet connection", context, duration: 3);
    }
  }
}
