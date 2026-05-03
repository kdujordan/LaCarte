from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator
import uuid
from cloudinary.models import CloudinaryField


# Create your models here.


class Table(models.Model):
    table_number = models.CharField(max_length=10, unique=True)
    qr_code_id = models.CharField(max_length=100, unique=True, editable=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"Table {self.table_number}"


class OrderSession(models.Model):
    """
    Matches your 'n for the number of  time and the ip address' block .
    """

    table = models.ForeignKey(Table, on_delete=models.CASCADE)
    session_id = models.UUIDField(unique=True, default=uuid.uuid4, editable=False)
    ip_address = models.GenericIPAddressField()
    num_people = models.PositiveIntegerField(
        default=1, validators=[MinValueValidator(1)]
    )
    start_time = models.DateTimeField(auto_now_add=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"Order Session {self.id} for Table {self.table.table_number}"


class Category(models.Model):
    name = models.CharField(max_length=100, unique=True)
    display_order = models.PositiveIntegerField(default=0)
    icon_name = models.CharField(max_length=50, blank=True, null=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = "Category"
        verbose_name_plural = "Categories"
        ordering = ["display_order", "name"]


class MenuItem(models.Model):
    name = models.CharField(max_length=200)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    description = models.TextField(blank=True)
    category = models.ForeignKey(
        Category, on_delete=models.SET_NULL, null=True, related_name="items"
    )
    image = CloudinaryField("menu_images", blank=True, null=True)
    is_available = models.BooleanField(default=True)

    def __str__(self):
        return self.name


class Order(models.Model):
    ORDER_TYPES = [
        ("SELF", "Ordering for Self"),
        ("GROUP", "Ordering for Self and others"),
    ]
    STATUS_CHOICES = [
        ("PENDING", "Awaiting Status"),
        ("PREPARING", "In Kitchen"),
        ("SERVED", "Served"),
        ("PAID", "Paid"),
        ("CANCELLED", "Cancelled"),
    ]

    session = models.ForeignKey(
        OrderSession, on_delete=models.CASCADE, related_name="orders"
    )
    order_type = models.CharField(max_length=10, choices=ORDER_TYPES, default="SELF")
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default="PENDING")
    created_at = models.DateTimeField(auto_now_add=True)
    is_takeaway = models.BooleanField(default=False)

    @property
    def total_price(self):
        return sum(item.get_subtotal() for item in self.items.all())

    def __str__(self):
        return f"Order {self.id} for Table {self.session.table.table_number}"


class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name="items")
    menu_item = models.ForeignKey(MenuItem, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1, validators=[MinValueValidator(1)])
    special_requests = models.TextField(blank=True, null=True)

    # We store price at time of order in case menu pices change later
    price_at_order = models.DecimalField(max_digits=10, decimal_places=2)

    def get_subtotal(self):
        return self.quantity * self.price_at_order

    def save(self, *args, **kwargs):
        if not self.price_at_order:
            self.price_at_order = self.menu_item.price
        super().save(*args, **kwargs)


class Receipt(models.Model):
    """
    Generated during ' System Ore Operations' (System OPS)
    """

    PAYMENT_METHOD_CHOICES = [
        ("CASH", "Cash"),
        ("CARD", "Card"),
        ("MOMO", "Mobile Money"),
        ("CHEQUE", "Cheque"),
        ("OTHER", "Other"),
    ]
    order = models.OneToOneField(
        Order,
        on_delete=models.CASCADE,
    )
    receipt_number = models.CharField(max_length=20, unique=True)
    payment_method = models.CharField(
        max_length=10, choices=PAYMENT_METHOD_CHOICES, default="CASH"
    )
    amount_paid = models.DecimalField(max_digits=10, decimal_places=2)
    change_due = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    payment_time = models.DateTimeField(auto_now_add=True)
    printed_at = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return f"Receipt {self.receipt_number} for Order {self.order.id}"


class StaffNotification(models.Model):
    NOTIFICATION_TYPES = [
        ("NEW_ORDER", "New Order Received"),
        ("ORDER_READY", "Order Ready for Pickup/Serving"),
        ("ORDER_SERVED", "Order Served"),
        ("PAYMENT_RECEIVED", "Payment Received"),
        ("OTHER", "Other"),
    ]

    notification_type = models.CharField(max_length=20, choices=NOTIFICATION_TYPES)
    message = models.TextField()
    order = models.ForeignKey(Order, on_delete=models.CASCADE, null=True, blank=True)
    table = models.ForeignKey(Table, on_delete=models.CASCADE, null=True, blank=True)
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.type} - {self.message}"


class Feedback(models.Model):
    FEEDBACK_TYPES = [
        ("FOOD", "Food Quality"),
        ("SERVICE", "Service Quality"),
        ("CUSTOMER_EXPERIENCE", "Customer Experience"),
        ("OTHER", "Other"),
    ]

    feedback_type = models.CharField(max_length=20, choices=FEEDBACK_TYPES)
    rating = models.PositiveIntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(5)]
    )
    message = models.TextField()
    order = models.ForeignKey(Order, on_delete=models.CASCADE, null=True, blank=True)
    order_session = models.ForeignKey(
        OrderSession, on_delete=models.CASCADE, null=True, blank=True
    )
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.type} - {self.message}"
