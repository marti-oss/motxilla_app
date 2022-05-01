import 'package:Motxilla/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}


class LoginState extends State<Login> {
  bool showPassword = false;
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  String user = "";
  String pass = "";
  bool correct = true;
  @override

  void initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap:() {
            final FocusScopeNode focus = FocusScope.of(context);
            if (!focus.hasPrimaryFocus && focus.hasFocus){
              FocusManager.instance.primaryFocus?.unfocus();
            }
        },
          child:SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    child:  Column(
                      children: [
                        Container(
                          child: Image.asset(motxilla_logo_lletresHoritzontals, width: 200,height: 200)
                        )
                      ],
                    )
                  ),
                  Container(
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(color: Colors.grey[100]),
                            child: TextFormField(
                              cursorColor: const Color(0x683210),
                              focusNode: emailNode,
                              autofocus: false,
                              textInputAction: TextInputAction.next,
                              style: secondaryTextStyle(
                                color: correct ? Colors.black : Colors.red),
                                onFieldSubmitted: (term) {
                                  emailNode.unfocus();
                                  FocusScope.of(context).requestFocus(passwordNode);
                                },
                              onChanged: (newValue) {
                                user = newValue;
                                correct = true;
                                setState(() { });
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Name',
                                hintStyle: secondaryTextStyle(size:16),
                              ) ,
                            ).paddingOnly(left: 8,top:2),
                          ).cornerRadiusWithClipRRect(12),
                          Container(
                            decoration: BoxDecoration(color: Colors.grey[100]),
                            child: TextFormField(
                              cursorColor: const Color(0x683210),
                              focusNode: passwordNode,
                              autofocus: false,
                              obscureText: showPassword ? false : true,
                              keyboardType: TextInputType.emailAddress,
                              style: secondaryTextStyle(
                                  color: correct ? Colors.black : Colors.red),
                              onChanged: (newValue) {
                                pass = newValue;
                                correct = true;
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    showPassword = !showPassword;
                                    setState(() {});
                                  },
                                  child: Icon(
                                      showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Color(0x683210)),
                                ),
                                border: InputBorder.none,
                                hintText: 'Password',
                                hintStyle: secondaryTextStyle(size: 16),
                              ),
                            ).paddingOnly(left: 8, top: 2),
                          ).cornerRadiusWithClipRRect(12).paddingOnly(top: 16, bottom: 16),
                        ],
                      )
                    )
                  ).paddingTop(32),
                  Container(
                    child: Column(
                      children: [
                        TextButton(onPressed: () {
                          if (user=="" || pass == ""){
                            correct = false;
                            setState(() {});
                            toast(("Rellenar Campos"), bgColor: Colors.red);
                          }
                          else {
                            Navigator.pushNamed(context, "barra");
                          }
                        }, child: Text("Login")).paddingOnly(top: 16, bottom: 16),
                      ]
                    )
                  ).paddingTop(32)
                ],
              )
            )
          )
        ).paddingOnly(top:16, left:16, right:16)
      )

    );
  }
}