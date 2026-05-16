const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Thêm Logging để bạn dễ theo dõi trong Terminal khi có request từ Flutter
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  next();
});

// Load Mock Data
const dataPath = path.join(__dirname, 'data.json');
const getData = () => JSON.parse(fs.readFileSync(dataPath, 'utf8'));

// 1. Home / Help Page (Hiển thị danh sách API cho bạn dễ nhìn)
app.get('/', (req, res) => {
  res.send(`
    <html>
      <body style="font-family: sans-serif; padding: 50px; line-height: 1.6;">
        <h1>🚀 Fellow4U API is Running</h1>
        <p>Dưới đây là danh sách các API bạn có thể thử:</p>
        <ul>
          <li><b>Tours:</b> <a href="/api/tours">/api/tours</a></li>
          <li><b>Featured Tours:</b> <a href="/api/tours/featured">/api/tours/featured</a></li>
          <li><b>Guides:</b> <a href="/api/guides">/api/guides</a></li>
          <li><b>Notifications:</b> <a href="/api/notifications">/api/notifications</a></li>
          <li><b>Trips:</b> <a href="/api/trips">/api/trips</a></li>
          <li><b>Chats:</b> <a href="/api/chats">/api/chats</a></li>
        </ul>
        <p><i>Lưu ý: Các API POST (Login, Register) cần dùng Postman hoặc code Flutter để gọi.</i></p>
      </body>
    </html>
  `);
});

// 2. Auth: Login
app.post('/api/login', (req, res) => {
  const { email, password } = req.body;
  const data = getData();
  const user = data.users.find(u => u.email === email && u.password === password);
  if (user) {
    res.json({ success: true, user: { id: user.id, name: user.name, email: user.email } });
  } else {
    res.status(401).json({ success: false, message: 'Invalid credentials' });
  }
});

// 3. Auth: Register
app.post('/api/register', (req, res) => {
  const { name, email, password } = req.body;
  const data = getData();
  if (data.users.find(u => u.email === email)) {
    return res.status(400).json({ success: false, message: 'Email already exists' });
  }
  const newUser = { id: data.users.length + 1, name, email, password };
  data.users.push(newUser);
  fs.writeFileSync(dataPath, JSON.stringify(data, null, 2));
  res.json({ success: true, user: { id: newUser.id, name: newUser.name, email: newUser.email } });
});

// 4. Tours: Get All
app.get('/api/tours', (req, res) => {
  res.json(getData().tours);
});

// 5. Tours: Get Featured
app.get('/api/tours/featured', (req, res) => {
  res.json(getData().tours.filter(t => t.featured));
});

// 6. Tours: Get Detail by ID
app.get('/api/tours/:id', (req, res) => {
  const tour = getData().tours.find(t => t.id == req.params.id);
  tour ? res.json(tour) : res.status(404).json({ message: 'Tour not found' });
});

// 7. Guides: Get All
app.get('/api/guides', (req, res) => {
  res.json(getData().guides);
});

// 8. Guides: Get Detail by ID
app.get('/api/guides/:id', (req, res) => {
  const guide = getData().guides.find(g => g.id == req.params.id);
  guide ? res.json(guide) : res.status(404).json({ message: 'Guide not found' });
});

// 9. Notifications: Get All
app.get('/api/notifications', (req, res) => {
  res.json(getData().notifications);
});

// 10. Trips: Get All
app.get('/api/trips', (req, res) => {
  res.json(getData().trips);
});

// 11. Trips: Create New
app.post('/api/trips', (req, res) => {
  const { title, date } = req.body;
  const data = getData();
  const newTrip = { id: data.trips.length + 1, title, date, status: 'Planned' };
  data.trips.push(newTrip);
  fs.writeFileSync(dataPath, JSON.stringify(data, null, 2));
  res.json({ success: true, trip: newTrip });
});

// 12. Chats: Get Chat List
app.get('/api/chats', (req, res) => {
  res.json(getData().chats);
});

// Catch-all 404 for API routes
app.use('/api', (req, res) => {
  res.status(404).json({ success: false, message: `API route not found: ${req.method} ${req.url}` });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server is running on http://0.0.0.0:${PORT}`);
});
