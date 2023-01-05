const express = require("express");
const productRouter = express.Router();
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");
const Category = require("../models/category")
const seller = require("../middlewares/seller")

productRouter.get("/api/products/", auth, async (req, res) => {
  try {
    const products = await Product.find({ category: req.query.category });
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

productRouter.get("/api/categories/", auth, async (req, res) => {
  try {
    const categories = await Category.find({});
    res.json(categories);
  } catch (error) {
    res.status(500).json({ error: e.message });
  }
});
// create a get request to search products and get them
// /api/products/search/i
productRouter.get("/api/products/search/:name", auth, async (req, res) => {
  try {
    const products = await Product.find({
      name: { $regex: req.params.name, $options: "i" },
    });

    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
productRouter.post("/seller/add-product", seller, async (req, res) => {
  try {
    const { title, owner, description,image, images, colors,quantity, price,  category } = req.body;
    let product = new Product({
      title, owner, description,image, images, colors,quantity, price,  category
    });
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
productRouter.post("/seller/update-product", seller, async (req, res) => {
  try {
    const { id ,title, owner, description,image, images, colors,quantity, price,  category } = req.body;
    await Product.findByIdAndUpdate({id}, {$set: {title, owner, description,image, images, colors,quantity, price,  category}}, (err, product) => {
      res.json(product);
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
productRouter.post("/seller/delete-product", seller, async (req, res) => {
  try {
    const { id , ownerId, userId} = req.body;
    if(ownerId == userId) {
      let product = await Product.findByIdAndDelete(id);
      res.json(product);
    } else {
      res.status(400).json({ error: 'you are not allowed to dleete this product' });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
// create a post request route to rate the product.
productRouter.post("/api/rate-product", auth, async (req, res) => {
  try {
    const { id, rating } = req.body;
    let product = await Product.findById(id);

    for (let i = 0; i < product.ratings.length; i++) {
      if (product.ratings[i].userId == req.user) {
        product.ratings.splice(i, 1);
        break;
      }
    }

    const ratingSchema = {
      userId: req.user,
      rating,
    };

    product.ratings.push(ratingSchema);
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

productRouter.get("/api/deal-of-day", auth, async (req, res) => {
  try {
    let products = await Product.find({});

    products = products.sort((a, b) => {
      let aSum = 0;
      let bSum = 0;

      for (let i = 0; i < a.ratings.length; i++) {
        aSum += a.ratings[i].rating;
      }

      for (let i = 0; i < b.ratings.length; i++) {
        bSum += b.ratings[i].rating;
      }
      return aSum < bSum ? 1 : -1;
    });

    res.json(products[0]);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = productRouter;
