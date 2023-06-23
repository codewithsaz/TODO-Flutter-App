const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();

const sequelize = require("./util/database");

const todoRoutes = require("./routes/todos");

app.use(cors());

app.use(bodyParser.json({ extended: false }));

app.use(todoRoutes);

// app.use(errorController.get404);

sequelize
  .sync({ force: true })
  // .sync()
  .then((result) => {
    // console.log(result);
    app.listen(8080);
  })
  .catch((err) => {
    console.log(err);
  });
