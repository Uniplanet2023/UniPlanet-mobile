
const express = require('express');
const { default: mongoose } = require('mongoose');
const authRouter = require("./routes/auth");
const app = express(); // initialize
const PORT = process.env.PORT || 3000;
const DB = "mongodb+srv://uniplanet:0YKw3suZ90dPpnmr@test.7oivqp4.mongodb.net/?retryWrites=true&w=majority";
//Create An API
// http:// <youripaddress>/hello-world
app.get('/hello-world', (req, res) => {
    res.send({});
});

app.use(express.json());
app.use(authRouter);


//GET , PUT, POST, DELETE, UPDATE -> CRUD
mongoose.connect(DB).then(()=>{
    console.log("Mongoose Connection Successful");
}).catch((e)=>{
    console.log(e);
})

app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port ${PORT}`);
});
//localhost

