from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.db.models import Sum, Count, F
from django.utils import timezone
from datetime import timedelta
from .models import DailySalesAnalytics, ProductsAnalytics, MenuPopularity
from .serializers import DailySalesAnalyticsSerializer, ProductsAnalyticsSerializer, MenuPopularitySerializer


class DailySalesAnalyticsView(APIView):
    permission_classes = [IsOrderManager]
    def get(self, request):
        today = timezone.now().date()
        yesterday = today - timedelta(days=1)
        
        #Get today's sales data
        today_data = DailySalesAnalytics.objects.filter(date=today).first()
        
        #Get yesterday's sales data
        yesterday_data = DailySalesAnalytics.objects.filter(date=yesterday).first()
        
        #Calculate percentage change
        if today_data and yesterday_data:
            revenue_change = ((today_data.total_revenue - yesterday_data.total_revenue) / yesterday_data.total_revenue) * 100
            order_change = ((today_data.total_orders - yesterday_data.total_orders) / yesterday_data.total_orders) * 100
        else:
            revenue_change = 0
            order_change = 0
        
        #Serialize today's data
        serializer = DailySalesAnalyticsSerializer(today_data)
        
        #Add percentage change to response
        response_data = serializer.data
        response_data['revenue_change'] = round(revenue_change, 2)
        response_data['order_change'] = round(order_change, 2)
        
        return Response(response_data)


class ProductsAnalyticsView(APIView):
    permission_classes = [IsOrderManager]
    def get(self, request):
        #Get top 10 best-selling products
        top_products = ProductsAnalytics.objects.order_by('-total_quantity_sold')[:10]
        serializer = ProductsAnalyticsSerializer(top_products, many=True)
        return Response(serializer.data)


class MenuPopularityView(APIView):
    permission_classes = [IsOrderManager]
    def get(self, request):
        #Get top 10 most popular menu items
        popular_items = MenuPopularity.objects.order_by('-sales_count')[:10]
        serializer = MenuPopularitySerializer(popular_items, many=True)
        return Response(serializer.data)


class SalesTrendView(views.APIView):
    permission_classes = [IsOrderManager]
    def get(self, request):
        #Get last 7 days of sales data
        last_7_days = timezone.now().date() - timedelta(days=6)
        sales_data = DailySalesAnalytics.objects.filter(date__gte=last_7_days).order_by('date')
        
        #Serialize the data
        data = {
                "labels" : [day.date.strftime('%a') for day in sales_data],
                "revenue" : [day.total_revenue for day in sales_data],
                "orders_volume" : [day.total_orders for day in sales_data],
                "order_type_distribution" : {
                    "takeaway" : sum(day.takeaway_orders for day in sales_data),
                    "dine_in" : sum(day.dine_in_orders for day in sales_data),
                }
            }
        
        return Response(data)


class StaffManagementViewSet(viewsets.ModelViewSet):
    """
    Dashboard for the Head of Operations to manage staff members
    """
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsHeadOfOperations]

    @action(detail=False, methods=['get'])
    def staff_list(self, request):
        staff = self.queryset.filter(is_approved=True)
        serializer = UserSerializer(staff, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['get'])
    def pending_staff_approvals(self, request):
        pending_staff = self.queryset.filter(is_approved=False)
        serializer = UserSerializer(pending_staff, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=['patch'])
    def approve_staff(self, request, pk=None):
        user = self.get_object()
        user.is_approved = True
        user.save()
        return Response({'message': 'Staff approved successfully'}, status=status.HTTP_200_OK)

    @action(detail=True, methods=['delete'])
    def reject_staff(self, request, pk=None):
        user = self.get_object()
        if user.is_approved or user.role == User.Role.HEAD_OF_OPERATIONS:
            return Response({'message': 'Staff cannot be rejected/deleted as they are the Head of Operations'}, status=status.HTTP_400_BAD_REQUEST)
        username = user.first_name + ' ' + user.last_name
        user.delete()
        return Response({'message': f'Registration for {username} has been rejected and removed from the system'}, status=status.HTTP_204_NO_CONTENT)

    @action(detail=True, methods=['delete'])
    def delete_staff(self, request, pk=None):
        user = self.get_object()
        if user.role == User.Role.HEAD_OF_OPERATIONS:
            return Response({'message': 'Staff cannot be deleted as they are the Head of Operations'}, status=status.HTTP_400_BAD_REQUEST)
        username = user.first_name + ' ' + user.last_name
        user.delete()
        return Response({'message': f'Registration for {username} has been deleted and removed from the system'}, status=status.HTTP_204_NO_CONTENT)