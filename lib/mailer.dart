import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io';

Future<String?> sendMail(String path) async {
  String username = 'username@gmail.com';
  String password = 'password';

  final smtpServer = SmtpServer(
    "smtp-relay.sendinblue.com",
    port: 587,
    username: "support@digisailor.com",
    password: "OWdy7JkbFYCnR4LI",
    allowInsecure: true,
    ssl: false,
  );

  final MyMessage = Message()
    ..from = const Address("support@digisailor.com", 'Digisailor Support')
    ..recipients.add(const Address('rampowiz@gmail.com'))
    ..ccRecipients.addAll([
      Address('gmjeyaindustris@gmail.com'),
      Address('rajeshsankaravadivell@gmail.com'),
      Address('salesjeyaindustries@gmail.com'),
      Address('purchasejeyaindustries@gmail.com'),
      Address('designjeyaindustries@gmail.com'),
      Address('storesjeyaindustries@gmail.com'),
      Address('hrjeyaindustries@gmail.com'),
      Address('gmjeyaindustries@gmail.com'),
      Address('jeyaiepl@gmail.com')
    ])
    ..bccRecipients.add('rampowiz@gmail.com')
    ..subject =
        'PendingJobs ${DateTime.now().toIso8601String().substring(0, 10)}'
    // ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..attachments = [
      FileAttachment(File(path))
        ..location = Location.inline
        ..cid = '<myimg@3.141>'
    ];

  try {
    final sendReport = await send(MyMessage, smtpServer);
    print('Message sent: ' + sendReport.toString());
    return sendReport.toString();
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
      return p.msg;
    }
  }
}
