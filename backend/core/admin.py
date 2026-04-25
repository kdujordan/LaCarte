from django.contrib import admin
from .models import (
    MenuItem,
    Order,
    OrderItem,
    Receipt,
    Feedback,
    OrderSession,
    Table,
    Category,
)

# Register your models here.
admin.site.register(MenuItem)
admin.site.register(Order)
admin.site.register(OrderItem)
admin.site.register(Receipt)
admin.site.register(Feedback)
admin.site.register(OrderSession)
admin.site.register(Table)
admin.site.register(Category)
