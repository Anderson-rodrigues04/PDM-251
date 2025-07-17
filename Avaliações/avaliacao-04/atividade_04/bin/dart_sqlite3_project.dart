import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() {
  final db = sqlite3.open('alunos.db');

  // Criação da tabela TB_ALUNO se não existir
  db.execute('''
    CREATE TABLE IF NOT EXISTS TB_ALUNO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL
    );
  ''');

  while (true) {
    print('\nSelecione uma opção:');
    print('1 - Inserir novo aluno');
    print('2 - Listar alunos');
    print('3 - Atualizar aluno');
    print('4 - Excluir aluno');
    print('5 - Sair');

    String? opcao = stdin.readLineSync();

    if (opcao == '1') {
      inserirAluno(db);
    } else if (opcao == '2') {
      listarAlunos(db);
    } else if (opcao == '3') {
      atualizarAluno(db);
    } else if (opcao == '4') {
      excluirAluno(db);
    } else if (opcao == '5') {
      print('Saindo...');
      db.dispose();
      break;
    } else {
      print('Opção inválida. Tente novamente.');
    }
  }
}

void inserirAluno(Database db) {
  stdout.write('Digite o nome do aluno (máx. 50 caracteres): ');
  String? nome = stdin.readLineSync();

  if (nome != null && nome.isNotEmpty) {
    if (nome.length > 50) {
      print('Erro: O nome não pode ter mais que 50 caracteres.');
      return;
    }
    final stmt = db.prepare('INSERT INTO TB_ALUNO (nome) VALUES (?);');
    stmt.execute([nome]);
    stmt.dispose();

    print('Aluno "$nome" inserido com sucesso!');
  } else {
    print('Nome inválido. Operação cancelada.');
  }
}

void listarAlunos(Database db) {
  final ResultSet result = db.select('SELECT * FROM TB_ALUNO;');

  if (result.isEmpty) {
    print('Nenhum aluno cadastrado.');
  } else {
    print('\n--- Lista de Alunos ---');
    for (final row in result) {
      print('ID: ${row['id']}, Nome: ${row['nome']}');
    }
  }
}

void atualizarAluno(Database db) {
  listarAlunos(db);

  stdout.write('Digite o ID do aluno que deseja atualizar: ');
  String? idInput = stdin.readLineSync();
  int? id = int.tryParse(idInput ?? '');

  if (id != null) {
    stdout.write('Digite o novo nome (máx. 50 caracteres): ');
    String? novoNome = stdin.readLineSync();

    if (novoNome != null && novoNome.isNotEmpty) {
      if (novoNome.length > 50) {
        print('Erro: O nome não pode ter mais que 50 caracteres.');
        return;
      }

      final stmt = db.prepare('UPDATE TB_ALUNO SET nome = ? WHERE id = ?;');
      stmt.execute([novoNome, id]);
      stmt.dispose();

      print('Aluno ID $id atualizado para "$novoNome".');
    } else {
      print('Nome inválido. Operação cancelada.');
    }
  } else {
    print('ID inválido. Operação cancelada.');
  }
}

void excluirAluno(Database db) {
  listarAlunos(db);

  stdout.write('Digite o ID do aluno que deseja excluir: ');
  String? idInput = stdin.readLineSync();
  int? id = int.tryParse(idInput ?? '');

  if (id != null) {
    final stmt = db.prepare('DELETE FROM TB_ALUNO WHERE id = ?;');
    stmt.execute([id]);
    stmt.dispose();

    print('Aluno ID $id excluído com sucesso.');
  } else {
    print('ID inválido. Operação cancelada.');
  }
}
