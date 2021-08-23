const jwt = require('jsonwebtoken');
const User = require('./../models/userModel');

const checkActivationToken = (role, token) => {
  if (role === 'admin' && process.env.ACTIVATION_TOKENS.includes(token)) {
    return token;
  } else if (role === 'admin' && token === undefined) {
    throw new Error('Please provide the activation token');
  } else if (
    role === 'admin' &&
    !process.env.ACTIVATION_TOKENS.includes(token)
  ) {
    throw new Error('Please provide the valid activation token');
  } else {
    return undefined;
  }
};

exports.signup = async (req, res) => {
  try {
    const newUser = await User.create({
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
    });

    console.log(req.body.activation_token);

    // const newUser = await User.create(req.body);

    const token = jwt.sign({ id: newUser._id }, process.env.JWT_SECRET_KEY, {
      expiresIn: process.env.JWT_EXPIRES_IN,
    });

    res.status(200).json({
      status: 'true',
      token,
      message: 'User successfully created',
      content: {
        newUser,
      },
    });
  } catch (error) {
    res.status(404).json({
      status: 'false',
      message: error.message,
    });
  }
};
