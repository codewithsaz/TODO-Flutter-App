const Sequelize = require("sequelize");

const sequelize = require("../util/database");

const Todos = sequelize.define("todos", {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    allowNull: false,
    primaryKey: true,
  },
  title: {
    type: Sequelize.STRING,
    allowNull: false,
  },
  task: {
    type: Sequelize.STRING,
    allowNull: false,
  },
  date: {
    type: Sequelize.STRING,
    allowNull: false,
  },
  completed: {
    type: Sequelize.INTEGER,
    allowNull: false,
  },
});

module.exports = Todos;
