import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:proj_desenv_flutter/model/Cidade.dart';
import 'package:test/test.dart';
import 'package:location/location.dart';
import 'package:proj_desenv_flutter/screens/AddTarefa.dart';


void main(){

  group("Testar a conversão de latitude e longitude em nome de cidade por meio de consulta em API", () {

    test('A localização esperada é Brasilia', () async {

      AddTarefaState adicionarTarefa = AddTarefaState();
      var latitude = '-15.859999656677246';
      var longitude = '-48.040000915527344';
      var urlTest = 'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$latitude&longitude=$longitude&localityLanguage=en';

      await adicionarTarefa.fetchCity(urlTest).then((value) {
        var cidade = value.city;
        expect("Brasilia", cidade);
        print('A localização esperada é Brasilia. A localização obtida foi $cidade');
      });
    });

    test('A localização esperada é San Jose', () async {

      AddTarefaState adicionarTarefa = AddTarefaState();
      var latitude = '37.4219983';
      var longitude = '-122.084';
      var urlTest = 'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$latitude&longitude=$longitude&localityLanguage=en';

      await adicionarTarefa.fetchCity(urlTest).then((value) {
        var cidade = value.city;
        expect("San Jose", cidade);
        print('A localização esperada é San Jose. A localização obtida foi $cidade');
      });
    });
  });

}