using System;
using System.Collections.Generic;
using NetTopologySuite.Geometries;

namespace geo_back.Model;

public partial class Isolines
{
    public Guid Id { get; set; }

    public Guid LocationId { get; set; }

    public double Elevation { get; set; }

    public LineString Geometry { get; set; } = null!;

    public string? Source { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual Locations Location { get; set; } = null!;
}
