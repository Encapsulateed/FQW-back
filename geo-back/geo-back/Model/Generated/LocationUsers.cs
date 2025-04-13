using System;
using System.Collections.Generic;

namespace geo_back.Model;

public partial class LocationUsers
{
    public Guid LocationId { get; set; }

    public Guid UserId { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }
}
