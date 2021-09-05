const express = require("express");
const projectController = require("./../controllers/projectController");
const authController = require("./../controllers/authController");
const router = express.Router();

router.post(
  "/create-project",
  authController.protect,
  projectController.createProject
);

router.get("/p/:id", authController.protect, projectController.getProject);

router.patch(
  "/p/u/:id",
  authController.protect,
  projectController.updateProject
);
router.get(
  "/list-of-projects",
  authController.protect,
  projectController.getAllProjects
);

module.exports = router;
