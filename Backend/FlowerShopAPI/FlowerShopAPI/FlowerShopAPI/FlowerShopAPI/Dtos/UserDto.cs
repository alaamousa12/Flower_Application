using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Http;

namespace FlowerShopAPI.Dtos
{
    public class UserDto
    {
        [Required]
        public string Name { get; set; }

        [Required]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        public string PhoneNumber { get; set; }

        // 👇👇 شروط الباسورد في الباك إند 👇👇
        [Required]
        [MinLength(8, ErrorMessage = "Password must be at least 8 characters")]
        [RegularExpression(@"^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?""{}|<>]).*$",
         ErrorMessage = "Password must contain uppercase & special char")]
        public string Password { get; set; }

        public string Gender { get; set; }
        public string Country { get; set; }
        public IFormFile? ImageFile { get; set; }
        public string? ProfileImage { get; set; }
    }
}