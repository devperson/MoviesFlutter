/// Represents the orientation a device display can have.
enum DisplayOrientation
{
    /// Unknown display orientation.
    Unknown(0),

    /// Device display is in portrait orientation.
    Portrait(1),

    /// Device display is in landscape orientation.
    Landscape(2);

    final int value;
    const DisplayOrientation(this.value);
}
