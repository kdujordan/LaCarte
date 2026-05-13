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
from core.views import (
    MenuItemViewSet,
    OrderSessionViewSet,
    OrderViewSet,
    StaffNotificationViewSet,
    FeedbackViewSet,
    ScanTableQRView,
    OrderUpdateStatusViewSet,
    ReceiptViewSet,
    OrderItemViewSet,
    CategorizedMenuViewSet,
    PlaceOrderView,
    CategoryViewSet,
)
from rest_framework.routers import DefaultRouter
from analytics.views import (
    DailySalesAnalyticsView,
    ProductsAnalyticsView,
    MenuPopularityView,
    SalesTrendView,
    PasswordResetRequestView,
    PasswordResetConfirmView,
    StaffManagementViewSet,
    UserSignupView,
)
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from analytics.serializers import CustomTokenObtainPairSerializer
from django.conf import settings
from django.conf.urls.static import static


class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer


router = DefaultRouter()
router.register(r"menu-items", MenuItemViewSet)
router.register(r"order-sessions", OrderSessionViewSet)
router.register(r"orders", OrderViewSet)
router.register(r"staff-notifications", StaffNotificationViewSet)
router.register(r"feedback", FeedbackViewSet)
router.register(
    r"order-update-status", OrderUpdateStatusViewSet, basename="order-update-status"
)
router.register(r"receipts", ReceiptViewSet)
router.register(r"order-items", OrderItemViewSet)
router.register(r"category-menu", CategorizedMenuViewSet, basename="category-menu")
router.register(r"categories", CategoryViewSet, basename="categories")

analytics_router = DefaultRouter()
analytics_router.register(r"staff", StaffManagementViewSet, basename="staff-managment")


urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/", include(router.urls)),
    path(
        "api/analytics/daily-sales/",
        DailySalesAnalyticsView.as_view(),
        name="daily-sales",
    ),
    path("api/analytics/products/", ProductsAnalyticsView.as_view(), name="products"),
    path(
        "api/analytics/menu-popularity/",
        MenuPopularityView.as_view(),
        name="menu-popularity",
    ),
    path("api/analytics/sales-trend/", SalesTrendView.as_view(), name="sales-trend"),
    path("api/token/", CustomTokenObtainPairView.as_view(), name="token_obtain_pair"),
    path("api/token/refresh/", TokenRefreshView.as_view(), name="token_refresh"),
    path("api/signup/", UserSignupView.as_view(), name="signup"),
    path("api/analytics/", include(analytics_router.urls)),
    # path('api/password_reset/', include('django_rest_passwordreset.urls', namespace='password_reset')),
    path(
        "api/password/reset/",
        PasswordResetRequestView.as_view(),
        name="request-password-reset",
    ),
    path(
        "api/password/confirm/<uidb64>/<token>",
        PasswordResetConfirmView.as_view(),
        name="confirm-password-reset",
    ),
    path("api/scan-table/", ScanTableQRView.as_view(), name="scan-table"),
    path("api/order/", PlaceOrderView.as_view(), name="place-order"),
]


urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
