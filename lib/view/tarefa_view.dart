import 'package:aula11_calc/model/tarefa_model.dart';
import 'package:aula11_calc/presenter/tarefa_presenter.dart';
import 'package:flutter/material.dart';

class TarefaView extends StatefulWidget {
  final TarefaPresenter presenter;

  TarefaView({required this.presenter});

  @override
  _TarefasViewState createState() => _TarefasViewState();
}

class _TarefasViewState extends State<TarefaView> {
  late Future<List<Tarefa>> _tarefas;
    late Future<List<Tarefa>> _tmp;
  List<Tarefa> _tarefasBanco = [];
  List<Tarefa> _tarefasFiltradas = [];
  String _filtro = '';

  @override
  void initState() {
    super.initState();
    _tarefas = widget.presenter.carregarTarefas();
    _tarefas.then((tarefas) {
      setState(() {
        _tarefasBanco = tarefas;
        _tarefasFiltradas = tarefas;
      });
    });
  }

  // Método para filtrar as tarefas com base no título ou outro critério
  void _filtrarTarefas(String filtro) {
    setState(() {
      _filtro = filtro;
      if (_filtro.isEmpty) {
        _tmp = widget.presenter.carregarTarefas();
        _tmp.then((tarefas) {
          setState(() {
            _tarefasFiltradas = tarefas;
          });
        });
      }else{
      _tarefasFiltradas = _tarefasFiltradas
          .where((tarefa) =>
              tarefa.titulo.toLowerCase().contains(filtro.toLowerCase()))
          .toList();
      }
    });
  }

/// Atualizar a lista com as notas
  void _carregarTarefas(){
    _tarefas = widget.presenter.carregarTarefas();
    _tarefas.then((tarefas) {
      setState(() {
        _tarefasBanco = tarefas;
        _tarefasFiltradas = tarefas;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas dos Trabalhos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Filtrar Tarefas',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _filtrarTarefas(value); // Chama a função de filtro ao alterar o texto
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Tarefa>>(
              future: _tarefas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar tarefas'));
                }

                final tarefas = _tarefasFiltradas;

                return ListView.builder(
                  itemCount: tarefas.length,
                  itemBuilder: (context, index) {
                    final tarefa = tarefas[index];

                    return ListTile(
                      title: Text(tarefa.titulo),
                      subtitle: Text('Peso: ${tarefa.peso}'),
                      trailing: Container(
                        width: 100,
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Nota'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            tarefa.nota = double.tryParse(value);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          final tarefas = await _tarefas;
          await widget.presenter.salvarTarefas(tarefas);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Notas salvas com sucesso')),
          );
          //_carregarTarefas();
        },
      ),
    );
  }
}
