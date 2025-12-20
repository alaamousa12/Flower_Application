using Microsoft.AspNetCore.Http;
using System.ComponentModel.DataAnnotations;

namespace FlowerShopAPI.Dtos
{
    public class UpdateUserDto
    {
        // هذه الحقول اختيارية وليست إجبارية (شلنا [Required])
        public string? Name { get; set; }
        public string? PhoneNumber { get; set; }
        public string? Gender { get; set; }
        public string? Country { get; set; }

        // الباسورد اختياري هنا، لو اتبعت هيتغير، لو ماتبعتش هيفضل القديم
        public string? Password { get; set; }

        public IFormFile? ImageFile { get; set; }
    }
}