import 'dart:convert';
import 'package:aula11_calc/dao/tarefa_dao.dart';
import 'package:aula11_calc/model/tarefa_model.dart';
import 'package:flutter/services.dart';

class TarefaPresenter {
  final TarefaDao db;

  TarefaPresenter(this.db);

  // Carregar JSON transformando em uma lista de tarefas
  Future<List<Tarefa>> carregarTarefas() async {
    final jsonString = await rootBundle.loadString('assets/notas.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData.map((item) => Tarefa.fromJson(item)).toList();
  }

  // Calcular a nota final
  double calcularNotaFinal(List<Tarefa> tarefas) {
    return 0;
  }

  // Salvar notas no banco
  Future<void> salvarTarefas(List<Tarefa> tarefas) async {
    for (var tarefa in tarefas) {
      tarefa.timestamp = DateTime.now();
      await db.inserirTarefa(tarefa);
    }
  }
  
}

