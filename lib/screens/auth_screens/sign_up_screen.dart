import 'package:bookify/helpers/auth_helper.dart';
import 'package:bookify/models/user.dart';
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

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameCon, emailCon, passwordCon, confirmCon;
  bool isForBusiness;

  @override
  void initState() {
    super.initState();

    isForBusiness = false;
    nameCon = TextEditingController();
    emailCon = TextEditingController();
    passwordCon = TextEditingController();
    confirmCon = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          AuthInputField(
            hint: "Name",
            icon: Icons.person,
            controller: nameCon,
          ),
          SizedBox(height: 5),
          AuthInputField(
            hint: "Email",
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            controller: emailCon,
          ),
          SizedBox(height: 5),
          AuthInputField(
            hint: "Password",
            icon: Icons.lock,
            obscure: true,
            controller: passwordCon,
          ),
          SizedBox(height: 5),
          AuthInputField(
            hint: "Confirm Password",
            icon: Icons.lock,
            obscure: true,
            controller: confirmCon,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Are you signing up as Owner?",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: const Color(0xff4c3f58),
                    //  fontWeight: FontWeight.w500,
                  ),
                ),
                Switch(
                  value: isForBusiness,
                  activeColor: Theme.of(context).primaryColor,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey.withOpacity(0.2),
                  activeTrackColor:
                      Theme.of(context).primaryColor.withOpacity(0.5),
                  onChanged: (val) {
                    setState(() {
                      isForBusiness = !isForBusiness;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: CustomButton(
              text: "Sign Up".toUpperCase(),
              onPressed: () {
                _signUp();
              },
            ),
          ),
          SizedBox(height: 20),
          Text(
            'By Signing up, you agree to our',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: const Color(0xff4c3f58),
            ),
          ),
          GestureDetector(
            onTap: () {
              //   Get.to(TermsAndCondition());
            },
            child: Text(
              'Privacy Policy',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _signUp() async {
    FocusScope.of(context).requestFocus(FocusNode());

    String name = nameCon.text.trim();
    String email = emailCon.text.trim();
    String password = passwordCon.text;
    String confirmPassword = confirmCon.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Toast.show("Fill all fields", context, duration: 3);
      return;
    } else if (password != confirmPassword) {
      Toast.show('Password does not match', context, duration: 3);
      return;
    }
    if (!email.contains("@") && !email.contains(".com")) {
      Toast.show('Invalid email address', context, duration: 3);
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

      UserModel user = UserModel(
        name: name,
        email: email,
        accountType: isForBusiness ? Constants.owner : Constants.user,
      );

      var result = await AuthHelper().signUp(user, password);
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
        } else if (result == AuthStatus.ERROR_WEAK_PASSWORD) {
          Toast.show("Password should be at least 6 characters", context,
              duration: 3);
        } else if (result == AuthStatus.ERROR_EMAIL_ALREADY_IN_USE) {
          Toast.show("Email already in use", context, duration: 3);
        } else {
          Toast.show("$result", context, duration: 3);
        }
      }
    } else {
      Toast.show("Please check your internet connection", context, duration: 3);
    }
  }
}
