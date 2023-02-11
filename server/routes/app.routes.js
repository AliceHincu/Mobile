const noteController = require("../controllers/notes.controller");
const express = require("express");
const router = express.Router();

router.post("/notes", noteController.create);
router.get("/notes", noteController.findAll);
router.get("/notes/:id", noteController.findOne);
router.put("/notes/:id", noteController.update);
router.delete("/notes/:id", noteController.delete);

module.exports = router;