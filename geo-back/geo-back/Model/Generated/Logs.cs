using System;
using System.Collections.Generic;

namespace geo_back.Model;

public partial class Logs
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public string Action { get; set; } = null!;

    public DateTime Timestamp { get; set; }

    public string? Metadata { get; set; }

    public DateTime? UpdatedAt { get; set; }
}
