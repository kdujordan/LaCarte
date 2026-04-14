from rest_framework import serializers
from .models import DailySalesAnalytics, ProductsAnalytics, MenuPopularity


class DailySalesAnalyticsSerializer(serializers.ModelSerializer):
    class Meta:
        model = DailySalesAnalytics
        fields = '__all__'


class ProductsAnalyticsSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductsAnalytics
        fields = '__all__'


class MenuPopularitySerializer(serializers.ModelSerializer):
    menu_item = serializers.CharField(source='menu_item.name', read_only=True)
    class Meta:
        model = MenuPopularity
        fields = '__all__'