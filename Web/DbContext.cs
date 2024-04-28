using Microsoft.EntityFrameworkCore;

public class DbContext(IConfiguration configuration) : Microsoft.EntityFrameworkCore.DbContext
{
    public DbSet<Advertisement> Advertisements { get; set; }
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        base.OnConfiguring(optionsBuilder);
        optionsBuilder.UseCosmos(configuration.GetValue<string>("COSMOS_ENDPOINT")!, configuration.GetValue<string>("COSMOS_KEY")!, "assistantdb");
    }

    protected override void OnModelCreating(ModelBuilder builder)
    {
        builder.Entity<Advertisement>().ToContainer("Advertisements");
    }

}