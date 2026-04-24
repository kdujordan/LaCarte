from django.db.models import F
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.utils import timezone
from core.models import Order
from .models import DailySalesAnalytics, ProductsAnalytics, MenuPopularity
from django.core.mail import EmailMessage
from django.conf import settings
from django_rest_passwordreset.signals import reset_password_token_created


@receiver(post_save, sender=Order)
def update_sales_analytics(sender, instance, **kwargs):
    if instance.status == Order.Status.PAID:
        today = timezone.now().date()

        #Get or create the row for today
        daily_stat, created = DailySalesAnalytics.objects.get_or_create(date=today)

        #Update total revenue and counts
        daily_stat.total_revenue = F('total_revenue') + instance.total_price
        daily_stat.total_orders = F('total_orders') + 1

        #Update takeaway/dine-in counts
        if instance.is_takeaway:
            daily_stat.takeaway_orders = F('takeaway_orders') + 1
        else:
            daily_stat.dine_in_orders = F('dine_in_orders') + 1

        #Track peak hour
        current_hour = instance.created_at.strftime('%H:00')
        if daily_stat.peak_hour == current_hour:
            daily_stat.peak_hour = current_hour
        
        daily_stat.save()

@receiver(post_save, sender=Order) 
def update_product_performance(sender, instance, **kwargs):
    if instance.status == Order.Status.PAID:
        for item in instance.items.all():
            product_stat, created = ProductsAnalytics.objects.get_or_create(
                menu_item=item.menu_item
            )
            product_stat.total_quantity_sold = F('total_quantity_sold') + item.quantity
            product_stat.total_revenue = F('total_revenue') + item.get_subtotal()
            product_stat.save()

@receiver(post_save, sender=Order)
def update_menu_popularity(sender, instance, **kwargs):
    if instance.status == Order.Status.PAID:
        for item in instance.items.all():
            popularity_stat, created = MenuPopularity.objects.get_or_create(
                item_name=item.menu_item.name
            )
            popularity_stat.sales_count = F('sales_count') + item.quantity
            popularity_stat.save()


# @receiver(reset_password_token_created)
# def password_reset_token_created(sender, request, reset_password_token, *args, **kwargs):
    
#     #This is to link to the frontend reset password page
    
#     email_plaintext_message = "{}?token={}".format(settings.FRONTEND_URLS, reset_password_token.key)
                
#     email = EmailMessage(
#         subject= "Password Reset",
#         body= email_plaintext_message,
#         from_email=settings.EMAIL_HOST_USER,
#         to=[reset_password_token.user.email],
#     )
#     email.send()
        