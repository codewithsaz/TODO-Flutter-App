const express = require("express");

const router = express.Router();

const todoController = require("../controllers/todos");

router.get("/todos-remaining", todoController.getTodosRemaining);

router.get("/todos-completed", todoController.getTodosCompleted);

router.get("/todo/:id", todoController.getTodo);

router.post("/add-todo", todoController.addTodo);

router.put("/update-todo/:id", todoController.updateTodo);

router.delete("/delete-todo/:id", todoController.deleteTodo);

module.exports = router;
