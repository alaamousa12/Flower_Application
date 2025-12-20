using FlowerShopAPI.Data;
using FlowerShopAPI.Dtos;
using FlowerShopAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FlowerShopAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrdersController : ControllerBase
    {
        private readonly FlowerShopDbContext _context;

        public OrdersController(FlowerShopDbContext context)
        {
            _context = context;
        }

        // ✅ Helper: إنشاء Notification
        private async Task AddNotificationAsync(int userId, string title, string message)
        {
            var n = new Notification
            {
                UserId = userId,
                Title = title,
                Message = message,
                IsRead = false,
                CreatedAt = DateTime.UtcNow
            };

            _context.Notifications.Add(n);
            await _context.SaveChangesAsync();
        }

        // ✅ 1) Create Order + Notification
        [HttpPost]
        public async Task<IActionResult> CreateOrder([FromBody] CreateOrderDto dto)
        {
            decimal totalAmount = 0;

            foreach (var item in dto.Items)
            {
                var product = await _context.Products.FindAsync(item.ProductId);
                if (product != null)
                    totalAmount += product.Price * item.Quantity;
            }

            var order = new Order
            {
                UserId = dto.UserId,
                OrderDate = DateTime.UtcNow,
                Status = "Pending",
                TotalAmount = totalAmount,
                AddressId = dto.AddressId,
                PaymentMethod = dto.PaymentMethod
            };

            _context.Orders.Add(order);
            await _context.SaveChangesAsync();

            foreach (var itemDto in dto.Items)
            {
                var orderItem = new OrderItem
                {
                    OrderId = order.OrderId,
                    ProductId = itemDto.ProductId,
                    Quantity = itemDto.Quantity,
                    Price = _context.Products.Find(itemDto.ProductId)?.Price ?? 0
                };
                _context.OrderItems.Add(orderItem);
            }

            await _context.SaveChangesAsync();

            // ✅ Notification
            await AddNotificationAsync(
                dto.UserId,
                "Order Created ✅",
                $"Your order #{order.OrderId} has been created successfully."
            );

            return Ok(new { Message = "Order created successfully", OrderId = order.OrderId });
        }

        // ✅ 2) Get Orders
        [HttpGet("user/{userId}")]
        public async Task<ActionResult<IEnumerable<object>>> GetUserOrders(int userId)
        {
            var orders = await _context.Orders
                .Where(o => o.UserId == userId)
                .Include(o => o.OrderItems)
                .ThenInclude(oi => oi.Product)
                .OrderByDescending(o => o.OrderDate)
                .Select(o => new
                {
                    Id = o.OrderId,
                    o.TotalAmount,
                    o.Status,
                    o.OrderDate,
                    o.PaymentMethod,
                    ItemsCount = o.OrderItems.Count
                })
                .ToListAsync();

            return Ok(orders);
        }

        // ✅ 3) Update Order Status + Notification
        // PUT: api/Orders/5/status
        [HttpPut("{orderId}/status")]
        public async Task<IActionResult> UpdateOrderStatus(int orderId, [FromBody] UpdateOrderStatusDto dto)
        {
            var order = await _context.Orders.FirstOrDefaultAsync(o => o.OrderId == orderId);
            if (order == null) return NotFound("Order not found");

            order.Status = dto.Status;
            await _context.SaveChangesAsync();

            await AddNotificationAsync(
                order.UserId,
                "Order Status Updated 📦",
                $"Your order #{order.OrderId} status is now: {order.Status}"
            );

            return Ok(new { message = "Status updated successfully" });
        }

        // ✅ Admin: Get all orders
        [HttpGet]
        public async Task<ActionResult<IEnumerable<object>>> GetAllOrders()
        {
            var orders = await _context.Orders
                .Include(o => o.OrderItems)
                .ThenInclude(oi => oi.Product)
                .OrderByDescending(o => o.OrderDate)
                .Select(o => new
                {
                    Id = o.OrderId,
                    o.UserId,
                    o.TotalAmount,
                    o.Status,
                    o.OrderDate,
                    o.PaymentMethod,
                    ItemsCount = o.OrderItems.Count
                })
                .ToListAsync();

            return Ok(orders);
        }


    }

    public class UpdateOrderStatusDto
    {
        public string Status { get; set; } = "Pending";
    }
}






// try the following code:

//{
//    "userId": 1,
//  "addressId": null,
//  "paymentMethod": "Visa",
//  "items": [
//    {
//        "productId": 1,
//      "quantity": 2
//    },
//    {
//        "productId": 2,
//      "quantity": 1
//    }
//  ]
//}