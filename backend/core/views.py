from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework import viewsets, status
from .models import Table, OrderSession, MenuItem, Order, OrderItem, Receipt, StaffNotification, Feedback
from .serializers import TableSerializer, OrderSessionSerializer, MenuItemSerializer, OrderSerializer, OrderItemSerializer, ReceiptSerializer, StaffNotificationSerializer, FeedbackSerializer
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
# Create your views here.

class MenuItemViewSet(viewsets.ModelViewSet):
    """
    API Viewset for Menu Items, Staff mangses this in Dashboard, Customer can view this in Menu Page
    """
    queryset = MenuItem.objects.all()
    serializer_class = MenuItemSerializer
    
class OrderSessionViewSet(viewsets.ModelViewSet):
    """
   Handles the 'Start' of your Workflow (QR Scan & IP logging)
    """
    queryset = OrderSession.objects.filter(is_active=True)
    serializer_class = OrderSessionSerializer

class OrderViewSet(viewsets.ModelViewSet):
    """
    The core of your workflow: handles 'Order for Self' and 'Order for Others'
    and 'system Operations 'Status Updates.
    """
    queryset = Order.objects.all().order_button_by('-created_at')
    serializer_class = OrderSerializer
    
    @action(detail=True, methods=['patch'])
    def update_status(self, request, pk=None):
        """
        Custom action for the ' Update Status' button in System Operations
        """
        order = self.get_object()
        new_status = request.data.get('status')
        if new_status in dict(Order.STATUS_CHOICES):
            order.status = new_status
            order.save()
            return Response({'message': f'Order {order.id} status updated to {new_status}'}, status=status.HTTP_200_OK)
        return Response({'error': 'Invalid status value'}, status=status.HTTP_400_BAD_REQUEST)

class StaffNotificationViewSet(viewsets.ModelViewSet):
    """
    Used by the staff to 'Recevie morning  orders' and clear alerts.
    """
    queryset = StaffNotification.objects.all().order_by('-created_at')
    serializer_class = StaffNotificationSerializer
    
    @action(detail=False, methods=['post'])
    def mark_all_as_read(self, request):
        """
        Mark all notifications as read
        """
        notifications = self.get_queryset()
        notifications.update(is_read=True)
        return Response({'message': 'All notifications marked as read'}, status=status.HTTP_200_OK)
    
def post_order(request):
    
    #1 Grab the channel layer

    channel_layer = get_channel_layer()

    #2 prepare data for the kitchen 

    kitchen_data = {
        "order_id" : order.id,
        "table_number" : order.session_id.table.table_number,
        "items_count": order.items.count(),
        "status": order.status,
    }

    #3 Send the Message
    async_to_sync(channel_layer.group_send)(
        "kitchen_updates", {
            "type" : "order_received",
            "message" : kitchen_data
        }
    )

    return Response({"message": "Order successfully sent to kitchen!"})