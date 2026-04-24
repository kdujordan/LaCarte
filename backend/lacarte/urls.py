"""
URL configuration for lacarte project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/6.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from core.views import MenuItemViewSet, OrderSessionViewSet, OrderViewSet, StaffNotificationViewSet, FeedbackViewSet, TableViewSet
from rest_framework.routers import DefaultRouter
from analytics.views import DailySalesAnalyticsView, ProductsAnalyticsView, MenuPopularityView, SalesTrendView, PasswordResetRequestView, PasswordResetConfirmView, StaffManagementViewSet
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from .serializers import CustomTokenObtainPairSerializer
from .permissions import IsHeadOfOperations, IsOrderManager, UserSerializer

class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer

router = DefaultRouter()
router.register(r'menu-items', MenuItemViewSet)
router.register(r'order-sessions', OrderSessionViewSet)
router.register(r'orders', OrderViewSet)
router.register(r'staff-notifications', StaffNotificationViewSet)
router.register(r'feedback', FeedbackViewSet)
router.register(r'tables', TableViewSet)

analytics_router = DefaultRouter()  
analytics_router.register(r'staff', StaffManagementViewSet, basename='staff-managment')


urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include(router.urls)),
    path('api/analytics/daily-sales/', DailySalesAnalyticsView.as_view(), name='daily-sales'),
    path('api/analytics/products/', ProductsAnalyticsView.as_view(), name='products'),
    path('api/analytics/menu-popularity/', MenuPopularityView.as_view(), name='menu-popularity'),
    path('api/analytics/sales-trend/', SalesTrendView.as_view(), name='sales-trend'),
    path('api/token/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/analytics/', include(analytics_router.urls)),
    # path('api/password_reset/', include('django_rest_passwordreset.urls', namespace='password_reset')),

    path("api/password/reset/", views.PasswordResetRequestView.as_view(), name="request-password-reset"),
    path("api/password/confirm/<uidb64>/<token>", views.PasswordResetConfirmView.as_view(), name="confirm-password-reset"),
]
