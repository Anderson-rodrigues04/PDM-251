import 'dart:io';
import 'dart:async';
import 'dart:isolate';

void main() async {
  String meuNome = "Anderson";
  print (meuNome);

  final receivePort = ReceivePort();
  await Isolate.spawn(doAsyncOperation, [receivePort.sendPort, meuNome]);

  print('Iniciando outras tarefas...');
  await Future.delayed(Duration(seconds: 1));
  print('Continuando outras tarefas...');

  final result = await receivePort.first;
  print('Resultado: $result');
}

void doAsyncOperation(List<dynamic> message) {
  SendPort sendPort = message[0];
  String nomeRecebido = message[1];

  print('Nome recebido do isolate: $nomeRecebido');

  Future.delayed(Duration(seconds: 2), (){
    sendPort.send('Operação concluida com sucesso para $nomeRecebido');
  });
}