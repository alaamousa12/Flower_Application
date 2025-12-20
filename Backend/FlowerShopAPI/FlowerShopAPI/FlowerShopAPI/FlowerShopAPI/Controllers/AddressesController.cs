using FlowerShopAPI.Data;
using FlowerShopAPI.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FlowerShopAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AddressesController : ControllerBase
    {
        private readonly FlowerShopDbContext _context;

        public AddressesController(FlowerShopDbContext context)
        {
            _context = context;
        }

        // 1. إضافة عنوان جديد
        // POST: api/Addresses
        [HttpPost]
        public async Task<ActionResult<Address>> AddAddress(AddressDto request)
        {
            var user = await _context.Users.FindAsync(request.UserId);
            if (user == null) return BadRequest("User not found");

            var address = new Address
            {
                UserId = request.UserId,
                City = request.City,
                Street = request.Street,
                PostalCode = request.PostalCode
            };

            _context.Addresses.Add(address);
            await _context.SaveChangesAsync();

            return Ok(address);
        }

        // 2. عرض عناوين مستخدم معين
        // GET: api/Addresses/user/1
        [HttpGet("user/{userId}")]
        public async Task<ActionResult<IEnumerable<Address>>> GetUserAddresses(int userId)
        {
            return await _context.Addresses
                .Where(a => a.UserId == userId)
                .ToListAsync();
        }

        // 3. حذف عنوان
        // DELETE: api/Addresses/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAddress(int id)
        {
            var address = await _context.Addresses.FindAsync(id);
            if (address == null)
            {
                return NotFound();
            }

            _context.Addresses.Remove(address);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }

    // DTO لاستقبال البيانات بشكل نظيف
    public class AddressDto
    {
        public int UserId { get; set; }
        public string City { get; set; }
        public string Street { get; set; }
        public string PostalCode { get; set; }
    }
}



// try :

//{
//    "userId": 1,
//  "city": "Cairo",
//  "street": "10 Tahrir St",
//  "postalCode": "112233"
//}