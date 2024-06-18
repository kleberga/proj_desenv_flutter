import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:proj_desenv_flutter/providers/TarefasProvider.dart';
import 'package:proj_desenv_flutter/screens/AddTarefa.dart';
import 'package:proj_desenv_flutter/screens/FotoRegistro.dart';
import 'package:proj_desenv_flutter/screens/Login.dart';
import 'package:proj_desenv_flutter/screens/RecuperarSenha.dart';
import 'package:proj_desenv_flutter/screens/Registro.dart';
import 'package:proj_desenv_flutter/screens/UpdateTarefa.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/Home.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
    ChangeNotifierProvider(
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
    )
);
}


