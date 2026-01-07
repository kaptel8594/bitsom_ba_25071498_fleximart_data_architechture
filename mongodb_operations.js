// mongodb_operations.js
import MongoClient from "mongodb";
mongodb.mongodb-vscode;
import mongodb from "mongodb";


const { MongoClient } = require("mongodb");
const fs = require("fs");

const uri = "mongodb://localhost:27017";
const client = new MongoClient(uri);

async function Operation() {
  try {
    await client.connect();

    const db = client.db("fleximart");
    const products = db.collection("products");
    // Operation 1: Load Data into MongoDB
    // Read JSON file
    const data = JSON.parse(
      fs.readFileSync("products_catalog.json", "utf-8")
    );
    
    // Insert data into products collection
    await products.insertMany(data);

    console.log("Products data successfully loaded into MongoDB");

// Operation 2: Find all products in "Electronics" category with price less than 50000
// Return only: name, price, stock

    const electronicsProducts = await products.find(
      {
        category: "Electronics",
        price: { $lt: 50000 }
      },
      {
        projection: { _id: 0, name: 1, price: 1, stock: 1 }
      }
    ).toArray();

    console.log("Electronics products with price < 50000:");
    console.log(electronicsProducts);

// Operation 3:  Find all products that have average rating >= 4.0
// Use aggregation to calculate average from reviews array
    const highlyRatedProducts = await products.aggregate([
        {
            $unwind: "$reviews"
        },
        {
            $group: {
                _id: "$_id",
                name: { $first: "$name" },
                price: { $first: "$price" },
                stock: { $first: "$stock" },
                avgRating: { $avg: "$reviews.rating" }
            }
        },
        {
            $match: {
                avgRating: { $gte: 4.0 }
            }
        },
        {
            $project: {
                _id: 0,
                name: 1,
                price: 1,
                stock: 1,
                avgRating: 1
            }
        }
    ]).toArray();

    console.log("Products with average rating >= 4.0:");
    console.log(highlyRatedProducts);

// Add a new review to product "ELEC001"
// Review: {user: "U999", rating: 4, comment: "Good value", date: ISODate()}

    const newReview = {
        user: "U999",
        rating: 4,
        comment: "Good value",
        date: new Date()
    };  
    const updateResult = await products.updateOne(
        { product_id: "ELEC001" },
        { $push: { reviews: newReview } }
    );  
    console.log(`Added new review to ELEC001. Modified count: ${updateResult.modifiedCount}`);

// Calculate average price by category
// Return: category, avg_price, product_count
// Sort by avg_price descending
    const avgPriceByCategory = await products.aggregate([
        {
            $group: {       
                _id: "$category",
                avg_price: { $avg: "$price" },
                product_count: { $sum: 1 }
            }
        },
        {
            $project: {
                _id: 0,
                category: "$_id",
                avg_price: 1,
                product_count: 1
            }
        },
        {
            $sort: { avg_price: -1 }
        }
    ]).toArray();
    console.log("Average price by category:");
    console.log(avgPriceByCategory);
    

  } catch (error) {
    console.error(error);
  } finally {
    await client.close();
  }
}

Operation();







