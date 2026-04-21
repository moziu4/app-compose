// mongosh --authenticationDatabase admin -u "admin" -p "admin_pass"
db = db.getSiblingDB("user"); // Cambia el contexto a "mydb"

db.createUser({
    user: "user",
    pwd: "dev_pass",
    roles: [
        { role: "readWrite", db: "user" }
    ]
}    );

db.createCollection("users");
db.createCollection("auth");
db.createCollection("relationship");

db = db.getSiblingDB("shop");

db.createUser({
    user: "shop",
    pwd: "dev_pass",
    roles: [
        { role: "readWrite", db: "shop" }
    ]
});

db.createCollection("products");


db = db.getSiblingDB("content");

db.createUser({
    user: "content",
    pwd: "dev_pass",
    roles: [
        { role: "readWrite", db: "content" }
    ]
});

db = db.getSiblingDB("tenant");

db.createUser({
    user: "tenant",
    pwd: "dev_pass",
    roles: [
        { role: "readWrite", db: "tenant" }
    ]
});

db.createCollection("tenants");




db = db.getSiblingDB("asset");

db.createUser({
    user: "asset",
    pwd: "dev_pass",
    roles: [
        { role: "readWrite", db: "asset" }
    ]
});

db.createCollection("assets");