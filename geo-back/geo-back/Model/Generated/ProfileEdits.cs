using System;
using System.Collections.Generic;

namespace geo_back.Model;

public partial class ProfileEdits
{
    public Guid Id { get; set; }

    public Guid ProfileId { get; set; }

    public Guid UserId { get; set; }

    public string EditType { get; set; } = null!;

    public string? ChangeDescription { get; set; }

    public DateTime Timestamp { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual TerrainProfiles Profile { get; set; } = null!;

    public virtual Users User { get; set; } = null!;
}
