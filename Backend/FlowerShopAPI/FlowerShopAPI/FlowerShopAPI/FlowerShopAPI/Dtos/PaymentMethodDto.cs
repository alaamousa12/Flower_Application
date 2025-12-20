namespace FlowerShopAPI.Dtos
{
    public class PaymentMethodDto
    {
        public int UserId { get; set; }
        public string Name { get; set; }
        public string CardNumber { get; set; }
        public string ExpiryDate { get; set; }
    }
}