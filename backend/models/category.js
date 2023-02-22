const mongoose = require('mongoose');
const categorySchema = mongoose.Schema({
    title: {
        required: true,
        type: String
    },
    image: {
        type: String
    }
})
const Category = mongoose.model("Category", categorySchema)
module.exports = Category