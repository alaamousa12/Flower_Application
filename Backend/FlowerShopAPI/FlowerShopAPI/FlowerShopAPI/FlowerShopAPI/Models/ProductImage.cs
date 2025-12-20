using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FlowerShopAPI.Models
{
    [Table("Product_Images")]
    public class ProductImage
    {
        [Key]
        [Column("img_id")]
        public int ImgId { get; set; }

        [ForeignKey("Product")]
        [Column("product_id")]
        public int ProductId { get; set; }
        public Product Product { get; set; }

        public string ImageUrl { get; set; }
    }
}
