const mongoose = require("mongoose");

const note = mongoose.model(
    "notes", //table name / model name
    mongoose.Schema({
            id: String,
            title: String,
            description: String, 
            date: Date,
            emotion: Number
    }, {
        timestamps: true,
    })
);

module.exports = {
    note
}