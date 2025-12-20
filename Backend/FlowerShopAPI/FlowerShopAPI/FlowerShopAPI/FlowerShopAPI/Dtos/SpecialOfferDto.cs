namespace FlowerShopAPI.Dtos
{
    public class SpecialOfferDto
    {
        public bool IsSpecialOffer { get; set; }
        public decimal DiscountPercent { get; set; } = 0;
    }
}
