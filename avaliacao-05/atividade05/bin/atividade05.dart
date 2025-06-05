import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main() async {
  // === Configurações ===
  String username = ''; // Seu e-mail
  String password = '';        // Senha de app

  // Perguntar o assunto
  stdout.write('Digite o ASSUNTO do e-mail: ');
  String? assunto = stdin.readLineSync();

  // Perguntar a mensagem
  stdout.write('Digite a MENSAGEM do e-mail: ');
  String? mensagem = stdin.readLineSync();

  // Perguntar destinatário
  stdout.write('Digite o DESTINATÁRIO do e-mail: ');
  String? destinatario = stdin.readLineSync();

  if (assunto == null || mensagem == null || destinatario == null) {
    print('❌ Dados inválidos. Tente novamente.');
    return;
  }

  // Configurar servidor SMTP
  final smtpServer = gmail(username, password);

  // Criar a mensagem
  final message = Message()
    ..from = Address(username, 'Anderson')
    ..recipients.add(destinatario)
    ..subject = assunto
    ..text = mensagem;

  try {
    final sendReport = await send(message, smtpServer);
    print('✅ E-mail enviado com sucesso: $sendReport');
  } on MailerException catch (e) {
    print('❌ Falha ao enviar e-mail.');
    for (var p in e.problems) {
      print('Problema: ${p.code}: ${p.msg}');
    }
  }
}

