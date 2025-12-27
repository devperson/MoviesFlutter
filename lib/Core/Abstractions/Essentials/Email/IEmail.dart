import 'EmailMessage.dart';

/// Provides an easy way to allow the user to send emails.
abstract interface class IEmail
{
    /// Gets a value indicating whether composing an email is supported on this device.
    bool get IsComposeSupported;

    /// Opens the default email client to allow the user to send the message.
    /// [message] Instance of EmailMessage containing details of the email message to compose.
    Future<void> Compose(EmailMessage message);
}
