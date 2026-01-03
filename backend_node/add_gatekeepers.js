const db = require('./db');

async function addGatekeepers() {
    try {
        const gatekeepers = [
            { name: 'Gatekeeper 1', username: 'gate1', password: '123' },
            { name: 'Gatekeeper 2', username: 'gate2', password: '123' }
        ];

        for (const gk of gatekeepers) {
            // Check if exists
            const [rows] = await db.query('SELECT * FROM gatekeepers WHERE username = ?', [gk.username]);
            if (rows.length === 0) {
                await db.query('INSERT INTO gatekeepers (name, username, password) VALUES (?, ?, ?)', [gk.name, gk.username, gk.password]);
                console.log(`Added ${gk.username}`);
            } else {
                console.log(`${gk.username} already exists`);
            }
        }
        process.exit(0);
    } catch (err) {
        console.error(err);
        process.exit(1);
    }
}

addGatekeepers();
