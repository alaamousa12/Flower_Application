using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using FlowerShopAPI.Data;
using FlowerShopAPI.Models;
using FlowerShopAPI.Dtos;

namespace FlowerShopAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaymentMethodsController : ControllerBase
    {
        private readonly FlowerShopDbContext _context;

        public PaymentMethodsController(FlowerShopDbContext context)
        {
            _context = context;
        }


        // 1. إضافة بطاقة جديدة
        [HttpPost]
        public async Task<IActionResult> AddCard([FromBody] PaymentMethodDto dto)
        {
            // 👇👇 التعديل هنا: غيرنا u.Id لـ u.UserId (أو استخدم FindAsync أضمن) 👇👇
            var user = await _context.Users.FindAsync(dto.UserId);

            if (user == null) return BadRequest("User not found");

            var card = new PaymentMethod
            {
                UserId = dto.UserId,
                Name = dto.Name,
                CardNumber = dto.CardNumber,
                ExpiryDate = dto.ExpiryDate
            };

            _context.PaymentMethods.Add(card);
            await _context.SaveChangesAsync();
            return Ok(card);
        }



        // 2. جلب بطاقات المستخدم
        // GET: api/PaymentMethods/user/5
        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetUserCards(int userId)
        {
            var cards = await _context.PaymentMethods // 👈 وهنا كمان
                .Where(c => c.UserId == userId)
                .ToListAsync();
            return Ok(cards);
        }

        // 3. حذف بطاقة
        // DELETE: api/PaymentMethods/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCard(int id)
        {
            var card = await _context.PaymentMethods.FindAsync(id); // 👈 وهنا
            if (card == null) return NotFound();

            _context.PaymentMethods.Remove(card);
            await _context.SaveChangesAsync();
            return Ok("Deleted successfully");
        }
    }
}