// mongosh --authenticationDatabase admin -u "admin" -p "admin_pass"
db = db.getSiblingDB("user"); // Cambia el contexto a "mydb"

db.createUser({
    user: "user",
    pwd: "dev_pass",
    roles: [
        {role: "readWrite", db: "user"}
    ]
});

db.createCollection("auth");


db = db.getSiblingDB("ia");

db.createUser({
    user: "ia",
    pwd: "dev_pass",
    roles: [
        {role: "readWrite", db: "ia"}
    ]
});


db = db.getSiblingDB("tenant");

db.createUser({
    user: "tenant",
    pwd: "dev_pass",
    roles: [
        {role: "readWrite", db: "tenant"}
    ]
});


db = db.getSiblingDB("asset");

db.createUser({
    user: "asset",
    pwd: "dev_pass",
    roles: [
        {role: "readWrite", db: "asset"}
    ]
});
