import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:formulario_pk/formulario_pk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá, efetue login",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[200],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
          child: FormLogin(),
        ),
      ),
    );
  }
}
class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => FormLoginState();
}



class FormLoginState extends State<FormLogin> {

  var mostrarErro = false;
  var mensagemErro = '';
  final _formKeyLogin = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  Widget fnMostrarErro(){
    return Text(mensagemErro, style: TextStyle(color: Colors.red, fontSize: 18),);
  }



  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKeyLogin,
        child: Column(
          children: <Widget>[
            FormularioComponente().CaixaFormularioLogin(emailController, 'E-mail', false,
                'Informe um e-mail válido!', Icon(Icons.email), "login_email_id"),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            FormularioComponente().CaixaFormularioLogin(senhaController, 'Senha', true,
                'Informe uma senha válida!', Icon(Icons.key), "login_senha_id"),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            Container(
              child: mostrarErro ? fnMostrarErro() : SizedBox.shrink(),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  key: Key("botao_enviar_key"),
                    onPressed: () async {
                      if(_formKeyLogin.currentState!.validate()){
                        try {
                          var obterLogin = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: senhaController.text
                          );
                          setState(() {
                            mostrarErro = false;
                          });
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('user_id', obterLogin.user!.uid);
                          Navigator.pushNamed(context, 'home');
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-credential') {
                            setState(() {
                              mensagemErro = "Usuário ou senha inválidos!";
                              mostrarErro = true;
                            });
                            print("teste");
                          } else if(e.code == 'invalid-email') {
                            setState(() {
                              mensagemErro = "Informe um e-mail válido!";
                              mostrarErro = true;
                            });
                          } else {
                            setState(() {
                              mensagemErro = "Erro ao efetuar login!";
                              mostrarErro = true;
                            });
                          }
                        }
                      }
                    },
                    child: Text("Enviar")
                ),
                Padding(padding: EdgeInsets.only(left: 20)),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'recuperar_senha');
                    },
                    child: Text("Esqueci a senha")
                )
              ],
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
            Center(
              child: InkWell(
                child: Text("Não está cadastrado? Efetue o registro",
                  style: TextStyle(fontSize: 18,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.purple[700],
                      decorationThickness: 2,
                      color: Colors.purple[700]),
                ),
                onTap: () => Navigator.pushNamed(context, 'registro'),
            )
            )
          ],
        )
    );
  }
}

