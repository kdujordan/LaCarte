from django.shortcuts import render
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework import viewsets, status
from .models import Table, OrderSession, MenuItem, Order, OrderItem, Receipt, StaffNotification, Feedback
from .serializers import TableSerializer, OrderSessionSerializer, MenuItemSerializer, OrderSerializer, OrderItemSerializer, ReceiptSerializer, StaffNotificationSerializer, FeedbackSerializer
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from rest_framework.permissions import BasePermission
from rest_framework.views import APIView
from rest_framework.exceptions import NotFound
from .authentication import GuestSessionAuthentication
import jwt
import datetime

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
    


class ScanTableQRView(APIView):
    permission_classes = []
    def post(self, request):
        qr_code_id = request.data.get('qr_code_id')
        ip_address = request.META.get('REMOTE_ADDR', '0.0.0.0')

        # 1. Verify QR Code
        try:
            table = Table.objects.get(qr_code_id=qr_code_id , is_active=True)
        except Table.DoesNotExist:
            return Response(
                {"error": "Invalid QR Code"}, 
                status=status.HTTP_404_NOT_FOUND
            )

        # 2. Start a Session
        # This is the "Start" of the workflow
        session = OrderSession.objects.create(
            table=table,
            is_active=True,
            defaults={
                "ip_address": ip_address
            }   
        )

        payload = {
            "session_id": str(session.session_id),
            #token to expire in 3hour

            'exp': datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(hours=3),
            'iat': datetime.datetime.now(datetime.timezone.utc)
            
        }

        #generate token using Django's secret key
        token = jwt.encode(payload, settings.SECRET_KEY, algorithm='HS256')

        return Response({
            "message": "Welcome to La Carte!",
            "session_id": session.session_id, 
            "table_number": table.table_number,
            "access_token": token
        })

class IsActiveGuestSession(BasePermission):
    
    def has_permission(self, request, view):
        # request.auth is the session object returned by the authentication class
        return request.auth and isinstance(request.auth, OrderSession)

class PlaceOrderView(APIView):
    authentication_classes = [GuestSessionAuthentication]
    permission_classes = [IsActiveGuestSession]

    def post(self, request):
        """
        """
        active_session = request.auth

        new_order = Order.objects.create(
            session_id=active_session,
            order_type=request.data.get("order_type", "order_for_self"),
            order = {
                'items' : request.data.get('items'),
                'total_price' : request.data.get('total_price'),
                'quantity' : request.data.get('quantity'),
                'special_requests' : request.data.get('special_requests')
            }
            
        )


        channel_layer = get_channel_layer()

        #2 prepare data for the kitchen 

        kitchen_data = {
            "order_id" : new_order.id,
            "table_number" : new_order.session_id.table.table_number,
            "items_count": new_order.items.count(),
            "status": new_order.status,
        }

        #3 Send the Message
        async_to_sync(channel_layer.group_send)(
            "kitchen_updates", {
                "type" : "order_received",
                "message" : kitchen_data
            }
        )

        return Response({"message": "Order successfully sent to kitchen!"})


        
    