const Project = require("../models/projectModel");
const Admin = require("./../models/adminModel");

exports.createProject = async (req, res) => {
  try {
    const admin = await Admin.findOne({ username: req.body.owner });
    if (!admin) {
      res.status(400).json({
        status: 0,
        message: "No such username exists",
      });
    } else {
      const project = await Project.create({
        name: req.body.name,
        description: req.body.description,
        githubLink: req.body.githubLink,
        driveLink: req.body.driveLink,
        documentLink: req.body.documentLink,
        owner: admin._id,
      });

      await Admin.updateOne(
        {
          _id: admin._id,
        },
        {
          $push: { projects: project._id },
        }
      );

      res.status(200).json({
        status: 1,
        token: project._id,
      });
    }
  } catch (err) {
    res.status(400).json({
      status: 0,
      message: err.message,
    });
  }
};

exports.getProject = async (req, res) => {
  try {
    const project = await Project.findById(req.params.id);
    res.status(200).json({
      status: 1,
      project,
    });
  } catch (err) {
    res.status(400).json({
      status: 0,
      message: err.message,
    });
  }
};

exports.updateProject = async (req, res) => {
  try {
    if (req.body.owner) {
      res.status(400).json({
        status: 0,
        message: "You cannot change the owner of project",
      });
    } /*else {
      const curr = await Admin.findOne({ username: req.body.owner });
      const updatedProject = await Project.findByIdAndUpdate(
        curr._id,
        req.body,
        {
          new: true,
          runvalidators: true,
        }
      );
      res.status(200).json({
        status: 1,
        updatedProject,
      });
    }*/
  } catch (err) {
    res.status(400).json({
      status: 0,
      message: err.message,
    });
  }
};
