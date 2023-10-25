const express = require("express");
const User = require("../models/user");
const bcryptjs = require("bcryptjs");
const authRouter = express.Router();
const jwt = require("jsonwebtoken");
const auth = require("../middlewares/auth");
const redis_controller = require("../redis_controller/redis_controller");
// SIGN UP
authRouter.post("/api/signup", async (req, res) => {
  try {
    console.log("Sign-Up API triggerd");

    const { name, email, password } = req.body;

    const existingUser = await User.findOne({ email });

    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists!" });
    }
    const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
      email,
      password: hashedPassword,
      name,
    });

    user = await user.save();
    res.json(user);
  } catch (e) {
    console.log(e);
    res.status(500).json({ error: e.message });
  }
});
authRouter.post("api/delet-user", auth, async (req, res) => {
  try {
    console.log("user.delete API is called");
    await User.findByIdAndDelete(req.user);
    res.status(200).json("Account Successfully Deleted");
  } catch (e) {
    console.log(e);
    res.status(500).json({ error: e.message });
  }
});
authRouter.post("api/password-update", async (req, res) => {
  let hashedPassword;
  try {
    console.log("password update api is triggered");
    if (req.body.password) {
      hashedPassword = await bcryptjs.hash(
        req.body.password,
        process.env.SECRET_PASS_KEY
      );
      const updateUser = await User.findByIdAndUpdate(
        req.body.id,
        {
          $password: req.body.password,
        },
        { new: true }
      );
      res.status(200).json(updateUser);
    }
  } catch (e) {
    console.log(e);
    res.status(500).json({ error: e.message });
  }
});
// Sign In Route
// Exercise
authRouter.post("/api/signin", async (req, res) => {
  try {
    console.log("Sign-in API triggerd");

    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(400)
        .json({ msg: "User with this email does not exist!" });
    }

    const isMatch = await bcryptjs.compare(password, user.password);

    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect password." });
    }

    const token = jwt.sign({ id: user._id }, "passwordKey");

    redis_controller.set(user._id, user);

    res.json({ token, ...user._doc });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    console.log("tocken valid API triggerd");
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);
    console.log("serach from database1");
    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = authRouter;
