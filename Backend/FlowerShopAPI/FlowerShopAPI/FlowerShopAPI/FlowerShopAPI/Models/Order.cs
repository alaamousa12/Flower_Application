using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FlowerShopAPI.Models
{
    // Models/Order.cs
    [Table("Orders")]
    public class Order
    {
        [Key]
        [Column("order_id")]
        public int OrderId { get; set; }

        [ForeignKey("User")]
        [Column("fk_user_id")]
        public int UserId { get; set; }
        public User User { get; set; }

        public DateTime OrderDate { get; set; } = DateTime.UtcNow;

        [Column(TypeName = "decimal(18,2)")]
        public decimal TotalAmount { get; set; }

        [ForeignKey("Address")]
        [Column("fk_address_id")]
        public int? AddressId { get; set; } // optional if pickup
        public Address Address { get; set; }

        public string PaymentMethod { get; set; } // e.g., "card", "cash", or store reference to PaymentMethod

        [MaxLength(50)]
        public string Status { get; set; } // e.g., "Pending", "Processing", "Shipped", "Delivered"

        // Navigation
        public ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
    }

}
