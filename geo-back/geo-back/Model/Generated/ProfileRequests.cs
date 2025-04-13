using System;
using System.Collections.Generic;

namespace geo_back.Model;

public partial class ProfileRequests
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public Guid LocationId { get; set; }

    public double SamplingInterval { get; set; }

    public string ProfileMode { get; set; } = null!;

    public string Status { get; set; } = null!;

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public DateTime? CompletedAt { get; set; }
}
