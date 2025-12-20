using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FlowerShopAPI.Models
{
    // Models/PaymentMethod.cs  (Save_payment_method)
    [Table("Save_payment_method")]
    public class PaymentMethod
    {
        [Key]
        [Column("card_id")]
        public int CardId { get; set; }

        [ForeignKey("User")]
        [Column("user_id")]
        public int UserId { get; set; }
        public User User { get; set; }

        [MaxLength(150)]
        public string Name { get; set; } // card holder name

        [MaxLength(30)]
        public string CardNumber { get; set; } // consider encrypting in DB

        public string ExpiryDate { get; set; } // MM/YY or store as Date
    }

}
