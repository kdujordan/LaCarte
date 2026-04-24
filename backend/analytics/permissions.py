from rest_framework import permissions
from django.contrib.auth import get_user_model

User = get_user_model()

class IsHeadOfOperationsOrAdmin(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user.is_authenticated and request.user.role in [User.Role.HEAD_OF_OPERATIONS, User.Role.ADMIN]

class IsOrderManager(permissions.BasePermission):
    def has_permission(self, request, view):
        #Order manager can view all analytics
        #Head of operations can view all analytics
        #Admin can view all analytics
        return request.user.is_authenticated and request.user.role in [User.Role.ORDER_MANAGER, User.Role.ADMIN, User.Role.HEAD_OF_OPERATIONS]

