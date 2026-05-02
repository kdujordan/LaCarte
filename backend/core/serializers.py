from rest_framework import serializers
from .models import (
    Table,
    OrderSession,
    MenuItem,
    Order,
    OrderItem,
    Receipt,
    StaffNotification,
    Feedback,
    Category,
)


class MenuItemSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()

    class Meta:
        model = MenuItem
        fields = [
            "id",
            "name",
            "price",
            "description",
            "category",
            "image",
            "image_url",
            "is_available",
        ]
        extra_kwargs = {
            "image": {"write_only": True}
        }  # We only want to accept the image

    def get_image_url(self, obj):
        if obj.image:
            return obj.image.build_url(
                width=800, height=600, crop="fill", quality="auto"
            )
        return None


class MenuItemListSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()
    is_popular = serializers.BooleanField(default=False)
    category_name = serializers.ReadOnlyField(source="category.name")

    class Meta:
        model = MenuItem
        fields = [
            "id",
            "name",
            "price",
            "description",
            "category",
            "image",
            "image_url",
            "is_available",
            "is_popular",
            "category_name",
        ]
        extra_kwargs = {
            "image": {"write_only": True}
        }  # We only want to accept the image on create/update, not return it in list views

    def get_image_url(self, obj):
        if obj.image:
            return obj.image.build_url(
                width=800, height=600, crop="fill", quality="auto"
            )
        return None


class OrderItemSerializer(serializers.ModelSerializer):
    items_details = MenuItemSerializer(read_only=True, source="menu_item")

    class Meta:
        model = OrderItem
        fields = [
            "id",
            "menu_item",
            "items_details",
            "quantity",
            "price_at_order",
            "get_subtotal",
        ]


class OrderSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True)
    total_price = serializers.ReadOnlyField()

    class Meta:
        model = Order
        fields = [
            "id",
            "session",
            "order_type",
            "status",
            "created_at",
            "is_takeaway",
            "items",
            "total_price",
        ]

    def create(self, validated_data):
        """
        Handle nested OrderItem creation
        """
        # Extract the items list from the validated data
        items_data = validated_data.pop("items")
        order = Order.objects.create(**validated_data)
        for item_data in items_data:
            menu_item = items_data["menu_item"]
            OrderItem.objects.create(
                order=order,
                menu_item=menu_item,
                quantity=item_data["quantity"],
                special_requests=item_data["special_requests"],
            )
        return order


class OrderUpdateStatusSerializer(serializers.ModelSerializer):
    """
    Used for updating order status (e.g., PREPARING -> SERVED)
    """

    class Meta:
        model = Order
        fields = ["status"]


class ReceiptSerializer(serializers.ModelSerializer):
    class Meta:
        model = Receipt
        fields = [
            "id",
            "order",
            "receipt_number",
            "payment_method",
            "amount_paid",
            "change_due",
            "payment_time",
            "printed_at",
        ]

    def validate(self, attrs):
        """
        Ensure amount_paid is not less than total_price
        """
        order = self.instance.order if self.instance else self.initial_data.get("order")
        if order:
            total_price = order.total_price
            amount_paid = attrs.get("amount_paid", 0)
            if amount_paid < total_price:
                raise serializers.ValidationError(
                    {
                        "amount_paid": f"Amount paid ({amount_paid}) must be at least the total price ({total_price})"
                    }
                )
        return attrs

    def create(self, validated_data):
        """
        Generate receipt number and calculate change_due
        """
        order = validated_data["order"]
        total_price = order.total_price
        amount_paid = validated_data["amount_paid"]
        change_due = amount_paid - total_price

        # Generate receipt number (simple implementation)
        receipt_number = f"RCPT-{order.id:06d}"

        receipt = Receipt.objects.create(
            order=order,
            receipt_number=receipt_number,
            payment_method=validated_data["payment_method"],
            amount_paid=amount_paid,
            change_due=change_due,
        )

        # Update order status to PAID
        order.status = "PAID"
        order.save()

        return receipt


class TableSerializer(serializers.ModelSerializer):
    class Meta:
        model = Table
        fields = ["id", "table_number", "qr_code_id", "is_active"]


class FeedbackSerializer(serializers.ModelSerializer):
    order_details = OrderSerializer(read_only=True, source="order")
    table_details = TableSerializer(read_only=True, source="table")

    class Meta:
        model = Feedback
        fields = [
            "id",
            "feedback_type",
            "rating",
            "message",
            "order",
            "table",
            "order_details",
            "table_details",
            "is_read",
            "created_at",
        ]

    def create(self, validated_data):
        """
        Create a new feedback instance
        """
        feedback = Feedback.objects.create(**validated_data)
        return feedback


class StaffNotificationSerializer(serializers.ModelSerializer):
    order_details = OrderSerializer(read_only=True, source="order")
    table_details = TableSerializer(read_only=True, source="table")

    class Meta:
        model = StaffNotification
        fields = [
            "id",
            "notification_type",
            "message",
            "order",
            "table",
            "order_details",
            "table_details",
            "is_read",
            "created_at",
        ]

    def create(self, validated_data):
        """
        Create a new staff notification instance
        """
        notification = StaffNotification.objects.create(**validated_data)
        return notification


class OrderSessionSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderSession
        fields = ["id", "table", "is_active", "created_at"]


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ["id", "name", "display_order", "icon_name", "is_active"]
