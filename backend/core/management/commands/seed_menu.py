from django.core.management.base import BaseCommand
from decimal import Decimal

# TODO: Ensure 'core' matches your actual app name
from core.models import Category, MenuItem


class Command(BaseCommand):
    help = "Populates the database with full Berries Menu data"

    def handle(self, *args, **options):
        menu_data = {
            "Starters": [
                {"name": "CHICKEN NUGGETS", "price": 25000, "description": ""},
                {"name": "CHICKEN LOLLIPOP", "price": 25000, "description": ""},
                {
                    "name": "TORTILLA CRISPS AND GUACAMOLE",
                    "price": 20000,
                    "description": "",
                },
                {
                    "name": "PAIR OF SAMOSA",
                    "price": 10000,
                    "description": "(beef/chicken/vegetable)",
                },
            ],
            "Soups": [
                {
                    "name": "MUSHROOM SOUP",
                    "price": 18000,
                    "description": "Prepared to your preference",
                },
                {
                    "name": "CHICKEN CONSOMMÉ",
                    "price": 35000,
                    "description": "Tasty light chicken soup with fresh chicken fillet, served with baked bread rolls.",
                },
                {
                    "name": "TOMATO BISQUE SOUP",
                    "price": 18000,
                    "description": "Creamy thick soup with fresh tomatoes, white paper served with baked rolls",
                },
                {
                    "name": "LOVERS SOUP",
                    "price": 18000,
                    "description": "Ginger and carrots soup prepared with cream, served with baked bread rolls.",
                },
            ],
            "Salads": [
                {
                    "name": "CLASSIC CAESAR SALAD",
                    "price": 30000,
                    "description": "Lettuce with grilled chicken flakes, Parmesan, croutons, and olives with Caesar dressing.",
                },
                {
                    "name": "TRADITIONAL GREEK SALAD",
                    "price": 35000,
                    "description": "Tomato, cucumber, bell peppers, onions, olives, and feta mixed with arugula.",
                },
                {
                    "name": "COBB SALAD",
                    "price": 38000,
                    "description": "Eggs, beef sausages, avocado, cherry tomatoes, chicken, sweet corn, lettuce, and feta.",
                },
                {
                    "name": "STEAK SALAD",
                    "price": 38000,
                    "description": "Grilled beef steak strips tossed in vegetables and romaine lettuce with parmesan.",
                },
            ],
            "Kids Corner": [
                {"name": "CHIPS AND SAUSAGES", "price": 22000, "description": ""},
                {
                    "name": "FISH GORDON",
                    "price": 22000,
                    "description": "Fresh fish fingers served with French fries and sauce.",
                },
                {
                    "name": "CHICKEN TENDERS AND FRIES",
                    "price": 25000,
                    "description": "Breaded chicken strips with coleslaw and fries.",
                },
                {
                    "name": "KIDS CHICKEN LOLLIPOPS",
                    "price": 25000,
                    "description": "Grilled chicken lollipops in BBQ sauce, served with fries.",
                },
            ],
            "Chicken (Simply Yummy)": [
                {
                    "name": "Double chicken breast",
                    "price": 40000,
                    "description": "Boneless tender chicken fillet grilled with herbs and choice of accompaniment",
                },
                {
                    "name": "BBQ chicken wings",
                    "price": 38000,
                    "description": "Chicken wings tossed in BBQ sauce served with chips",
                },
                {
                    "name": "Whole grilled chicken",
                    "price": 80000,
                    "description": "Sumptuous serving with seasonal vegetables and two accompaniments",
                },
                {
                    "name": "Chef's choice",
                    "price": 30000,
                    "description": "Chef's style tender and tasty chicken served with your choice of accompaniment.",
                },
                {
                    "name": "Chicken Biryani",
                    "price": 40000,
                    "description": "Hot grilled chicken well seasoned prepared in rice biryani",
                },
            ],
            "Pizza": [
                {
                    "name": "Margherita Pizza (SML)",
                    "price": 25000,
                    "description": "Mozzarella and tomato sauce on a freshly baked pan pizza.",
                },
                {
                    "name": "Chicken Pizza (SML)",
                    "price": 25000,
                    "description": "Chicken cubes, mozzarella, and tomato sauce.",
                },
                {
                    "name": "Beef Pizza (SML)",
                    "price": 25000,
                    "description": "Beef mince, onions, green peppers, and mozzarella.",
                },
                {
                    "name": "Seasons Pizza (SML)",
                    "price": 25000,
                    "description": "Beef sausages, mince, chicken, vegetables, and mozzarella.",
                },
            ],
            "Burgers": [
                {
                    "name": "Classic burger",
                    "price": 38000,
                    "description": "Beef and chicken patties with grilled onions, tomatoes, cucumber, and cheese.",
                },
                {
                    "name": "Berries burger",
                    "price": 37000,
                    "description": "Beef/chicken patty with fried eggs, BBQ sauce, romaine lettuce, and cheese.",
                },
                {
                    "name": "Chicken cheeseburger",
                    "price": 35000,
                    "description": "Grilled chicken patty with grilled onions, tomatoes, and cheese.",
                },
                {
                    "name": "Mexican burger",
                    "price": 35000,
                    "description": "Beef/chicken patty tossed in BBQ sauce with onion rings.",
                },
            ],
            "Smoothies": [
                {
                    "name": "SIGNATURE",
                    "price": 18000,
                    "description": "Pineapple, apple & spinach",
                },
                {
                    "name": "BOLD MANGO",
                    "price": 20000,
                    "description": "Mango, banana & spinach",
                },
                {
                    "name": "STRAWBERRY",
                    "price": 20000,
                    "description": "Fresh berries, banana & honey",
                },
                {
                    "name": "DETOX",
                    "price": 16000,
                    "description": "Beetroot, cucumber and spinach",
                },
                {
                    "name": "PINA COLADA",
                    "price": 18000,
                    "description": "Pineapple, banana & honey",
                },
            ],
            "Juice": [
                {
                    "name": "PASSION ROMA",
                    "price": 15000,
                    "description": "Passion, Apple and pineapple",
                },
                {
                    "name": "IMMUNITY BOOST",
                    "price": 15000,
                    "description": "Spinach, Pineapple and Apple",
                },
                {
                    "name": "VITAMIN BOOST DETOX",
                    "price": 20000,
                    "description": "Carrot, Orange and Apple",
                },
                {
                    "name": "BERRIES’ SIGNATURE",
                    "price": 20000,
                    "description": "Blue berries, Pineapple, Apple & Straw berries",
                },
                {
                    "name": "MELON MOMENT",
                    "price": 12000,
                    "description": "Watermelon and carrots",
                },
            ],
        }

        for category_name, items in menu_data.items():
            category, created = Category.objects.get_or_create(name=category_name)
            if created:
                self.stdout.write(
                    self.style.SUCCESS(f"Created category: {category_name}")
                )

            for item in items:
                # Use update_or_create to ensure prices stay synced with your dictionary
                obj, created = MenuItem.objects.update_or_create(
                    name=item["name"],
                    category=category,
                    defaults={
                        "price": Decimal(item["price"]),
                        "description": item["description"],
                        "is_available": True,
                    },
                )

            self.stdout.write(
                self.style.SUCCESS(f"Processed items for: {category_name}")
            )
