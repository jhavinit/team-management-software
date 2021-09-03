const express = require("express");
const projectController = require("./../controllers/projectController");
const router = express.Router();

router.post("/create-project", projectController.createProject);
router.get("/p/:id", projectController.getProject);
router.patch("/update-project", projectController.updateProject);
//router.get("/list-of-projects",projectController.getAllProjects)

module.exports = router;
