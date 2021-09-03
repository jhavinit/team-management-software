const express = require("express");
const app = express();

const userRoutes = require("./routes/userRoutes");
const projectRoutes = require("./routes/projectRoutes");

app.use(express.json());

app.use("/", userRoutes);
app.use("/", projectRoutes);

module.exports = app;
