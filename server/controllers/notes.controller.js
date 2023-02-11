const noteServices = require("../services/notes.services");

class Message {
    constructor(type, data) {
        this.type = type;
        this.data = data;
    }
}

const WebSocket = require("ws");
const wss = new WebSocket.WebSocketServer({path: "/socket", port: 3000})
let ws = null;

wss.on('connection', socket => {
  ws = socket;
  socket.on('message', message => {
    console.log(`received from a client: ${message}`);
  });
  socket.send('Hello world!');
});

exports.create = (req, res, next) => {
    const model = {
        title: req.body.title,
        description: req.body.description, 
        date: Date.now(),
        emotion: req.body.emotion,
    };

    noteServices.createNote(model, (error, results) => {
        if (error) {
            // In general express follows the way of passing errors rather than throwing it
            // an error handler needs to be defined so that all the errors passed to 'next' can be handled properly.
            return next(error);
        } else {
            return res.status(200).send({
                message: "Success",
                data: results
            })
        }
    })
}   


exports.findAll = (req, res, next) => {
    noteServices.getNotes((error, results) => {
        if (error) {
            return next(error);
        } else {
            return res.status(200).send({
                message: "Success",
                data: results
            })
        }
    })       
}

exports.findOne = (req, res, next) => {
    const model = {
        id: req.params.id,
    };

    noteServices.getNoteById(model, (error, results) => {
        if (error) {
            return next(error);
        } else {
            return res.status(200).send({
                message: "Success",
                data: results
            })
        }
    })
}

exports.update = (req, res, next) => {
    const model = {
        id: req.params.id,
        title: req.body.title,
        description: req.body.description, 
        date: Date.now(),
        emotion: req.body.emotion,
    };

    noteServices.updateNote(model, (error, results) => {
        if (error) {
            return next(error);
        } else {
            return res.status(200).send({
                message: "Success",
                data: results
            })
        }
    })
}

exports.delete = (req, res, next) => {
    const model = {
        id: req.params.id,
    };

    noteServices.deleteNote(model, (error, results) => {
        if (error) {
            return next(error);
        } else {
            return res.status(200).send({
                message: "Success",
                data: results
            })
        }
    })
}

