import 'EmailAttachment.dart';
import 'EmailBodyFormat.dart';

/// Represents a single email message.
class EmailMessage
{
    /// Initializes a new instance of the EmailMessage class.
    EmailMessage({this.Subject, this.Body, List<String>? To, this.BodyFormat = EmailBodyFormat.PlainText})
    {
         if(To != null) {
             this.To.addAll(To);
         }
    }

    /// Gets or sets the email's subject.
    String? Subject;

    /// Gets or sets the email's body.
    String? Body;

    /// Gets or sets a value indicating whether the message is in plain text or HTML.
    /// Remarks: EmailBodyFormat.Html is not supported on Windows.
    EmailBodyFormat BodyFormat;

    /// Gets or sets the email's recipients.
    List<String> To = [];

    /// Gets or sets the email's CC (Carbon Copy) recipients.
    List<String> Cc = [];

    /// Gets or sets the email's BCC (Blind Carbon Copy) recipients.
    List<String> Bcc = [];

    /// Gets or sets a list of file attachments as EmailAttachment objects.
    List<EmailAttachment> Attachments = [];
}
