from rest_framework import authentication
from rest_framework.exceptions import AuthenticationFailed
from .models import OrderSession
import jwt
from django.conf import settings

class GuestSessionAuthentication(authentication.BaseAuthentication):

    def authenticate(self, request):
        auth_header = request.headers.get('Authorization')
        if not auth_header or not auth_header.startswith('Bearer'):
            return None
        
        token = auth_header.split(' ')[1]
        
        # Check if this is a guest token before trying to verify
        try:
            unverified_payload = jwt.decode(token, options={"verify_signature": False})
            if 'session_id' not in unverified_payload:
                return None
        except Exception:
            return None

        try:
            payload = jwt.decode(token, settings.SECRET_KEY, algorithms=['HS256'])
            
            session = OrderSession.objects.get(session_id=payload['session_id'], is_active=True)

            return (None, session)

        except OrderSession.DoesNotExist:
            raise AuthenticationFailed("Invalid Session or Session Expired")
            
        except jwt.ExpiredSignatureError:
            raise AuthenticationFailed("Token Expired. Please rescan the QR Code.")
            
        except jwt.InvalidTokenError:
            raise AuthenticationFailed("Invalid Token")
        
        


            
    