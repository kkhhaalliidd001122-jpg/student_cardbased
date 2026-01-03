const db = require('./db');

(async () => {
    try {
        const [columns] = await db.query('SHOW COLUMNS FROM students');
        console.log('--- Students Table Columns ---');
        console.table(columns);
        process.exit(0);
    } catch (err) {
        console.error('Error fetching columns:', err);
        process.exit(1);
    }
})();
