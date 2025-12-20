using FlowerShopAPI.Data;
using FlowerShopAPI.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FlowerShopAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotificationsController : ControllerBase
    {
        private readonly FlowerShopDbContext _context;

        public NotificationsController(FlowerShopDbContext context)
        {
            _context = context;
        }

        // 1. عرض إشعارات المستخدم (مرتبة من الأحدث للأقدم)
        // GET: api/Notifications/user/1
        [HttpGet("user/{userId}")]
        public async Task<ActionResult<IEnumerable<Notification>>> GetUserNotifications(int userId)
        {
            return await _context.Notifications
                .Where(n => n.UserId == userId)
                .OrderByDescending(n => n.CreatedAt) // الأحدث يظهر فوق
                .ToListAsync();
        }

        // 2. معرفة عدد الإشعارات غير المقروءة (عشان النقطة الحمراء 🔴 فوق الجرس)
        // GET: api/Notifications/user/1/unread-count
        [HttpGet("user/{userId}/unread-count")]
        public async Task<ActionResult<int>> GetUnreadCount(int userId)
        {
            var count = await _context.Notifications
                .Where(n => n.UserId == userId && !n.IsRead)
                .CountAsync();

            return Ok(count);
        }

        // 3. تعليم إشعار بأنه "تمت قراءته"
        // PUT: api/Notifications/5/mark-read
        [HttpPut("{id}/mark-read")]
        public async Task<IActionResult> MarkAsRead(int id)
        {
            var notification = await _context.Notifications.FindAsync(id);
            if (notification == null) return NotFound();

            notification.IsRead = true;
            await _context.SaveChangesAsync();

            return Ok(new { message = "Marked as read" });
        }

        // 4. إنشاء إشعار جديد (للتجربة أو لو الأدمن بيبعت)
        // POST: api/Notifications
        [HttpPost]
        public async Task<ActionResult<Notification>> SendNotification(NotificationDto request)
        {
            var user = await _context.Users.FindAsync(request.UserId);
            if (user == null) return BadRequest("User not found");

            var notification = new Notification
            {
                UserId = request.UserId,
                Title = request.Title,
                Message = request.Message,
                CreatedAt = DateTime.UtcNow,
                IsRead = false
            };

            _context.Notifications.Add(notification);
            await _context.SaveChangesAsync();

            return Ok(notification);
        }
    }

    // DTO
    public class NotificationDto
    {
        public int UserId { get; set; }
        public string Title { get; set; }
        public string Message { get; set; }
    }
}


// try 


//{
//    "userId": 1,
//  "title": "Order Update",
//  "message": "Your order #5 is out for delivery! 🚚"
//}