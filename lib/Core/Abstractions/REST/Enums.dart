enum RestMethod
{
    GET,
    POST,
    PUT,
    DELETE
}

enum Priority
{
    HIGH(0),
    NORMAL(1),
    LOW(2),
    NONE(3);

    final int value;
    const Priority(this.value);
}

enum TimeoutType
{
    Small(10),
    Medium(30),
    High(60),
    VeryHigh(120);

    final int value;
    const TimeoutType(this.value);
}

enum HttpStatusCode
{
    Unauthorized(401),
    ServiceUnavailable(502);

    final int value;
    const HttpStatusCode(this.value);
}
