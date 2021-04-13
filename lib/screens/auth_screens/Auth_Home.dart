import 'package:bookify/screens/auth_screens/login.dart';
import 'package:bookify/screens/auth_screens/sign_up.dart';
import 'package:bookify/screens/widgets/tab_box.dart';
import 'package:flutter/material.dart';

class LoginAndSignUp extends StatefulWidget {
  @override
  _LoginAndSignUpState createState() => _LoginAndSignUpState();
}

class _LoginAndSignUpState extends State<LoginAndSignUp> {
  int selectTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      'assets/book.png',
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Center(
                          child: Text(
                        "Bookify",
                        style: TextStyle(fontSize: 20),
                      )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TabBoxItem(
                              title: "Login",
                              tabIndex: 0,
                              selectedTab: selectTab,
                              onTap: () {
                                setState(() {
                                  selectTab = 0;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TabBoxItem(
                              title: "Sign Up",
                              tabIndex: 1,
                              selectedTab: selectTab,
                              onTap: () {
                                setState(() {
                                  selectTab = 1;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      IndexedStack(
                        index: selectTab,
                        children: [
                          Login(),
                          SignUp(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
