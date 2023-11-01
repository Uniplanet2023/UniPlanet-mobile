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
    console.log(
      "\x1b[32m----------------- Auth API : Sign Up User API Triggerd -----------------\x1b[0m"
    );
    const { name, email, password, profileImage, school, verified } = req.body;
    console.log("1. Finding Existing User");
    const existingUser = await User.findOne({ email });

    if (existingUser) {
      console.log("2. User Exists!");
      return res
        .status(400)
        .json({ msg: "User with same email already exists!" });
    }
    console.log("2. Generate Hash Password");
    const hashedPassword = await bcryptjs.hash(password, 8);
    console.log("3. Creating User Model");
    let user = new User({
      email,
      password: hashedPassword,
      name,
      profileImage,
      school,
      verified,
      unseenNotifications: [],
      unseenMessages: [],
      like: [],
      selling: [],
      sold: [],
      bought: [],
      chatRooms: [],
    });
    console.log("4. Save User into DB");
    user = await user.save();
    res.json(user);
    console.log(
      "\x1b[32m----------------- Auth API : Sign Up is Successfully completed -----------------\x1b[0m"
    );
  } catch (e) {
    console.error(
      "\x1b[31m----------------- Auth API : Issue is occuered at Sign Up API -----------------\x1b[0m"
    );
    console.log(e);
    res.status(500).json({ error: e.message });
  }
});
authRouter.post("api/delet-user", auth, async (req, res) => {
  try {
    console.log(
      "\x1b[32m----------------- Auth API : Delete User API Triggerd -----------------\x1b[0m"
    );
    console.log("1. Find User and Delete is triggered");
    await User.findByIdAndDelete(req.user);
    console.log("2. Account Successfully Deleted");
    res.status(200).json("Account Successfully Deleted");
    console.log(
      "\x1b[32m----------------- Auth API : Delete User API is Successfully completed -----------------\x1b[0m"
    );
  } catch (e) {
    console.error(
      "\x1b[31m----------------- Auth API : Issue is occuered at Delete User API -----------------\x1b[0m"
    );
    console.log(e);
    res.status(500).json({ error: e.message });
  }
});
authRouter.post("api/password-update", async (req, res) => {
  try {
    console.log(
      "\x1b[32m----------------- Auth API : Password Update API Triggerd -----------------\x1b[0m"
    );
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
      console.log(
        "\x1b[32m----------------- Auth API : Password Update API is Successfully completed -----------------\x1b[0m"
      );
    }
  } catch (e) {
    console.error(
      "\x1b[31m----------------- Auth API : Issue is occuered at Sign In API -----------------\x1b[0m"
    );
    console.log(e);
    res.status(500).json({ error: e.message });
  }
});
// Sign In Route
// Exercise
authRouter.post("/api/signin", async (req, res) => {
  try {
    console.log(
      "\x1b[32m----------------- Auth API : Sign In API triggerd -----------------\x1b[0m"
    );

    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(400)
        .json({ msg: "User with this email does not exist!" });
    }

    const isMatch = await bcryptjs.compare(password, user.password);

    if (!isMatch) {
      console.log("1. Incorrect Password");
      return res.status(400).json({ msg: "Incorrect password." });
    }
    console.log("1. Correct Password");
    const token = jwt.sign({ id: user._id }, "passwordKey");
    console.log("2. Store User Data into Redis");
    redis_controller.set(user._id, user);

    res.json({ token, ...user._doc });
    console.log(
      "\x1b[32m----------------- Auth API : Sign In API is Successfully completed -----------------\x1b[0m"
    );
    console.log("");
  } catch (e) {
    console.error(
      "\x1b[31m----------------- Auth API : Issue is occuered at Sign In API -----------------\x1b[0m"
    );
    console.log(e);
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    console.log(
      "\x1b[32m----------------- Auth API : Tocken valid API triggerd -----------------\x1b[0m"
    );
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    console.log("1. Tocken is Existed");
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);
    console.log("2. Tocken is Valid");

    console.log("3. Serach Tocket from database");
    const user = await User.findById(verified.id);

    if (!user) return res.json(false);
    console.log("4. User is Existed");

    res.json(true);
    console.log(
      "\x1b[32m----------------- Auth API : Tocken valid API is Successfully completed -----------------\x1b[0m"
    );
    console.log("");
  } catch (e) {
    console.error(
      "\x1b[31m----------------- Auth API : Issue is occuered at Tocken valid API -----------------\x1b[0m"
    );
    console.log(e);
    res.status(500).json({ error: e.message });
  }
});

module.exports = authRouter;
