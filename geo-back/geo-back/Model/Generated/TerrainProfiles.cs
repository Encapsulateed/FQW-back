using System;
using System.Collections.Generic;
using NetTopologySuite.Geometries;

namespace geo_back.Model;

public partial class TerrainProfiles
{
    public Guid Id { get; set; }

    public Guid LocationId { get; set; }

    public Guid CreatedBy { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public LineString Geometry { get; set; } = null!;

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Users CreatedByNavigation { get; set; } = null!;

    public virtual Locations Location { get; set; } = null!;

    public virtual ICollection<ProfileEdits> ProfileEdits { get; set; } = new List<ProfileEdits>();

    public virtual ICollection<Reports> Reports { get; set; } = new List<Reports>();
}
