using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FlowerShopAPI.Models
{
    public class Seller
    {
        [Key]
        [Column("seller_id")]
        public int SellerId { get; set; }

        [Required]
        [MaxLength(150)]
        public string Name { get; set; }

        public string ContactInfo { get; set; }

        public int UserId { get; set; }
        public User User { get; set; }


        // Navigation
        public ICollection<Product> Products { get; set; } = new List<Product>();
    }
}
