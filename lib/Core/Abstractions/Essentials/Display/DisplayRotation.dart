/// Represents the rotation a device display can have.
enum DisplayRotation
{
    /// Unknown display rotation.
    Unknown(0),

    /// The device display is rotated 0 degrees.
    Rotation0(1),

    /// The device display is rotated 90 degrees.
    Rotation90(2),

    /// The device display is rotated 180 degrees.
    Rotation180(3),

    /// The device display is rotated 270 degrees.
    Rotation270(4);

    final int value;
    const DisplayRotation(this.value);
}
