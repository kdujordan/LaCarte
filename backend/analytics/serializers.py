from rest_framework import serializers
from .models import DailySalesAnalytics, ProductsAnalytics, MenuPopularity, User
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.exceptions import AuthenticationFailed

class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    def validate(self, attrs):
        #This checks the username and password first
        data = super().validate(attrs)

        #Now we chaeck if the user has custom authorization flag
        if not self.user.is_approved and self.user.role != User.Role.HEAD_OF_OPERATIONS :
            raise AuthenticationFailed("Your account is pending authorization")
        
        return data
        
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['email','role','is_approved','first_name','last_name']
        read_only_fields = ['is_approved']

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