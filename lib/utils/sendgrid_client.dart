import 'dart:developer';

import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:slibro/secrets.dart';

class SendGridClient {
  sendEmail2({
    required String fileContent,
    required String fileName,
    required String toEmail,
  }) {
    final mailer = Mailer(Secrets.sendGridApiKey);
    final toAddress = Address(toEmail);
    final fromAddress = Address('sbis1999@gmail.com');
    final content = Content(
      'text/plain',
      'Thank you for the purchase! Find the invoice in the attachment.\n\nOrder ID: $fileName\n\nSlibro',
    );
    final subject = 'Slibro Order Confirmation (ID: $fileName)';
    final personalization = Personalization([toAddress]);
    final attachment = Attachment(fileContent, '$fileName.pdf');

    final email = Email(
      [personalization],
      fromAddress,
      subject,
      content: [content],
      attachments: [attachment],
    );

    mailer.send(email).then((result) {
      if (result.isValue) {
        log('Email successfully sent!');
      } else {
        log('Failed to send email.');
      }
    });
  }
}
