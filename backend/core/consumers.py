import json
from channels.generic.websocket import AsyncWebsocketConsumer



class OrderConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        #WE crate a group for the restaurant

        self.group_name = "kitchen_updates"
        await self.channel_layer.group_add(
            self.group_name,
            self.channel_name,
        )
        await self.accept()

    async def disconnect(self, close_code):
        #Leave the group when the connection is closed
        await self.channel_layer.group_discard(
            self.group_name,
            self.channel_name,
        )

    async def order_alert(self,event):
        order_data = event["order"]

        await self.send(text_data=json.dumps({
            "type": "order_alert",
            "data": order_data,
        }))
