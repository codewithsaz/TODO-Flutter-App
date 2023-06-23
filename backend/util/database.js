const Sequelize = require("sequelize");

const sequelize = new Sequelize("todo", "root", "mysql@cipher", {
  dialect: "mysql",
  host: "localhost",
});

module.exports = sequelize;
