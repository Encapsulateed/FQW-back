using System;
using System.Collections.Generic;
using NetTopologySuite.Geometries;

namespace geo_back.Model;

public partial class Locations
{
    public Guid Id { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public Polygon Geometry { get; set; } = null!;

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual ICollection<Isolines> Isolines { get; set; } = new List<Isolines>();

    public virtual ICollection<TerrainProfiles> TerrainProfiles { get; set; } = new List<TerrainProfiles>();
}
