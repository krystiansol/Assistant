using System.Collections.Immutable;

using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;

namespace Web.Pages;

public class AdvertisementsModel(DbContext dbContext) : PageModel
{
    public ImmutableList<AdModel>? AdvertisementsCollection { get; set; }

    public record AdModel(Guid Id, string Source);

    public async Task OnGet()
    {
        AdvertisementsCollection = [.. await dbContext.Advertisements.Select(x => new AdModel(x.Id, x.Source)).ToListAsync()];
    }
}
