import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proj_desenv_flutter/firebase_options.dart';
import 'package:integration_test/integration_test.dart';
import 'package:proj_desenv_flutter/screens/AddTarefa.dart';
import 'package:proj_desenv_flutter/screens/FotoRegistro.dart';
import 'package:proj_desenv_flutter/screens/Home.dart';
import 'package:proj_desenv_flutter/screens/Login.dart';
import 'package:proj_desenv_flutter/providers/TarefasProvider.dart';
import 'package:proj_desenv_flutter/screens/RecuperarSenha.dart';
import 'package:proj_desenv_flutter/screens/Registro.dart';
import 'package:proj_desenv_flutter/screens/UpdateTarefa.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  group("Teste end-to-end", () {

    testWidgets("Teste 1 - Clique no botão 'Enviar' para fazer login", (tester) async {
          // Inicializar o Firebase
          await Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform
          );
          // Carregar o widget do app
          await tester.pumpWidget(  ChangeNotifierProvider(
            create: (context) => TarefasProvider(),
            child:MaterialApp(
              home: Login(),
              debugShowCheckedModeBanner: false,
              routes: {
                'home': (context) => Home(),
                'adicionar_taref': (context) => AddTarefa(),
                'update_taref': (context) => UpdateTarefa(),
                'registro': (context) => Registro(),
                'login': (context) => Login(),
                'recuperar_senha': (context) => RecuperarSenha(),
                'foto_registro': (context) => FotoRegistro()
              },
            ),
          ));
          // Encontrar a caixa de e-mail de login
          final email_login = await find.byKey(const ValueKey('login_email_id'));
          // Inserir um email valido
          await tester.enterText(email_login, "klebe1@gmail.com");
          // Encontrar a caixa de senha de login
          final senha_login = await find.byKey(const ValueKey('login_senha_id'));
          // Inserir a senha correta
          await tester.enterText(senha_login, "Kga13142536@");
          // Encontrar o botão de enviar
          final botao_enviar = await find.byKey(Key('botao_enviar_key'));

          // Simular o toque no botão Enviar
          await tester.tap(botao_enviar);
          // Obter instancia do SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          // Obter a ID do usuario
          final uid_user = prefs.getString('user_id');
          // Testar se existe ID
          var testeCredencial;
          if(uid_user != null){
            testeCredencial = true;
          }

          // Verificar se o login foi executado
          expect(true, testeCredencial);
        });
  });
}