import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:proj_desenv_flutter/providers/TarefasProvider.dart';
import 'package:provider/provider.dart';
import '../model/Cidade.dart';

class AddTarefa extends StatelessWidget {
  const AddTarefa({super.key});
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text("Adicionar tarefa",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.blue[200],
    );
    return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
            child: Formulario(),
          ),
        )
    );
  }
}

class Formulario extends StatefulWidget {
  const Formulario({super.key});
  @override
  State<Formulario> createState() => AddTarefaState();
}

class AddTarefaState extends State<Formulario> {

  final _formKey1 = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final descricaoController = TextEditingController();

  Future<LocationData?> getLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionStatus;
    serviceEnabled = await location.serviceEnabled();
    if(!serviceEnabled){
      serviceEnabled = await location.requestService();
      if(!serviceEnabled) return null;
    }
    permissionStatus = await location.hasPermission();
    if(permissionStatus == PermissionStatus.denied){
      permissionStatus = await location.requestPermission();
      if(permissionStatus != PermissionStatus.granted) return null;
    }
    return location.getLocation();
  }

  Future<Cidade> fetchCity(String url) async {
    final response = await http
        .get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Cidade.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load city');
    }
  }

  @override
  Widget build(BuildContext context) {

    final tarefaProvider = context.read<TarefasProvider>();
    final addTarefa = tarefaProvider.addTarefa;

    return Form(
      key: _formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: tituloController,
            decoration: const InputDecoration(
                label: Text('Título', style: TextStyle(fontSize: 20),),
                border: OutlineInputBorder()
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o título da tarefa';
              }
              return null;
            },
          ),
          Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
          TextFormField(
            controller: descricaoController,
            decoration: const InputDecoration(
                label: Text('Descrição', style: TextStyle(fontSize: 20),),
                border: OutlineInputBorder()
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe a descrição da tarefa';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: FutureBuilder(future: getLocation(), builder: (context, snapshot) {
              if(snapshot.data?.latitude != null && snapshot.data?.longitude != null){
                  var latitude = snapshot.data?.latitude;
                  var longitude = snapshot.data?.longitude;
                  var urlCidade = 'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$latitude&longitude=$longitude&localityLanguage=en';
                return FutureBuilder(future: fetchCity(urlCidade),
                    builder: (context, snapshot) {
                      if(snapshot.data != null){
                        return ElevatedButton(
                          onPressed: () async {
                            String titulo;
                            String descricao;
                            if (_formKey1.currentState!.validate()) {
                              titulo = tituloController.text;
                              descricao = descricaoController.text;
                              DateTime agora = DateTime.now();
                              var formatter = DateFormat('dd/MM/yyyy');
                              String formattedDate = formatter.format(agora).toString();
                              addTarefa(titulo: titulo, descricao: descricao, created_at: formattedDate, localizacao: snapshot.data!.city);
                              Navigator.pushNamed(context, 'home');
                            }
                          },
                          child: const Text('Enviar'),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }
                );
              } else {
                return CircularProgressIndicator();
              }
            },
            )
          ),
        ],
      ),
    );
  }
}
