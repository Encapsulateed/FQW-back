using System;
using System.Collections.Generic;

namespace geo_back.Model;

public partial class Reports
{
    public Guid Id { get; set; }

    public Guid ProfileId { get; set; }

    public string ReportType { get; set; } = null!;

    public string FilePath { get; set; } = null!;

    public Guid UserId { get; set; }

    public DateTime GeneratedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual TerrainProfiles Profile { get; set; } = null!;

    public virtual Users User { get; set; } = null!;
}
