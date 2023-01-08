const mongoose = require("mongoose");
const ratingSchema = require("./rating");

const productSchema = mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true,
  },
  owner: {
    type: mongoose.Types.ObjectId,
    required: true
  },
  description: {
    type: String,
    required: true,
    trim: true,
  },
  image: {type: String},
  images: [
    {
      type: String,
      required: true,
    },
  ],
  colors: [
    {
      colorName: {
        required: true,
        type : String
      },
      color: {
        required: true,
        type : String
      }
    }
  ],
  quantity: {
    type: Number,
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  category: [{
    type: mongoose.Types.ObjectId,
    required: true,
  }],
  ratings: [ratingSchema],
});

const Product = mongoose.model("Product", productSchema);
module.exports = { Product, productSchema };
