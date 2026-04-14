from django.contrib import admin
from .models import User, DailySalesAnalytics, ProductsAnalytics, MenuPopularity

# Register your models here.
admin.site.register(User)
admin.site.register(DailySalesAnalytics)
admin.site.register(ProductsAnalytics)
admin.site.register(MenuPopularity)
