/// Represents a email file attachment.
class EmailAttachment
{
    String FullPath;
    String ContentType;

    /// Initializes a new instance of the EmailAttachment class based off the file specified in the provided path
    /// and providing an explicit MIME filetype.
    /// [fullPath] Full path and filename to file on filesystem.
    /// [contentType] Content type (MIME type) of the file (e.g.: image/png).
    EmailAttachment(this.FullPath, this.ContentType);
}
