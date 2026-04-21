from django.db import models
from django.contrib.auth.models import AbstractUser


# Create your models here.
class User(AbstractUser):
    class Role(models.TextChoices):
        ADMIN = "ADMIN", "Admin"
        HEAD_OF_OPERATIONS = "HEAD_OF_OPERATIONS", "Head of Operations"
        ORDER_MANAGER = "ORDER_MANAGER", "Order Manager"
        
    role = models.CharField(
        max_length=50,
        choices=Role.choices,
        default=Role.ORDER_MANAGER,
    )
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    email = models.EmailField(max_length=100, unique=True)
    is_approved = models.BooleanField(default=False)
    
    
    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = []
    
    def __str__(self):
        return f"{self.username} - {self.role}"

class DailySalesAnalytics(models.Model):
    date = models.DateField(unique=True)
    total_revenue = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    total_orders = models.PositiveIntegerField(default=0)
    takeaway_orders = models.PositiveIntegerField(default=0)
    dine_in_orders = models.PositiveIntegerField(default=0)
    
    #To Track peak hours
    peak_hour = models.CharField(max_length=5, blank=True, null=True)
    
    def __str__(self):
        return f"{self.date} - {self.total_revenue}"

class ProductsAnalytics(models.Model):
    menu_item = models.OneToOneField('core.MenuItem', on_delete=models.CASCADE)
    total_quantity_sold = models.PositiveIntegerField(default=0)
    total_revenue = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    last_updated = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Sales Stats for {self.menu_item.name}"


class MenuPopularity(models.Model):
    item_name = models.CharField(max_length=255)
    sales_count = models.PositiveIntegerField(default=0)
    last_updated = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.item_name} - {self.sales_count}"
    