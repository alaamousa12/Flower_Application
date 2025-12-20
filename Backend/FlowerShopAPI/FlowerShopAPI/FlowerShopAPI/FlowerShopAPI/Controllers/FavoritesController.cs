using FlowerShopAPI.Data;
using FlowerShopAPI.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FlowerShopAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FavoritesController : ControllerBase
    {
        private readonly FlowerShopDbContext _context;

        public FavoritesController(FlowerShopDbContext context)
        {
            _context = context;
        }

        // 1. إضافة منتج للمفضلة
        // POST: api/Favorites
        [HttpPost]
        public async Task<ActionResult> AddFavorite(FavoriteDto request)
        {
            // نتأكد إنه مش متضاف قبل كده عشان ميعملش Error
            var existingFav = await _context.Favorites
                .FirstOrDefaultAsync(f => f.UserId == request.UserId && f.ProductId == request.ProductId);

            if (existingFav != null)
            {
                return BadRequest("This item is already in favorites.");
            }

            var favorite = new Favorite
            {
                UserId = request.UserId,
                ProductId = request.ProductId
            };

            _context.Favorites.Add(favorite);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Added to favorites!" });
        }

        // 2. عرض مفضلة المستخدم
        // GET: api/Favorites/user/1
        [HttpGet("user/{userId}")]
        public async Task<ActionResult<IEnumerable<Product>>> GetUserFavorites(int userId)
        {
            // هنا بنرجع "المنتجات" نفسها اللي جوه المفضلة
            var favoriteProducts = await _context.Favorites
                .Where(f => f.UserId == userId)
                .Include(f => f.Product) // هات تفاصيل المنتج
                .Select(f => f.Product)  // اختار المنتج بس
                .ToListAsync();

            return Ok(favoriteProducts);
        }

        // 3. حذف من المفضلة
        // DELETE: api/Favorites/user/1/product/5
        [HttpDelete("user/{userId}/product/{productId}")]
        public async Task<IActionResult> RemoveFavorite(int userId, int productId)
        {
            var favorite = await _context.Favorites
                .FirstOrDefaultAsync(f => f.UserId == userId && f.ProductId == productId);

            if (favorite == null)
            {
                return NotFound("Favorite not found.");
            }

            _context.Favorites.Remove(favorite);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Removed from favorites." });
        }
    }

    // DTO
    public class FavoriteDto
    {
        public int UserId { get; set; }
        public int ProductId { get; set; }
    }

}


// test post :

//{
//    "userId": 1,
//  "productId": 2
//}