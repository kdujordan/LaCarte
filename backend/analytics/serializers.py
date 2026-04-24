from rest_framework import serializers
from .models import DailySalesAnalytics, ProductsAnalytics, MenuPopularity, User
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.exceptions import AuthenticationFailed

class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    def get_token(self, user):
        token = super().get_token(user)

        # Add custom claims to the token
        token['role'] = user.role
        token['is_approved'] = user.is_approved
        token['email'] = user.email

        
        return token
    
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

class UserSignupSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    
    class Meta:
        model = User
        fields = ['email','first_name','last_name','password','role']
        write_only_fields = ['password']
        
    def create(self, validated_data):
        #Create user but keep them unapproved
        user = User.objects.create_user(**validated_data)
        return user

    def validate_role(self, value):
        if value == User.Role.HEAD_OF_OPERATIONS:
            raise serializers.ValidationError("Head of Operations cannot be created by users")
        return value
        