// const express = require("express");
// const app = express();
// const mongoose = require("mongoose");
// const {MONGO_DB_CONFIG} = require("./config/app.config");
// const errors = require("./middleware/errors");

// mongoose.Promise = global.Promise;
// mongoose.connect(MONGO_DB_CONFIG.DB , {
//     useNewUrlParser: true,
//     useUnifiedTopology: true
// }).then(
//     () => {
//         console.log("Database Connection");
//     },
//     (error) => {
//         console.log("Database can't be connected" + error);
//     }
// );

// app.use(express.json()); // for handling requests
// app.use('/uploads', express.static('uploads'));
// app.use("/api", require("./routes/app.routes"));
// app.use(errors.errorHandler);
// var multer = require('multer');
// var upload = multer();

// app.use(express.json()); 

// var bodyParser = require('body-parser');
// app.use(bodyParser.json());
// app.use(bodyParser.urlencoded({ extended: true }));

// app.listen(process.env.port || 4000, function () {
//     console.log("Ready to go");
// })
const WebSocket = require("ws");

const wss = new WebSocket.WebSocketServer({path: "/socket", port: 3001})

const GREETING = "GREETING";
const HEARTBEAT = "HEARTBEAT";
const CREATE = "CREATE";
const DELETE = "DELETE";
const UPDATE = "UPDATE";
const GET_ALL = "GET_ALL";
const ERROR = "ERROR";

class Note {
    constructor(_id, title, description, date, emotion ) {
        this._id = _id;
        this.title = title;
        this.description = description;
        this.date = date;
        this.emotion = emotion;
    }
}

class Message {
    constructor(type, data) {
        this.type = type;
        this.data = data;
    }
}

let notes = [
    new Note(1, "Note 1", "Desc", Date.now(), 1),
    new Note(2, "Note 2", "Desc", Date.now(), 2),
    new Note(3, "Note 3", "Desc", Date.now(), 3),
    new Note(4, "Note 4", "Desc", Date.now(), 2),
    new Note(5, "Note 5", "Desc", Date.now(), 1)
];

wss.on("connection", (ws, request) => {
    const clientIp = request.connection.remoteAddress;
    console.log(`[WebSocket] Client with IP ${clientIp} has connected`);
    ws.send(JSON.stringify(new Message(GREETING, "Thanks for connecting to this nodejs websocket server")));
    ws.send(JSON.stringify(notes));

    tm = setTimeout(function () {
        /// ---connection closed ///
        console.log("CLOSING CONNECTION...15 SECONDS PASSED SINCE THE LAST HEARTBEAT");
        ws.close()
    }, 15000);

    ws.on("message", message => {
        var jsonMessage = JSON.parse(message);
        console.log(jsonMessage);
        switch (jsonMessage.type) {
            case GREETING:
                break;
            case HEARTBEAT:
                clearTimeout(tm);
                tm = setTimeout(function () {
                    /// ---connection closed ///
                    console.log("CLOSING CONNECTION...15 SECONDS PASSED SINCE THE LAST HEARTBEAT");
                    ws.close()
                }, 15000);
                break;
            case CREATE:
                let createdNote = add(jsonMessage.data);
                let createResponse = JSON.stringify(new Message(CREATE, createdNote));

                if (createdNote == null) {
                    createResponse = JSON.stringify(new Message(ERROR, "Note already exists in the server"));
                }

                console.log("Created note: " + JSON.stringify(createdNote));
                console.log("Sending response: " + createResponse);
                ws.send(createResponse);
                break;
            case GET_ALL:
                // update the server with local changes
                for (let note of jsonMessage.data) {
                    let n = add(note);
                    if (n == null) {
                        let nu = update(note);
                        console.log("Updated note: " + JSON.stringify(nu));
                    } else {
                        console.log("Added note: " + JSON.stringify(n));
                    }
                }
                
                const response = JSON.stringify(new Message(GET_ALL, notes));
                ws.send(response);

                break;
            case UPDATE:
                let updatedNote = update(jsonMessage.data);
                let updateResponse = JSON.stringify(new Message(UPDATE, updatedNote));

                if (updatedNote == null) {
                    updateResponse = JSON.stringify(new Message(ERROR, "Could not find that note in the server"));
                }

                console.log("Updated note: " + JSON.stringify(updatedNote));
                console.log("Sending response: " + updateResponse);
                ws.send(updateResponse);

                break;
            case DELETE:
                let removedNote = remove(jsonMessage.data._id);
                let removeResponse = JSON.stringify(new Message(DELETE, removedNote));

                if (removedNote == null) {
                    removeResponse = JSON.stringify(new Message(ERROR, "Could not find that note in the server"));
                }

                console.log("Removed note: " + JSON.stringify(removedNote));
                console.log("Sending response: " + removeResponse);
                ws.send(removeResponse);

                break;
            case ERROR:
                console.log("Oops...an error")
        }
    });
});

function getNewId() {
    let newId = 0;
    for (var note of notes) 
        newId = Math.max(newId, note._id);
    
    return newId + 1;
}

function add(note) {
    for (var n of notes) {
        if (n.hasOwnProperty('_id') && n._id === note._id) {
            return null;
        }
    }

    noteToAdd = new Note(getNewId(), note.title, note.description, Date.now(), note.emotion);
    notes.push(noteToAdd);
    return noteToAdd;
}

function update(note) {
    for (var n of notes) {
        if (n._id === note._id) {
            n.title = note.title;
            n.description = note.description;
            n.date = note.date;
            n.emotion = note.emotion;
            return n;
        }
    }
    return null;
}

// function updateFromLocal(note) {
//     for (var n of notes) {
//         if (n._id === note._id) {
//             n.title = note.title;
//             n.description = note.description;
//             n.date = note.date;
//             n.emotion = note.emotion;
//             return n;
//         }
//     }
//     return null;
// }

function remove(id) {
    let index = notes.findIndex((obj) => obj._id === id);
    console.log(index)

    if (index > -1) {
        note = notes[index]
        notes.splice(index, 1);
        return note
    }

    return null;
}