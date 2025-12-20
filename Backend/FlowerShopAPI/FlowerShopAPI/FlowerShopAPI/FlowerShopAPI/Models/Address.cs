using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace FlowerShopAPI.Models
{
    // Models/Address.cs
    [Table("Addresses")]
    public class Address
    {
        [Key]
        [Column("address_id")]
        public int AddressId { get; set; }

        [ForeignKey("User")]
        [Column("fk_user_id")]
        public int UserId { get; set; }
        public User User { get; set; }

        [MaxLength(300)]
        public string Street { get; set; }

        [MaxLength(120)]
        public string City { get; set; }

        [MaxLength(50)]
        public string PostalCode { get; set; }
    }

}
