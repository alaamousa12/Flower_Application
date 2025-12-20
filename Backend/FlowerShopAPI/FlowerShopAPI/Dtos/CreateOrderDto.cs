namespace FlowerShopAPI.Dtos
{
    public class CreateOrderDto
    {
        public int UserId { get; set; }

        // ✅ خليها nullable
        public int? AddressId { get; set; }

        public string PaymentMethod { get; set; } = "Cash";

        public List<OrderItemDto> Items { get; set; } = new();
    }

    public class OrderItemDto
    {
        public int ProductId { get; set; }
        public int Quantity { get; set; }
    }
}
