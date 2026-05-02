from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework import viewsets, status
from .models import (
    Table,
    OrderSession,
    MenuItem,
    Order,
    OrderItem,
    Receipt,
    StaffNotification,
    Feedback,
)
from .serializers import (
    OrderSessionSerializer,
    MenuItemSerializer,
    OrderSerializer,
    OrderItemSerializer,
    ReceiptSerializer,
    StaffNotificationSerializer,
    FeedbackSerializer,
    OrderUpdateStatusSerializer,
    MenuItemListSerializer,
)
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from rest_framework.permissions import BasePermission, AllowAny
from rest_framework.views import APIView
from .authentication import GuestSessionAuthentication
import jwt
import datetime
from django.conf import settings
from .models import Category
from .serializers import CategorySerializer
from django_filters.rest_framework import DjangoFilterBackend

from rest_framework.parsers import MultiPartParser, FormParser


# Create your views here.
class OrderUpdateStatusViewSet(viewsets.ModelViewSet):
    queryset = Order.objects.all()
    serializer_class = OrderUpdateStatusSerializer

    @action(detail=True, methods=["patch"])
    def update_status(self, request, pk=None):
        """
        Custom action for the ' Update Status' button in System Operations
        """
        order = self.get_object()
        new_status = request.data.get("status")
        if new_status in dict(Order.STATUS_CHOICES):
            order.status = new_status
            order.save()
            return Response(
                {"message": f"Order {order.id} status updated to {new_status}"},
                status=status.HTTP_200_OK,
            )
        return Response(
            {"error": "Invalid status value"}, status=status.HTTP_400_BAD_REQUEST
        )


class FeedbackViewSet(viewsets.ModelViewSet):
    queryset = Feedback.objects.all()
    serializer_class = FeedbackSerializer

    @action(detail=False, methods=["get"])
    def get_feedback(self, request):
        """
        Custom action for the 'Get Feedback' button in System Operations
        """
        feedback = self.get_queryset()
        return Response(FeedbackSerializer(feedback, many=True).data)

    def create_feedback(self, request):
        """
        Custom action for the 'Create Feedback' button in System Operations
        """
        feedback = self.create(request.data)
        return Response(FeedbackSerializer(feedback).data)


class ReceiptViewSet(viewsets.ModelViewSet):
    queryset = Receipt.objects.all()
    serializer_class = ReceiptSerializer

    @action(detail=True, methods=["get"])
    def get_receipt(self, request, pk=None):
        """
        Custom action for the 'Get Receipt' button in System Operations
        """
        receipt = self.get_object()
        return Response(ReceiptSerializer(receipt).data)

    @action(detail=False, methods=["post"])
    def create_receipt(self, request):
        """
        Custom action for the 'Create Receipt' button in System Operations
        """
        receipt = self.create(request.data)
        return Response(ReceiptSerializer(receipt).data)


class OrderItemViewSet(viewsets.ModelViewSet):
    queryset = OrderItem.objects.all()
    serializer_class = OrderItemSerializer

    @action(detail=False, methods=["get"])
    def get_order_items(self, request):
        """
        Custom action for the 'Get Order Items' button in Order Page
        """
        order_items = self.get_queryset()
        return Response(OrderItemSerializer(order_items, many=True).data)


class MenuItemViewSet(viewsets.ModelViewSet):
    """
    API Viewset for Menu Items, Staff mangses this in Dashboard, Customer can view this in Menu Page
    """

    queryset = MenuItem.objects.all()
    serializer_class = MenuItemSerializer
    parser_classes = [MultiPartParser, FormParser]

    @action(detail=False, methods=["get"])
    def get_menu_items(self, request):
        """
        Custom action for the 'Get Menu Items' button in Menu Page
        """
        menu_items = self.get_queryset()
        return Response(MenuItemSerializer(menu_items, many=True).data)

    @action(detail=False, methods=["post"])
    def create_menu_item(self, request):
        """
        Custom action for the 'Create Menu Item' button in Dashboard
        """
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save() #this triggers the Cloudinary upload and saves the URL in the model
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=True, methods=["put"])
    def update_menu_item(self, request, pk=None):
        """
        Custom action for the 'Update Menu Item' button in Dashboard
        """
        menu_item = self.get_object()
        menu_item = self.update(request, pk)
        return Response(MenuItemSerializer(menu_item).data)

    @action(detail=True, methods=["delete"])
    def delete_menu_item(self, request, pk=None):
        """
        Custom action for the 'Delete Menu Item' button in Dashboard
        """
        menu_item = self.get_object()
        menu_item.delete()
        return Response({"message": f"Menu Item {menu_item.id} deleted successfully"})


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

    queryset = Order.objects.all().order_by("-created_at")
    serializer_class = OrderSerializer

    @action(detail=True, methods=["patch"])
    def update_status(self, request, pk=None):
        """
        Custom action for the ' Update Status' button in System Operations
        """
        order = self.get_object()
        new_status = request.data.get("status")
        if new_status in dict(Order.STATUS_CHOICES):
            order.status = new_status
            order.save()
            return Response(
                {"message": f"Order {order.id} status updated to {new_status}"},
                status=status.HTTP_200_OK,
            )
        return Response(
            {"error": "Invalid status value"}, status=status.HTTP_400_BAD_REQUEST
        )


class StaffNotificationViewSet(viewsets.ModelViewSet):
    """
    Used by the staff to 'Recevie morning  orders' and clear alerts.
    """

    queryset = StaffNotification.objects.all().order_by("-created_at")
    serializer_class = StaffNotificationSerializer

    @action(detail=False, methods=["post"])
    def mark_all_as_read(self, request):
        """
        Mark all notifications as read
        """
        notifications = self.get_queryset()
        notifications.update(is_read=True)
        return Response(
            {"message": "All notifications marked as read"}, status=status.HTTP_200_OK
        )


class ScanTableQRView(APIView):
    authentication_classes = []
    permission_classes = []

    def post(self, request):
        qr_code_id = request.data.get("qr_code_id")
        ip_address = request.META.get("REMOTE_ADDR", "0.0.0.0")

        # 1. Verify QR Code
        try:
            table = Table.objects.get(qr_code_id=qr_code_id, is_active=True)
        except Table.DoesNotExist:
            return Response(
                {"error": "Invalid QR Code"}, status=status.HTTP_404_NOT_FOUND
            )

        # 2. Start a Session
        # This is the "Start" of the workflow
        session = OrderSession.objects.create(
            table=table, is_active=True, ip_address=ip_address
        )

        payload = {
            "session_id": str(session.session_id),
            # token to expire in 3hour
            "exp": datetime.datetime.now(datetime.timezone.utc)
            + datetime.timedelta(hours=3),
            "iat": datetime.datetime.now(datetime.timezone.utc),
        }

        # generate token using Django's secret key
        token = jwt.encode(payload, settings.SECRET_KEY, algorithm="HS256")

        return Response(
            {
                "message": "Welcome to La Carte!",
                "session_id": session.session_id,
                "table_number": table.table_number,
                "access_token": token,
            }
        )


class IsActiveGuestSession(BasePermission):
    def has_permission(self, request, view):
        # request.auth is the session object returned by the authentication class
        return request.auth and isinstance(request.auth, OrderSession)


class PlaceOrderView(APIView):
    authentication_classes = [GuestSessionAuthentication]
    permission_classes = [IsActiveGuestSession]

    def post(self, request):
        """ """
        active_session = request.auth

        order = Order.objects.create(
            session_id=active_session,
            order_type=request.data.get("order_type", "order_for_self"),
            order={
                "items": request.data.get("items"),
                "total_price": request.data.get("total_price"),
                "quantity": request.data.get("quantity"),
                "special_requests": request.data.get("special_requests"),
            },
        )

        channel_layer = get_channel_layer()

        # 2 prepare data for the kitchen

        kitchen_data = {
            "order_id": order.id,
            "table_number": order.session_id.table.table_number,
            "items_count": order.items.count(),
            "status": order.status,
        }

        # 3 Send the Message
        async_to_sync(channel_layer.group_send)(
            "kitchen_updates", {"type": "order_received", "message": kitchen_data}
        )

        return Response({"message": "Order successfully sent to kitchen!"})


class CategorizedMenuViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = MenuItem.objects.all().order_by("name")
    serializer_class = MenuItemListSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_fields = ["category"]
    authentication_classes = []
    permission_classes = [AllowAny]

    @action(detail=False, methods=["get"])
    def categories(self, request):
        categories = Category.objects.filter(is_active=True).order_by("display_order")
        serializer = CategorySerializer(categories, many=True)
        return Response(serializer.data)
