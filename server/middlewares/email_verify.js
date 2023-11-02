const nodemailer = require("nodemailer");
const { google } = require("googleapis");
const { gmail } = require("googleapis/build/src/apis/gmail");
const otpGenerator = require("otp-generator");
const crypto = require("crypto");

require("dotenv").config();

const CLIENT_ID = process.env.CLIENT_ID;
const CLIENT_SECRET = process.env.CLIENT_SECRET;
const REDIRECT_URI = process.env.REDIRECT_URI;
const REFRESH_TOKEN = process.env.REFRESH_TOKEN;
const key = process.env.OTP_KEY;

const oAuth2Client = new google.auth.OAuth2(
  CLIENT_ID,
  CLIENT_SECRET,
  REDIRECT_URI
);
oAuth2Client.setCredentials({ refresh_token: REFRESH_TOKEN });

const send_mail = async (user_email, name) => {
  try {
    const accessToken = await oAuth2Client.getAccessToken();

    let transporter = nodemailer.createTransport({
      host: "smtp.gmail.com",
      port: 465,
      secure: true,
      auth: {
        type: "OAuth2",
        clientId: CLIENT_ID,
        clientSecret: CLIENT_SECRET,
      },
    });

    const otp_to_be_sent = otp_generate(user_email);

    const result = transporter.sendMail({
      from: "UniPlanet ✉️ <uniplanet.info@gmail.com>",
      to: user_email,
      subject: `Hello ${name}, Your UniPlanet Marketplace verification code"`,
      text: `Hi ${name}, Please verify your email address using the following verification code: ${otp_to_be_sent[0]}`,
      auth: {
        user: "uniplanet.info@gmail.com",
        refreshToken: REFRESH_TOKEN,
        accessToken: accessToken,
      },
    });

    console.log(otp_to_be_sent[0]);

    return otp_to_be_sent[1];
  } catch (error) {
    return error;
  }
};

const otp_generate = (email) => {
  const otp = otpGenerator.generate(5, {
    digits: true,
    upperCaseAlphabets: false,
    lowerCaseAlphabets: false,
    specialChars: false,
  });
  const ttl = 5 * 60 * 1000;
  const expires = Date.now() + ttl;
  const data = `${email}.${otp}.${expires}`;
  const hash = crypto.createHmac("sha256", key).update(data).digest("hex");
  const full_hash = `${hash}.${expires}`;

  return [otp, full_hash];
};

const verfy_otp = async (params) => {
  let [otpHash, expires] = params.otpHash.split(".");
  let now = Date.now();

  if (now > parseInt(expires)) {
    return "OTP expired";
  }

  let data = `${params.email}.${params.otpCode}.${expires}`;

  let newCalculatedHash = crypto
    .createHmac("sha256", key)
    .update(data)
    .digest("hex");

  if (otpHash === newCalculatedHash) {
    return "Success";
  }
  return "Invalid Verfication number";
};

module.exports = {
  send_mail,
  verfy_otp,
  otp_generate,
};
