const { promisify } = require("util");
const jwt = require("jsonwebtoken");
const Admin = require("./../models/adminModel");
const bcrypt = require("bcryptjs");

const signToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET_KEY, {
    expiresIn: process.env.JWT_EXPIRES_IN,
  });
};

const checkActivationToken = (role, token) => {
  if (role === "admin" && process.env.ACTIVATION_TOKENS.includes(token)) {
    return token;
  } else if (role === "admin" && token === undefined) {
    throw new Error("Please provide the activation token");
  } else if (
    role === "admin" &&
    !process.env.ACTIVATION_TOKENS.includes(token)
  ) {
    throw new Error("Please provide the valid activation token");
  } else {
    return undefined;
  }
};

exports.signup = async (req, res) => {
  try {
    const newUser = await Admin.create({
      name: req.body.name,
      username: req.body.username,
      email: req.body.email,
      password: req.body.password,
      passwordConfirm: req.body.passwordConfirm,
      role: req.body.role,
      activation_token: checkActivationToken(
        req.body.role,
        req.body.activation_token
      ),
      phoneNumber: req.body.phoneNumber,
      companyName: req.body.companyName,
      companyEmail: req.body.companyEmail,
      companyNumber: req.body.companyNumber,
      companyDescription: req.body.companyDescription,
      address: req.body.address,
    });

    console.log(req.body.activation_token);

    // const newUser = await User.create(req.body);

    const token = signToken(newUser._id);

    res.status(200).json({
      status: "true",
      token,
      message: "User successfully created",
      content: {
        newUser,
      },
    });
  } catch (error) {
    res.status(404).json({
      status: "false",
      message: error.message,
    });
  }
};

exports.login = async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      res.status(400).json({
        status: "false",
        message: "Please enter username and password",
      });
    }

    const user = await Admin.findOne({ username });

    if (!user || !(await bcrypt.compare(password, user.password))) {
      res.status(401).json({
        status: "false",
        message: "Invalid Credentials",
      });
    } else {
      const token = signToken(user._id);
      res.status(200).json({
        status: "true",
        token,
      });
    }
  } catch (err) {
    res.status(401).json({
      status: "false",
      message: err.message,
    });
  }
};

//check if the user is logged in or not
exports.protect = async (req, res, next) => {
  let token;
  //token exists or not
  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith("Bearer")
  ) {
    token = req.headers.authorization.split(" ")[1];
  }
  if (!token) {
    res.status(401).json({
      status: 0,
      message: "You are not currently logged in",
    });
    return;
  }
  //verify the token
  try {
    const decoded = await promisify(jwt.verify)(
      token,
      process.env.JWT_SECRET_KEY
    );
    console.log(decoded);
    const freshUser = await Admin.findById(decoded.id);
    if (!freshUser) {
      res.status(401).json({
        status: 0,
        message: err.message,
      });
      return;
    }
    // password changed
    req.user = freshUser;
    console.log(req.user);
  } catch (err) {
    res.status(401).json({
      status: 0,
      message: err.message,
    });
    return;
  }
  next();
};
