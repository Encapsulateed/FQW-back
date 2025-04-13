using System;
using System.Collections.Generic;

namespace geo_back.Model;

public partial class Users
{
    public Guid Id { get; set; }

    public string Email { get; set; } = null!;

    public string PasswordHash { get; set; } = null!;

    public string Role { get; set; } = null!;

    public DateTime? CreatedAt { get; set; }

    public DateTime? UpdatedAt { get; set; }

    public virtual ICollection<ProfileEdits> ProfileEdits { get; set; } = new List<ProfileEdits>();

    public virtual ICollection<Reports> Reports { get; set; } = new List<Reports>();

    public virtual ICollection<TerrainProfiles> TerrainProfiles { get; set; } = new List<TerrainProfiles>();
}
