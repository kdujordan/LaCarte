from decimal import Decimal

# TODO: Replace 'your_app_name' with the actual name of your Django app
from core.models import Category, MenuItem


def seed_menu():
    # Structured data extracted from Berries Menu.pdf
    MENU_DATA = [
        {
            "category": "Starters",
            "items": [
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
        },
        {
            "category": "Soups",
            "items": [
                {
                    "name": "MUSHROOM SOUP",
                    "price": 18000,
                    "description": "Prepared to your preference",
                },
                {
                    "name": "CHICKEN CONSOMMÉ",
                    "price": 35000,
                    "description": "A tasty light chicken soup with fresh chicken fillet cut into cubes, served with freshly baked bread rolls.",
                },
                {
                    "name": "TOMATO BISQUE SOUP",
                    "price": 18000,
                    "description": "Creamy thick soup with Lacey fresh tomatoes, white paper served with freshly baked rolls",
                },
                {
                    "name": "LOVERS SOUP",
                    "price": 18000,
                    "description": "A tasty ginger and carrots soup prepared and with cream, served with freshly baked bread rolls.",
                },
            ],
        },
        {
            "category": "Salads",
            "items": [
                {
                    "name": "CLASSIC CAESAR SALAD",
                    "price": 30000,
                    "description": "A bed of lettuce with grilled chicken flakes, Parmesan cheese, croutons and black olives, served with Caesar dressing.",
                },
                {
                    "name": "TRADITIONAL GREEK SALAD",
                    "price": 35000,
                    "description": "Red tomato dices, English cucumber, bell peppers, red onions, black olives, feta cheese mixed with arugula.",
                },
                {
                    "name": "COBB SALAD",
                    "price": 38000,
                    "description": "Hard-boiled eggs, beef sausages, avocado, cherry tomatoes, chicken dices, sweet corn, lettuce, feta cheese, served with honey-lime dressing.",
                },
                {
                    "name": "STEAK SALAD",
                    "price": 38000,
                    "description": "Grilled beef steak strips tossed in assorted vegetables and crisp romaine lettuce, topped with parmesan cheese.",
                },
                {
                    "name": "MALE OF CHICKEN",
                    "price": 35000,
                    "description": "A combination of chicken strips with Boiled eggs on a bed of lettuce, tomatoes, cucumber, feta cheese, sweet corns.",
                },
            ],
        },
        {
            "category": "Kids Corner",
            "items": [
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
                    "description": "Marinated grilled chicken lollipops hand-toasted in BBQ sauce, served with fries.",
                },
            ],
        },
        {
            "category": "Chicken",
            "items": [
                {
                    "name": "Double chicken breast",
                    "price": 40000,
                    "description": "Boneless tender chicken fillet grilled to perfection with herbs served with your choice of accompaniment",
                },
                {
                    "name": "BBQ chicken wings",
                    "price": 38000,
                    "description": "Chicken wings tossed in BBQ sauce salad with chips",
                },
                {
                    "name": "Whole grilled chicken",
                    "price": 80000,
                    "description": "A sumptuous serving of chicken, seasonal salted vegetables and served with two choices of your accompaniment",
                },
                {
                    "name": "Chef's choice",
                    "price": 30000,
                    "description": "Chef's style tender and tasty chicken served with your choice of accompaniment.",
                },
            ],
        },
        {
            "category": "Burgers",
            "items": [
                {
                    "name": "Classic burger",
                    "price": 38000,
                    "description": "Two patties beef and chicken perfectly grilled with grilled onions fresh tomatoes, cucumber, mayonnaise, and romaine lettuce topped with cheese.",
                },
                {
                    "name": "Berries burger",
                    "price": 37000,
                    "description": "Beef/chicken patty fried eggs, BBQ sauce, romaine lettuce, and cheese.",
                },
                {
                    "name": "Chicken cheeseburger",
                    "price": 35000,
                    "description": "Perfectly grilled chicken patty with grilled onions, French tomatoes, a thousand dressing, romaine lettuce and cheese.",
                },
                {
                    "name": "Beef burger",
                    "price": 35000,
                    "description": "Superbly grilled beef patty with onions, fresh tomatoes, a thousand dressing, romaine lettuce and cheese.",
                },
                {
                    "name": "Mexican burger",
                    "price": 35000,
                    "description": "Beef/chicken patty tossed in BBQ sauce, lettuce, spread BBQ, fresh tomatoes slices and onion rings",
                },
            ],
        },
        {
            "category": "Smoothies",
            "items": [
                {
                    "name": "SIGNATURE (Pineapple, apple & spinach)",
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
        },
    ]

    print("Starting menu seeding process...")

    for i, category_data in enumerate(MENU_DATA):
        # Create or get the Category
        category_name = category_data["category"]
        category, created = Category.objects.get_or_create(
            name=category_name, defaults={"display_order": i, "is_active": True}
        )

        if created:
            print(f"Created category: {category.name}")

        # Add Menu Items to the Category
        for item_data in category_data["items"]:
            menu_item, item_created = MenuItem.objects.get_or_create(
                name=item_data["name"],
                category=category,
                defaults={
                    "price": Decimal(item_data["price"]),
                    "description": item_data["description"],
                    "is_available": True,
                },
            )

            # If the item already existed, update its price and description
            if not item_created:
                menu_item.price = Decimal(item_data["price"])
                menu_item.description = item_data["description"]
                menu_item.save()

            print(f"  - Added/Updated: {menu_item.name} (UGX {menu_item.price})")

    print("\nDatabase successfully populated with menu items!")


if __name__ == "__main__":
    seed_menu()
