using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FlowerShopAPI.Models
{
    public class Product
    {
        [Key]
        [Column("product_id")]
        public int ProductId { get; set; }

        [Required]
        [MaxLength(200)]
        public string Name { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal Price { get; set; }

        public string MainImageUrl { get; set; }

        public string Description { get; set; }

        public int Quantity { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // FKs
        [ForeignKey("Category")]
        public int CategoryId { get; set; }

        [System.Text.Json.Serialization.JsonIgnore]
        public Category? Category { get; set; }

        [ForeignKey("Seller")]
        public int SellerId { get; set; }

        [System.Text.Json.Serialization.JsonIgnore]
        public Seller? Seller { get; set; }

        public bool IsSpecialOffer { get; set; } = false;

        [Column(TypeName = "decimal(5,2)")]
        public decimal DiscountPercent { get; set; } = 0; // مثال: 10 = 10%


        // Navigation
        public ICollection<ProductImage> ProductImages { get; set; } = new List<ProductImage>();
        public ICollection<Review> Reviews { get; set; } = new List<Review>();
        public ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
        public ICollection<Favorite> Favorites { get; set; } = new List<Favorite>();
    }
}

