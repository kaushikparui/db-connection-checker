require('dotenv').config();
const express = require('express');
const mysql = require('mysql2');

// DB config from .env
const dbConfig = {
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
};

// Placeholder for DB status
let dbStatusMessage = '<span style="color:red;">DB connection failed</span>';

// Connect to DB
const connection = mysql.createConnection(dbConfig);
connection.connect((err) => {
    if (err) {
        console.error('DB Connection Failed:', err.message);
        dbStatusMessage = `<span style="color:red;">DB Connection Failed: ${err.message}</span>`;
    } else {
        console.log('DB Connected Successfully!');
        dbStatusMessage = '<span style="color:green;">DB Connected Successfully</span>';
    }
});

// Express app
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
    res.send(`
        <h1>Welcome to the Landing Page</h1>
        <p>Database Status: ${dbStatusMessage}</p>
    `);
});

app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
