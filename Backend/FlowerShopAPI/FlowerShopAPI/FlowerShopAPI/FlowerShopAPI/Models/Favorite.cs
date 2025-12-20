using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FlowerShopAPI.Models
{
    // Models/Favorite.cs
    [Table("Favorites")]
    public class Favorite
    {
        [Key]
        public int FavoriteId { get; set; } // add PK for EF convenience (can be composite but simpler this way)

        [ForeignKey("User")]
        [Column("fk_user_id")]
        public int UserId { get; set; }
        public User User { get; set; }

        [ForeignKey("Product")]
        [Column("fk_product_id")]
        public int ProductId { get; set; }
        public Product Product { get; set; }
    }

}
