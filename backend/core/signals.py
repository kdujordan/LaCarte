from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Order, StaffNotification

@receiver(post_save, sender=Order)
def create_order_notification(sender, instance, created, **kwargs):
    """
    Create a notification when a new order is placed
    """
    if created:
        # Get all staff members

        StaffNotification.objects.create(
            notification_type='NEW_ORDER',
            message=f"New order received for Table {instance.session.table.table_number}",
            order=instance,
            table=instance.session.table
        )

@receiver(post_save, sender=Order)
def update_order_status_notification(sender, instance, created, **kwargs):
    if not created and instance.status == 'SERVED':
        StaffNotification.objects.create(
            notification_type='ORDER_SERVED',
            message=f"Order {instance.id} has been served",
            order=instance,
            table=instance.session.table
        )

@receiver(post_save, sender=Order)
def update_order_status_notification(sender, instance, created, **kwargs):
    if not created and instance.status == 'PAID':
        StaffNotification.objects.create(
            notification_type='PAYMENT_RECEIVED',
            message=f"Payment received for Order {instance.id}",
            order=instance,
            table=instance.session.table
        )



            