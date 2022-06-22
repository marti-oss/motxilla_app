import 'package:Motxilla/menu.dart';
import 'package:Motxilla/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:Motxilla/Resp.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  String token = "";
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

  Future<Resp> loginUser(String user, String pass) async {
    var body = jsonEncode({'username': user, 'password':  pass});
    final response = await http.post(
      Uri.parse('https://motxilla-api.herokuapp.com/api/login_check'),
      headers: {'Content-Type': 'application/json'},
      body: body
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      final storage = new FlutterSecureStorage();
      await storage.write(
          key: 'jwt', value:json['token']);
      token = json['token'];
      return Resp.fromJson(json);
    } else {
      throw Exception('Failed to load response');
    }
  }

  Future<Resp> getIdMonitorAutentificat() async {
    final response = await http.get(
      Uri.parse('https://motxilla-api.herokuapp.com/tokenid'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var id = json['data']![0]['id'].toString();
      final storage = new FlutterSecureStorage();
      await storage.write(
          key: 'idMonitor', value:id);
      return Resp.fromJson2(json);
    } else {
      throw Exception('Failed to load response');
    }
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
                                hintText: 'Correu electrònic',
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
                                hintText: 'Contrasenya',
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
                            loginUser(user, pass).then((respuesta) async {
                              if(respuesta.success == false){
                                correct = false;
                                setState(() {});
                                toast("Dades incorrectes", bgColor: Colors.red);
                              } else {
                                getIdMonitorAutentificat();
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => Menu())
                                );
                              }
                            });
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