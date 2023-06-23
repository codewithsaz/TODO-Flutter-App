const Todo = require("../models/todos");

exports.addTodo = (req, res, next) => {
  console.log(req.body);
  const title = req.body.title;
  const task = req.body.task;
  const date = req.body.date;
  const completed = req.body.completed;
  Todo.create({
    title: title,
    task: task,
    date: date,
    completed: completed,
  }).catch((err) => {
    console.log(err);
  });
  res.status(200).send("Todo Added");
};

exports.updateTodo = (req, res, next) => {
  const expId = req.params.id;
  const title = req.body.title;
  const task = req.body.task;
  const date = req.body.date;
  const completed = req.body.completed;
  Todo.findByPk(expId)
    .then((todo) => {
      todo.set({
        title: title,
        task: task,
        date: date,
        completed: completed,
      });

      todo.save();
      res.status(200).send("Todo Updated");
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.getTodosRemaining = (req, res, next) => {
  Todo.findAll({
    where: {
      completed: 0,
    },
  })
    .then((todos) => {
      res.status(200).json(todos);
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.getTodosCompleted = (req, res, next) => {
  Todo.findAll({
    where: {
      completed: 1,
    },
  })
    .then((todos) => {
      res.status(200).json(todos);
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.getTodo = (req, res, next) => {
  const expId = req.params.id;
  Todo.findByPk(expId)
    .then((todo) => {
      res.status(200).json(todo);
    })
    .catch((err) => {
      console.log(err);
    });
};

exports.deleteTodo = (req, res) => {
  const expId = req.params.id;
  Todo.findByPk(expId)
    .then((todo) => {
      todo.destroy().then(() => res.status(200).send("Todo Deleted"));
    })
    .catch((err) => {
      console.log(err);
    });
};
