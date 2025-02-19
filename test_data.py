import psycopg2
from faker import Faker
from datetime import datetime, timedelta
import random
from decimal import Decimal

fake = Faker()

# Database connection parameters
DB_PARAMS = {
    "dbname": "test",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": "5432",
}


def format_phone():
    """Generate a consistently formatted phone number"""
    return f"+1-{random.randint(100,999)}-{random.randint(100,999)}-{random.randint(1000,9999)}"


def connect_to_db():
    return psycopg2.connect(**DB_PARAMS)


def create_test_data():
    conn = connect_to_db()
    cur = conn.cursor()

    try:
        # Create PaymentMethods first
        payment_methods = ["Credit Card", "Cash", "Bank Transfer", "Magic Coins"]
        payment_method_ids = []
        for method in payment_methods:
            cur.execute(
                'INSERT INTO "PaymentMethod" (method) VALUES (%s) RETURNING id',
                (method,),
            )
            payment_method_ids.append(cur.fetchone()[0])

        # Create OrderStatus
        order_statuses = ["Pending", "Processing", "Shipped", "Delivered", "Cancelled"]
        order_status_ids = []
        for status in order_statuses:
            cur.execute(
                'INSERT INTO "OrderStatus" (status) VALUES (%s) RETURNING id', (status,)
            )
            order_status_ids.append(cur.fetchone()[0])

        # Create PaymentStatus
        payment_statuses = ["Pending", "Completed", "Failed", "Refunded"]
        payment_status_ids = []
        for status in payment_statuses:
            cur.execute(
                'INSERT INTO "PaymentStatus" (status) VALUES (%s) RETURNING id',
                (status,),
            )
            payment_status_ids.append(cur.fetchone()[0])

        # Create MagicalProperties and store their IDs
        magical_properties = [
            ("Flying", "Grants the ability to fly"),
            ("Invisibility", "Makes the consumer invisible"),
            ("Super Strength", "Temporarily increases strength"),
            ("Healing", "Accelerates natural healing"),
            ("Time Freeze", "Briefly stops time"),
        ]

        magical_property_ids = []
        for name, desc in magical_properties:
            cur.execute(
                'INSERT INTO "MagicalProperty" (name, description) VALUES (%s, %s) RETURNING id',
                (name, desc),
            )
            magical_property_ids.append(cur.fetchone()[0])

        print(
            f"Created magical properties with IDs: {magical_property_ids}"
        )  # Debug print

        # Create OrderTypes - only customer and supplier
        order_types = ["Customer", "Supplier"]
        order_type_ids = {}
        for type_name in order_types:
            cur.execute(
                'INSERT INTO "OrderType" (type) VALUES (%s) RETURNING id', (type_name,)
            )
            order_type_ids[type_name] = cur.fetchone()[0]

        # Create Roles with IDs tracking
        roles = ["Admin", "Customer", "Driver"]
        role_ids = {}
        for role in roles:
            cur.execute('INSERT INTO "Roles" (role) VALUES (%s) RETURNING id', (role,))
            role_ids[role] = cur.fetchone()[0]

        # Create ContactInformation
        contact_ids = []
        for _ in range(50):
            cur.execute(
                """INSERT INTO "ContactInformation" (phone, email, address) 
                VALUES (%s, %s, %s) RETURNING id""",
                (format_phone(), fake.email()[:255], fake.address()[:255]),
            )
            contact_ids.append(cur.fetchone()[0])

        # Create Users with specific roles
        admin_ids = []
        customer_ids = []
        driver_ids = []

        # Create 5 admins
        for contact_id in contact_ids[:5]:
            cur.execute(
                """INSERT INTO "Users" (first_name, last_name, username, hashed_password, contact_id) 
                VALUES (%s, %s, %s, %s, %s) RETURNING id""",
                (
                    fake.first_name()[:100],
                    fake.last_name()[:100],
                    fake.user_name()[:100],
                    fake.sha256(),
                    contact_id,
                ),
            )
            user_id = cur.fetchone()[0]
            admin_ids.append(user_id)
            cur.execute(
                """INSERT INTO "UserRole" (user_id, role_id) VALUES (%s, %s)""",
                (user_id, role_ids["Admin"]),
            )

        # Create 30 customers
        for contact_id in contact_ids[5:35]:
            cur.execute(
                """INSERT INTO "Users" (first_name, last_name, username, hashed_password, contact_id) 
                VALUES (%s, %s, %s, %s, %s) RETURNING id""",
                (
                    fake.first_name()[:100],
                    fake.last_name()[:100],
                    fake.user_name()[:100],
                    fake.sha256(),
                    contact_id,
                ),
            )
            user_id = cur.fetchone()[0]
            customer_ids.append(user_id)
            cur.execute(
                """INSERT INTO "UserRole" (user_id, role_id) VALUES (%s, %s)""",
                (user_id, role_ids["Customer"]),
            )

        # Create 5 drivers
        for contact_id in contact_ids[35:40]:
            cur.execute(
                """INSERT INTO "Users" (first_name, last_name, username, hashed_password, contact_id) 
                VALUES (%s, %s, %s, %s, %s) RETURNING id""",
                (
                    fake.first_name()[:100],
                    fake.last_name()[:100],
                    fake.user_name()[:100],
                    fake.sha256(),
                    contact_id,
                ),
            )
            user_id = cur.fetchone()[0]
            driver_ids.append(user_id)
            cur.execute(
                """INSERT INTO "UserRole" (user_id, role_id) VALUES (%s, %s)""",
                (user_id, role_ids["Driver"]),
            )

        # Create Suppliers
        supplier_ids = []
        for contact_id in contact_ids[40:]:
            cur.execute(
                """INSERT INTO "Supplier" (name, contact_id) 
                VALUES (%s, %s) RETURNING id""",
                (fake.company()[:255], contact_id),
            )
            supplier_ids.append(cur.fetchone()[0])

        # Create Beans
        bean_names = [
            "Golden Leaper",
            "Midnight Shadow",
            "Rainbow Cloud",
            "Thunder Strike",
            "Whisper Wing",
            "Dragon's Breath",
            "Unicorn Pearl",
            "Phoenix Flame",
            "Mermaid Tear",
        ]

        bean_ids = []
        for name in bean_names:
            magical_property_id = random.choice(magical_property_ids)
            print(
                f"Using magical property ID: {magical_property_id} for bean {name}"
            )  # Debug print
            cur.execute(
                """INSERT INTO "Bean" (name, description, price, magical_property) 
                VALUES (%s, %s, %s, %s) RETURNING id""",
                (
                    name[:255],
                    fake.text(max_nb_chars=200),
                    Decimal(str(random.uniform(10.0, 1000.0))).quantize(
                        Decimal("0.01")
                    ),
                    magical_property_id,
                ),
            )
            bean_id = cur.fetchone()[0]
            bean_ids.append(bean_id)

            # Create inventory for each bean
            cur.execute(
                """INSERT INTO "Inventory" (bean_id, quantity) 
                VALUES (%s, %s)""",
                (bean_id, random.randint(0, 1000)),
            )

        # Create supplier orders
        for _ in range(10):
            order_date = fake.date_between(start_date="-1y", end_date="today")
            total_price = Decimal(str(random.uniform(1000.0, 10000.0))).quantize(
                Decimal("0.01")
            )

            cur.execute(
                """INSERT INTO "Orders" (user_id, order_date, total_price, 
                payment_method_id, order_status_id, order_type_id, supplier_id)
                VALUES (%s, %s, %s, %s, %s, %s, %s) RETURNING id""",
                (
                    random.choice(admin_ids),
                    order_date,
                    total_price,
                    random.choice(payment_method_ids),
                    random.choice(order_status_ids),
                    order_type_ids["Supplier"],
                    random.choice(supplier_ids),
                ),
            )

            order_id = cur.fetchone()[0]

            # Create order items
            for _ in range(random.randint(3, 8)):
                item_price = Decimal(str(random.uniform(100.0, 1000.0))).quantize(
                    Decimal("0.01")
                )
                cur.execute(
                    """INSERT INTO "OrderItem" (order_id, bean_id, quantity, price)
                    VALUES (%s, %s, %s, %s)""",
                    (
                        order_id,
                        random.choice(bean_ids),
                        random.randint(10, 100),
                        item_price,
                    ),
                )

        # Create customer orders
        for _ in range(20):
            order_date = fake.date_between(start_date="-1y", end_date="today")
            total_price = Decimal(str(random.uniform(50.0, 500.0))).quantize(
                Decimal("0.01")
            )

            cur.execute(
                """INSERT INTO "Orders" (user_id, order_date, total_price, 
                payment_method_id, order_status_id, order_type_id, supplier_id)
                VALUES (%s, %s, %s, %s, %s, %s, %s) RETURNING id""",
                (
                    random.choice(customer_ids),
                    order_date,
                    total_price,
                    random.choice(payment_method_ids),
                    random.choice(order_status_ids),
                    order_type_ids["Customer"],
                    None,
                ),
            )

            order_id = cur.fetchone()[0]

            # Create order items
            for _ in range(random.randint(1, 3)):
                item_price = Decimal(str(random.uniform(10.0, 100.0))).quantize(
                    Decimal("0.01")
                )
                cur.execute(
                    """INSERT INTO "OrderItem" (order_id, bean_id, quantity, price)
                    VALUES (%s, %s, %s, %s)""",
                    (
                        order_id,
                        random.choice(bean_ids),
                        random.randint(1, 5),
                        item_price,
                    ),
                )

            # Create order history
            cur.execute(
                """INSERT INTO "OrderHistory" (order_id, order_status_id)
                VALUES (%s, %s)""",
                (order_id, random.choice(order_status_ids)),
            )

            # Create payment
            cur.execute(
                """INSERT INTO "Payment" (order_id, amount, status_id)
                VALUES (%s, %s, %s)""",
                (order_id, total_price, random.choice(payment_status_ids)),
            )

            # Create delivery for completed customer orders
            if random.random() < 0.7:  # 70% chance of having delivery
                cur.execute(
                    """INSERT INTO "Delivery" (order_id, driver_id, delivery_notes)
                    VALUES (%s, %s, %s)""",
                    (order_id, random.choice(driver_ids), fake.text(max_nb_chars=100)),
                )

        conn.commit()
        print("Test data created successfully!")

    except Exception as e:
        conn.rollback()
        print(f"Error creating test data: {e}")
        raise  # Re-raise the exception to see the full error trace

    finally:
        cur.close()
        conn.close()


if __name__ == "__main__":
    create_test_data()
