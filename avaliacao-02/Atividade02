import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
    };
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
      'dependentes': _dependentes.map((d) => d.toJson()).toList(),
    };
  }
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  Map<String, dynamic> toJson() {
    return {
      'nomeProjeto': _nomeProjeto,
      'funcionarios': _funcionarios.map((f) => f.toJson()).toList(),
    };
  }
}

void main() {
  var dep1 = Dependente("Matheus");
  var dep2 = Dependente("Lucas");
  var dep3 = Dependente("Sérgio");
  var dep4 = Dependente("Jardel");

  var func1 = Funcionario("Patrícia", [dep1, dep2]);
  var func2 = Funcionario("Ana", [dep3]);
  var func3 = Funcionario("Eduardo", [dep4]);

  var listaFuncionarios = [func1, func2, func3];

  var equipe = EquipeProjeto("Projeto Dart", listaFuncionarios);

  var encoder = JsonEncoder.withIndent('  ');
  print(encoder.convert(equipe.toJson()));

}
