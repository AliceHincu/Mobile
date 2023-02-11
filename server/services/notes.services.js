const {note} = require("../models/notes.model");

async function createNote(params, callback) {
    if(!params.title) {
        return callback (
            {
                message: "Note Title Required",
            },
            ""
        );
    }
    if(!params.description) {
        return callback (
            {
                message: "Note Description Required",
            },
            ""
        );
    }
    if(!params.emotion) {
        return callback (
            {
                message: "Note Emotion Required",
            },
            ""
        );
    }

    const noteModel = note(params);
    noteModel
    .save()
    .then((response) => {
        return callback(null, response);
    })
    .catch((error) => {
        return callback(error);
    });
}

async function getNotes(callback) {
    note
    .find()
    .then((response) => {
        return callback(null, response);
    })
    .catch((error) => {
        return callback(error);
    });
}

async function getNoteById(params, callback) {
    const noteId = params.id;

    note
    .findById(noteId)
    .then((response) => {
        if (!response) 
            callback("Note Id Invalid!");
        else 
            return callback(null, response);
    })
    .catch((error) => {
        return callback(error);
    });
}

async function updateNote(params, callback) {
    const noteId = params.id;

    note
    .findByIdAndUpdate(noteId, params, {useFindAndModify: false })
    .then((response) => {
        if (!response) 
            callback("Note Id Invalid!");
        else 
            return callback(null, response);
    })
    .catch((error) => {
        return callback(error);
    });
}

async function deleteNote(params, callback) {
    const noteId = params.id;

    note
    .findByIdAndRemove(noteId)
    .then((response) => {
        if (!response) 
            callback("Note Id Invalid!");
        else 
            return callback(null, response);
    })
    .catch((error) => {
        return callback(error);
    });
}

module.exports = {
    createNote,
    getNotes,
    getNoteById, 
    updateNote, 
    deleteNote,
};