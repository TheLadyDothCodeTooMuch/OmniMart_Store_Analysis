import requests
import pandas as pd
from faker import Faker
import random

fake = Faker()


PRODUCT_LOGIC = {
    "electronics": {
        "Smartphones": [
            "iPhone 15 Pro",
            "Galaxy S23 Ultra",
            "Pixel 8 Pro",
            "OnePlus 11",
            "Z Flip 5",
        ],
        "Laptops": [
            "MacBook Air M2",
            "Dell XPS 13",
            "HP Spectre x360",
            "Lenovo ThinkPad",
            "Razer Blade",
        ],
        "Audio": [
            "AirPods Max",
            "Sony WH-1000XM5",
            "Bose QuietComfort",
            "Beats Studio Pro",
            "JBL Flip 6",
        ],
        "Gaming": [
            "PS5 Console",
            "Xbox Series X",
            "Nintendo Switch OLED",
            "Steam Deck",
            "Logitech G Pro Mouse",
        ],
    },
    "jewelery": {
        "Necklaces": [
            "Gold Locket",
            "Diamond Pendant",
            "Silver Chain",
            "Pearl Choker",
            "Cuban Link",
        ],
        "Rings": [
            "Engagement Ring",
            "Wedding Band",
            "Signet Ring",
            "Stackable Gold Ring",
            "Emerald Ring",
        ],
        "Watches": [
            "Rolex Submariner",
            "Omega Seamaster",
            "Apple Watch Series 9",
            "Casio G-Shock",
            "Seiko 5",
        ],
    },
    "men's clothing": {
        "T-Shirts": [
            "Cotton Crewneck",
            "V-Neck Basic",
            "Graphic Tee",
            "Polo Shirt",
            "Oversized Fit",
        ],
        "Outerwear": [
            "Leather Jacket",
            "Denim Jacket",
            "Winter Parka",
            "Puffer Vest",
            "Trench Coat",
        ],
        "Pants": [
            "Slim Fit Chinos",
            "Raw Denim Jeans",
            "Cargo Pants",
            "Sweatpants",
            "Dress Trousers",
        ],
    },
    "women's clothing": {
        "Dresses": [
            "Maxi Dress",
            "Little Black Dress",
            "Floral Sundress",
            "Evening Gown",
            "Cocktail Dress",
        ],
        "Tops": [
            "Silk Blouse",
            "Cashmere Sweater",
            "Crop Top",
            "Linen Shirt",
            "Camisole",
        ],
        "Skirts": [
            "Midi Pencil Skirt",
            "Pleated Mini",
            "Denim Skirt",
            "Floral Maxi Skirt",
            "A-Line Skirt",
        ],
    },
}

DOMAIN_NAME = ["com", "net", "org"]


def main():
    df_total_products = generate_products()
    df_customers = generate_customers()
    df_orders = generate_orders(200000, df_total_products)

    # save_to_csv(df_total_products, df_customers, df_orders)


def generate_products() -> DataFrame :
    response = requests.get("https://fakestoreapi.com/products")
    df_api_products = pd.DataFrame(response.json())
    # Tag API products with a default subcategory so the columns match
    df_api_products["subcategory"] = "General"
    df_api_products['rating'] = df_api_products['rating'].astype(str)

    extra_products = []
    for i in range(21, 101):
        # Pick Category
        category = random.choice(list(PRODUCT_LOGIC.keys()))
        # Pick Subcategory based on Category
        subcategory = random.choice(list(PRODUCT_LOGIC[category].keys()))
        # Pick Name based on Subcategory
        title = random.choice(PRODUCT_LOGIC[category][subcategory])

        extra_products.append(
            {
                "id": i,
                "title": f"{title} {random.randint(100, 999)}",  # Adds a unique model number
                "price": round(random.uniform(15, 600), 2),
                "category": category,
                "subcategory": subcategory,
                "description": fake.sentence(),
                "image": "https://i.pravatar.cc/150",
            }
        )

    df_extra_products = pd.DataFrame(extra_products)
    return pd.concat([df_api_products, df_extra_products], ignore_index=True)


def generate_customers() -> DataFrame :
    customers = []
    for i in range(800):
        name = fake.name()
        email = name.lower().strip().replace(" ", ".")
        customers.append(
            {
                "id": i + 1,
                "name": name,
                "email": f"{email}@example.{random.choice(DOMAIN_NAME)}",
                "date_of_birth": fake.date_of_birth(minimum_age=16, maximum_age=80),
                "city": fake.city(),
                "country": fake.country(),
                "signup_date": fake.date_time_between(start_date="-6y", end_date="now"),
            }
        )
    return pd.DataFrame(customers)


def generate_orders(num_orders: int, df_products: DataFrame) -> DataFrame :
    order_items = []
    product_list = df_products.to_dict("records")
    for _ in range(num_orders):
        order_id, cust_id, date = (
            fake.uuid4(),
            random.randint(1, 800),
            fake.date_this_decade(),
        )
        cart_size = random.randint(1, 10)
        cart = random.sample(product_list, k=cart_size)
        for p in cart:
            qty = random.randint(1, 3)
            order_items.append(
                {
                    "order_id": order_id,
                    "customer_id": cust_id,
                    "order_date": date,
                    "product_id": p["id"],
                    "quantity": qty,
                    "total_amount": round(p["price"] * qty, 2),
                }
            )
    return pd.DataFrame(order_items)


def save_to_csv(df_products, df_customers, df_orders):
    df_products.to_csv("dim_products.csv", index=False)
    df_customers.to_csv("dim_customers.csv", index=False)
    df_orders.to_csv("fact_orders.csv", index=False)

    print("Generation completed. Local files saved.")


if __name__ == "__main__":
    main()
