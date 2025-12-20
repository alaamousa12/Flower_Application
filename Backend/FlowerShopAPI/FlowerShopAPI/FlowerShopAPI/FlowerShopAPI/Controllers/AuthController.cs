using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using FlowerShopAPI.Data;
using FlowerShopAPI.Models;
using FlowerShopAPI.Dtos;

namespace FlowerShopAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly FlowerShopDbContext _context;
        private readonly IWebHostEnvironment _env;

        public AuthController(FlowerShopDbContext context, IWebHostEnvironment env)
        {
            _context = context;
            _env = env;
        }

        // 1) Register
        [HttpPost("register")]
        public async Task<IActionResult> Register([FromForm] UserDto dto)
        {
            if (await _context.Users.AnyAsync(u => u.Email == dto.Email))
                return BadRequest("Email already exists");

            string? fullImageUrl = null;

            if (dto.ImageFile != null && dto.ImageFile.Length > 0)
            {
                var uploadsFolder = Path.Combine(_env.WebRootPath, "images");
                if (!Directory.Exists(uploadsFolder))
                    Directory.CreateDirectory(uploadsFolder);

                var uniqueFileName = Guid.NewGuid() + "_" + dto.ImageFile.FileName;
                var filePath = Path.Combine(uploadsFolder, uniqueFileName);

                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    await dto.ImageFile.CopyToAsync(fileStream);
                }

                fullImageUrl = $"http://10.0.2.2:5104/images/{uniqueFileName}";
            }

            var user = new User
            {
                Name = dto.Name,
                Email = dto.Email,
                Password = dto.Password,
                PhoneNumber = dto.PhoneNumber,
                Gender = dto.Gender,
                Country = dto.Country,
                ProfileImage = fullImageUrl,
                CreatedAt = DateTime.UtcNow
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            // ✅ Notification after register
            _context.Notifications.Add(new Notification
            {
                UserId = user.UserId,
                Title = "Welcome 🎉",
                Message = $"Welcome {user.Name}! Your account has been created successfully.",
                IsRead = false,
                CreatedAt = DateTime.UtcNow
            });

            await _context.SaveChangesAsync();

            return Ok(user);
        }

        // 2) Login
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto dto)
        {
            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.Email == dto.Email && u.Password == dto.Password);

            if (user == null) return Unauthorized("Invalid Email or Password");

            // ✅ Notification after login
            _context.Notifications.Add(new Notification
            {
                UserId = user.UserId,
                Title = "Login Successful",
                Message = "You have logged in successfully ✅",
                IsRead = false,
                CreatedAt = DateTime.UtcNow
            });

            await _context.SaveChangesAsync();

            return Ok(user);
        }

        // 3) Update Profile
        [HttpPut("update/{id}")]
        public async Task<IActionResult> UpdateUser(int id, [FromForm] UpdateUserDto dto)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return NotFound("User not found");

            if (!string.IsNullOrEmpty(dto.Name)) user.Name = dto.Name;
            if (!string.IsNullOrEmpty(dto.PhoneNumber)) user.PhoneNumber = dto.PhoneNumber;
            if (!string.IsNullOrEmpty(dto.Gender)) user.Gender = dto.Gender;
            if (!string.IsNullOrEmpty(dto.Country)) user.Country = dto.Country;

            if (!string.IsNullOrEmpty(dto.Password))
                user.Password = dto.Password;

            if (dto.ImageFile != null && dto.ImageFile.Length > 0)
            {
                var uploadsFolder = Path.Combine(_env.WebRootPath, "images");
                if (!Directory.Exists(uploadsFolder)) Directory.CreateDirectory(uploadsFolder);

                var uniqueFileName = Guid.NewGuid() + "_" + dto.ImageFile.FileName;
                var filePath = Path.Combine(uploadsFolder, uniqueFileName);

                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    await dto.ImageFile.CopyToAsync(fileStream);
                }

                user.ProfileImage = $"http://10.0.2.2:5104/images/{uniqueFileName}";
            }

            _context.Users.Update(user);
            await _context.SaveChangesAsync();

            return Ok(user);
        }

        // 4) Reset Password
        [HttpPost("reset-password")]
        public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordDto dto)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == dto.Email);
            if (user == null) return NotFound("Email not found");

            user.Password = dto.NewPassword;
            _context.Users.Update(user);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Password updated successfully" });
        }
    }
}




//        [HttpGet("search/{name}")]
//        public async Task<ActionResult<IEnumerable<Product>>> SearchProducts(string name)
//        {
//            var products = await _context.Products
//                .Where(p => p.Name.Contains(name))
//                .Include(p => p.Category)
//                .Include(p => p.Seller)
//                .Include(p => p.ProductImages)
//                .ToListAsync();
//            return products;
//        }
//    }
//}


// try this JSON to register a new user

//{
//    "name": "New Customer",
//  "email": "customer@test.com",
//  "password": "123",
//  "phoneNumber": "0123456789",
//  "gender": "Male",
//  "country": "Egypt"
//}


// try this JSON to login

//{
//    "email": "customer@test.com",
//  "password": "123"
//}