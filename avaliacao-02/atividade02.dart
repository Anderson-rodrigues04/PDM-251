import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    _nome = nome;
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
    _nome = nome;
    _dependentes = dependentes;
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
  var dep1 = Dependente('Claudio');
  var dep2 = Dependente('Maria');
  var dep3 = Dependente('Levi');
  var dep4 = Dependente('Joana');
  var dep5 = Dependente('Sofia');

  var func1 = Funcionario('Cesar Sousa', [dep1, dep2]);
  var func2 = Funcionario('Fernanda Sousa', [dep3]);
  var func3 = Funcionario('João Lucas', [dep4, dep5]);

  var listaFuncionarios = [func1, func2, func3];

  var equipe = EquipeProjeto('Projeto Alpha', listaFuncionarios);

  var encoder = JsonEncoder.withIndent('  ');
  print(encoder.convert(equipe.toJson()));
}