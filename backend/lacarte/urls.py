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
from analytics.views import DailySalesAnalyticsView, ProductsAnalyticsView, MenuPopularityView, SalesTrendView

router = DefaultRouter()
router.register(r'menu-items', MenuItemViewSet)
router.register(r'order-sessions', OrderSessionViewSet)
router.register(r'orders', OrderViewSet)
router.register(r'staff-notifications', StaffNotificationViewSet)
router.register(r'feedback', FeedbackViewSet)
router.register(r'tables', TableViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include(router.urls)),
    path('api/analytics/daily-sales/', DailySalesAnalyticsView.as_view(), name='daily-sales'),
    path('api/analytics/products/', ProductsAnalyticsView.as_view(), name='products'),
    path('api/analytics/menu-popularity/', MenuPopularityView.as_view(), name='menu-popularity'),
    path('api/analytics/sales-trend/', SalesTrendView.as_view(), name='sales-trend'),
]
