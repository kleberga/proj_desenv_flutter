import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formulario_pk/formulario_pk.dart';

class Registro extends StatelessWidget {
  const Registro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá, efetue o registro",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[200],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
            child: FormRegistro(),
          ),
        ),
      ),
    );
  }
}
class FormRegistro extends StatefulWidget {
  const FormRegistro({super.key});

  @override
  State<FormRegistro> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormRegistro> {

  var mostrarErro = false;
  var mensagemErro = '';
  final _formKeyRegistro = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  static const emailTest = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';

  final regex = RegExp(emailTest);

  FirebaseAuth auth = FirebaseAuth.instance;

  Widget fnMostrarErro(){
    return Text(mensagemErro, style: TextStyle(color: Colors.red, fontSize: 18),);
  }

  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKeyRegistro,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            imagePath != null ?
            Stack(
                children: <Widget>[
                Image.file(width: 200, height: 200, File(imagePath!)),
                IconButton(onPressed: (){
                  setState(() {
                    imagePath = null;
                  });
                },
                    icon: Icon(Icons.delete)),
                ],
            ) :
            IconButton(
                  onPressed: () async {
                    var retornoFoto = await Navigator.pushNamed(context, 'foto_registro');
                    if(retornoFoto != null){
                      setState(() {
                        imagePath = retornoFoto as String;
                      });
                    }
                  },
                  icon: Icon(Icons.camera_alt)
              ),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            FormularioComponente().CaixaFormularioRegistroEmail(emailController, false, emailTest),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            FormularioComponente().CaixaFormularioRegistroSenha(senhaController, true),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            Container(
              child: mostrarErro ? fnMostrarErro() : SizedBox.shrink(),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            ElevatedButton(
                onPressed: () async {
                  if(_formKeyRegistro.currentState!.validate()){
                    if(imagePath != null){
                      try{
                        var storage = FirebaseStorage.instance;
                        var reference = storage.ref().child("userAvatar.jpg");
                        var imageFile = File(imagePath!);
                        reference.putFile(imageFile);
                      } on FirebaseException catch(e){
                        print(e.code);
                      }
                      setState(() {
                        mostrarErro = false;
                      });
                    } else {
                      setState(() {
                        mensagemErro = "Tire uma fotografia do seu rosto!";
                        mostrarErro = true;
                      });
                      return;
                    }

                    try {
                      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: senhaController.text
                      );
                      setState(() {
                        mostrarErro = false;
                      });
                      Navigator.pushNamed(context, 'home');
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        setState(() {
                          mensagemErro = "Erro: este e-mail já está registrado. Efetue login.";
                          mostrarErro = true;
                        });
                      } else {
                        setState(() {
                          mensagemErro = "Erro: não foi possível efetuar o registro!";
                          mostrarErro = true;
                        });
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                child: Text("Confirmar")
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            Row(children: <Widget>[
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                      color: Colors.black,
                      height: 36,
                    )),
              ),
              Text("OU"),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Divider(
                      color: Colors.black,
                      height: 36,
                    )),
              ),
            ]),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            InkWell(
              child: Text("Já está cadastrado? Efetue login",
                style: TextStyle(fontSize: 18,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.purple[700],
                    decorationThickness: 2,
                    color: Colors.purple[700]),
              ),
              onTap: () => Navigator.pushNamed(context, 'login'),
            )
          ],
        )
    );
  }
}