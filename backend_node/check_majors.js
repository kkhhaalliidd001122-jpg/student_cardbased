const db = require('./db');

(async () => {
    try {
        const [rows] = await db.query('SHOW TABLES LIKE "majors"');
        console.log('Majors table check:', rows);
        if (rows.length > 0) {
            const [columns] = await db.query('SHOW COLUMNS FROM majors');
            console.table(columns);
        }
        process.exit(0);
    } catch (err) {
        console.error('Error:', err);
        process.exit(1);
    }
})();
