const db = require('./db');

async function seed() {
    try {
        // Check majors
        const [majors] = await db.query('SELECT * FROM majors');
        if (majors.length === 0) {
            console.log('Inserting majors...');
            await db.query(`INSERT INTO majors (id, name) VALUES
                (1, 'هندسة'),
                (2, 'علوم حاسوب'),
                (3, 'تقنية معلومات'),
                (4, 'طب')`);
        } else {
            console.log('Majors already exist.');
        }

        // Check students
        const [students] = await db.query('SELECT * FROM students');
        if (students.length === 0) {
            console.log('Inserting students...');
            await db.query(`INSERT INTO students (name, major_id, fees_paid, student_code, qr_data) VALUES
                ('أحمد محمد', 1, 1, '123456', 'QR_123456'),
                ('سارة علي', 1, 0, '234567', 'QR_234567'),
                ('محمد حسن', 1, 1, '345678', 'QR_345678'),

                ('ريم خالد', 2, 1, '456789', 'QR_456789'),
                ('عبدالله عمر', 2, 0, '567890', 'QR_567890'),
                ('نور أحمد', 2, 1, '678901', 'QR_678901'),
                ('ليلى يوسف', 2, 1, '789012', 'QR_789012'),

                ('خالد سمير', 3, 1, '890123', 'QR_890123'),
                ('منى إبراهيم', 3, 0, '901234', 'QR_901234'),
                ('طارق سعد', 3, 1, '012345', 'QR_012345'),

                ('يوسف محمود', 4, 1, '112233', 'QR_112233'),
                ('هبة الله', 4, 1, '223344', 'QR_223344'),
                ('عمر عبدالسلام', 4, 0, '334455', 'QR_334455'),
                ('دعاء حسن', 4, 1, '445566', 'QR_445566'),
                ('آية ناصر', 4, 1, '556677', 'QR_556677')`);
        } else {
            console.log('Students already exist.');
        }

        process.exit(0);
    } catch (err) {
        console.error(err);
        process.exit(1);
    }
}

seed();
