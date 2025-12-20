using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FlowerShopAPI.Models
{
    // Models/Review.cs
    [Table("Reviews")]
    public class Review
    {
        [Key]
        [Column("review_id")]
        public int ReviewId { get; set; }

        [ForeignKey("User")]
        [Column("fk_user_id")]
        public int UserId { get; set; }
        public User User { get; set; }

        [ForeignKey("Product")]
        [Column("fk_product_id")]
        public int ProductId { get; set; }
        public Product Product { get; set; }

        public int Rating { get; set; } // 1..5

        public string Comment { get; set; }

        public DateTime ReviewDate { get; set; } = DateTime.UtcNow;
    }

}
