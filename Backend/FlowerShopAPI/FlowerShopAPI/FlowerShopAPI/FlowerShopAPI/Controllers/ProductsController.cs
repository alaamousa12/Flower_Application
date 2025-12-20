using FlowerShopAPI.Data;
using FlowerShopAPI.Dtos;
using FlowerShopAPI.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FlowerShopAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        private readonly FlowerShopDbContext _context;

        public ProductsController(FlowerShopDbContext context)
        {
            _context = context;
        }

        // 1. GET: api/Products 
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Product>>> GetProducts()
        {
            return await _context.Products
                .Include(p => p.Category)      // هات اسم القسم مع المنتج
                .Include(p => p.Seller)        // هات اسم البائع
                .Include(p => p.ProductImages) // هات صور المنتج الإضافية
                .ToListAsync();
        }

        // 2. GET: api/Products/5 
        [HttpGet("{id}")]
        public async Task<ActionResult<Product>> GetProduct(int id)
        {
            var product = await _context.Products
                .Include(p => p.Category)
                .Include(p => p.Seller)
                .Include(p => p.ProductImages)
                .Include(p => p.Reviews)      
                .FirstOrDefaultAsync(p => p.ProductId == id);

            if (product == null)
            {
                return NotFound();
            }

            return product;
        }




        // POST: api/Products
        [HttpPost]
        public async Task<ActionResult<Product>> PostProduct([FromForm] ProductUploadDto dto) // لاحظ [FromForm] مش [FromBody]
        {
            // 1. تجهيز مسار الصورة (URL)
            string imageUrl = "";

            // 2. لو اليوزر باعت صورة، نرفعها
            if (dto.ImageFile != null)
            {
                // بنحدد المكان اللي هنحفظ فيه (فولدر اسمه images جوه wwwroot)
                var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images");

                // لو الفولدر مش موجود بنعمله
                if (!Directory.Exists(uploadsFolder))
                {
                    Directory.CreateDirectory(uploadsFolder);
                }

                // بنعمل اسم مميز للصورة عشان لو صورتين بنفس الاسم ميدخلوش في بعض
                // مثلا: guid-image.jpg
                var uniqueFileName = Guid.NewGuid().ToString() + "_" + dto.ImageFile.FileName;
                var filePath = Path.Combine(uploadsFolder, uniqueFileName);

                // عملية النسخ الحقيقية للملف على السيرفر
                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    await dto.ImageFile.CopyToAsync(fileStream);
                }

                // بنعمل الرابط اللي هيتخزن في الداتابيز
                // النتيجة هتكون: http://localhost:5104/images/xyz.jpg
                var baseUrl = $"{this.Request.Scheme}://{this.Request.Host}{this.Request.PathBase}";
                imageUrl = $"{baseUrl}/images/{uniqueFileName}";
            }

            // 3. نملأ بيانات المنتج ونحفظ في الداتابيز
            var product = new Product
            {
                Name = dto.Name,
                Price = dto.Price,
                Description = dto.Description,
                Quantity = dto.Quantity,
                CategoryId = dto.CategoryId,
                SellerId = dto.SellerId,
                MainImageUrl = imageUrl, // هنا حطينا الرابط اللي اتعمل
                CreatedAt = DateTime.UtcNow
            };

            _context.Products.Add(product);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetProduct", new { id = product.ProductId }, product);
        }


        // 4. GET: api/Products/search/rose 
        [HttpGet("search/{name}")]
        public async Task<ActionResult<IEnumerable<Product>>> SearchProducts(string name)
        {
            return await _context.Products
                .Where(p => p.Name.Contains(name) || p.Description.Contains(name))
                .Include(p => p.Category)
                .ToListAsync();
        }


        public class ProductUploadDto
        {
            public string Name { get; set; }
            public decimal Price { get; set; }
            public string Description { get; set; }
            public int Quantity { get; set; }
            public int CategoryId { get; set; }
            public int SellerId { get; set; }

            // دي أهم حاجة: المتغير اللي هيشيل الملف نفسه
            public IFormFile ImageFile { get; set; }
        }

        // 5. تعديل منتج موجود
        // PUT: api/Products/5
        [HttpPut("{id}")]
        public async Task<IActionResult> PutProduct(int id, [FromForm] ProductUploadDto dto)
        {
            // 1. البحث عن المنتج القديم
            var product = await _context.Products.FindAsync(id);
            if (product == null)
            {
                return NotFound($"Product with ID {id} not found.");
            }

            // 2. تحديث البيانات النصية
            product.Name = dto.Name;
            product.Price = dto.Price;
            product.Description = dto.Description;
            product.Quantity = dto.Quantity;
            product.CategoryId = dto.CategoryId;
            product.SellerId = dto.SellerId;

            // (اختياري) لو عندك حقل UpdatedAt ممكن تحدثه هنا
            // product.UpdatedAt = DateTime.UtcNow;

            // 3. لو فيه صورة جديدة جاية، نغير الصورة
            if (dto.ImageFile != null)
            {
                // أ) نمسح الصورة القديمة من السيرفر (عشان المساحة)
                if (!string.IsNullOrEmpty(product.MainImageUrl))
                {
                    var oldFileName = Path.GetFileName(product.MainImageUrl);
                    var oldFilePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images", oldFileName);
                    if (System.IO.File.Exists(oldFilePath))
                    {
                        System.IO.File.Delete(oldFilePath);
                    }
                }

                // ب) نرفع الصورة الجديدة (نفس كود POST)
                var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images");
                var uniqueFileName = Guid.NewGuid().ToString() + "_" + dto.ImageFile.FileName;
                var filePath = Path.Combine(uploadsFolder, uniqueFileName);

                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    await dto.ImageFile.CopyToAsync(fileStream);
                }

                // ج) نحدث الرابط في الداتابيز
                var baseUrl = $"{this.Request.Scheme}://{this.Request.Host}{this.Request.PathBase}";
                product.MainImageUrl = $"{baseUrl}/images/{uniqueFileName}";
            }

            // 4. حفظ التغييرات
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!_context.Products.Any(e => e.ProductId == id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent(); // 204 No Content (معناها تم التعديل بنجاح)
        }



        // 6. حذف منتج
        // DELETE: api/Products/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteProduct(int id)
        {
            // 1. البحث عن المنتج
            var product = await _context.Products.FindAsync(id);
            if (product == null)
            {
                return NotFound();
            }

            // 2. حذف الصورة من السيرفر (تنظيف)
            if (!string.IsNullOrEmpty(product.MainImageUrl))
            {
                // بنستخرج اسم الملف من الرابط
                var fileName = Path.GetFileName(product.MainImageUrl);
                var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images", fileName);

                // لو الملف موجود نمسحه
                if (System.IO.File.Exists(filePath))
                {
                    System.IO.File.Delete(filePath);
                }
            }

            // 3. حذف المنتج من الداتابيز
            _context.Products.Remove(product);
            await _context.SaveChangesAsync();

            return NoContent();
        }


        // GET: api/Products/special-offers
        [HttpGet("special-offers")]
        public async Task<ActionResult<IEnumerable<Product>>> GetSpecialOffers()
        {
            return await _context.Products
                .Where(p => p.IsSpecialOffer == true)
                .Include(p => p.Category)
                .Include(p => p.Seller)
                .Include(p => p.ProductImages)
                .ToListAsync();
        }

        // PUT: api/Products/5/special-offer
        [HttpPut("{id}/special-offer")]
        public async Task<IActionResult> SetSpecialOffer(int id, [FromBody] SpecialOfferDto dto)
        {
            var product = await _context.Products.FindAsync(id);
            if (product == null) return NotFound();

            product.IsSpecialOffer = dto.IsSpecialOffer;
            product.DiscountPercent = dto.IsSpecialOffer ? dto.DiscountPercent : 0;

            await _context.SaveChangesAsync();
            return Ok(new { message = "Special offer updated" });
        }


        // GET: api/Products/category/5
        // دالة لجلب المنتجات بناءً على رقم القسم
        [HttpGet("category/{categoryId}")]
        public async Task<ActionResult<IEnumerable<Product>>> GetProductsByCategory(int categoryId)
        {
            var products = await _context.Products
                .Where(p => p.CategoryId == categoryId) // فلترة بالقسم
                .Include(p => p.Category)
                .Include(p => p.Seller)
                .Include(p => p.ProductImages)
                .ToListAsync();

            if (products == null || !products.Any())
            {
                return NotFound("No products found for this category.");
            }

            return products;
        }
    }

}
