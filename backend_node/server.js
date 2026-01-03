const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const db = require('./db');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.post('/api/login', async (req, res) => {
    const { username, password, role } = req.body;

    if (!username || !password || !role) {
        return res.status(400).json({ error: 'Missing fields' });
    }

    let table = '';
    let userCol = 'username';

    switch (role) {
        case 'doctor':
            table = 'doctors';
            break;
        case 'gatekeeper':
            table = 'gatekeepers';
            break;
        case 'student':
            table = 'students';
            userCol = 'student_code';
            break;
        default:
            return res.status(400).json({ error: 'Invalid role' });
    }

    try {
        // Check if password column exists in students table (Auto-migration logic)
        if (role === 'student') {
            const [columns] = await db.query("SHOW COLUMNS FROM students LIKE 'password'");
            if (columns.length === 0) {
                console.log("Adding password column to students table...");
                await db.query("ALTER TABLE students ADD COLUMN password VARCHAR(255) NOT NULL DEFAULT '123456'");
            }
        }

        const [rows] = await db.query(`SELECT * FROM ${table} WHERE ${userCol} = ? AND password = ?`, [username, password]);

        if (rows.length > 0) {
            res.json({ success: true, data: rows[0] });
        } else {
            res.status(401).json({ error: 'Invalid credentials' });
        }
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Database error: ' + err.message });
    }
});

app.get('/api/students', async (req, res) => {
    try {
        // Fetch students with relevant fields including major name.
        const query = `
            SELECT s.*, m.name as major_name 
            FROM students s 
            LEFT JOIN majors m ON s.major_id = m.id
        `;
        const [rows] = await db.query(query);
        res.json({ success: true, data: rows });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Database error: ' + err.message });
    }
});


app.get('/api/majors', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM majors');
        res.json({ success: true, data: rows });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Database error: ' + err.message });
    }
});

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
