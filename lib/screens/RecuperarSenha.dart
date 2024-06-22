import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:formulario_pk/formulario_pk.dart';

class RecuperarSenha extends StatelessWidget {
  const RecuperarSenha({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recuperar a senha",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[200],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
          child: FormRecuperar(),
        ),
      ),
    );
  }
}

class FormRecuperar extends StatefulWidget {
  const FormRecuperar({super.key});

  @override
  State<FormRecuperar> createState() => _FormRecuperarState();
}

class _FormRecuperarState extends State<FormRecuperar> {

  var mostrarErro = false;
  var mensagemErro = '';
  final _formKeyRecuperar = GlobalKey<FormState>();
  final emailController = TextEditingController();
  var corMensagem = Colors.green;

  Widget fnMostrarErro(){
    return Text(mensagemErro, style: TextStyle(color: corMensagem, fontSize: 18),);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKeyRecuperar,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormularioComponente().CaixaFormularioLogin(emailController, 'E-mail', false,
                'Informe um e-mail válido!', Icon(Icons.email), "recuperar_email_id"),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            Container(
              child: mostrarErro ? fnMostrarErro() : SizedBox.shrink(),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            ElevatedButton(
                onPressed: () async {
                  if(_formKeyRecuperar.currentState!.validate()){
                    try{
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: emailController.text);
                      setState(() {
                        mensagemErro = "Enviado e-mail para alterar a senha!";
                        mostrarErro = true;
                        corMensagem = Colors.green;
                      });
                    } on FirebaseAuthException catch (e){
                      print(e.code);
                      if(e.code == 'invalid-email'){
                        setState(() {
                          mensagemErro = "Informe um e-mail válido!";
                          mostrarErro = true;
                          corMensagem = Colors.red;
                        });
                      }
                    }
                  }
                },
                child: Text("Enviar")
            )
          ],
        )
    );
  }
}
