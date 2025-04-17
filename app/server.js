const http = require('http');

const server = http.createServer((req, res) => {
  res.end('Hello from ECS!');
});

const PORT = process.env.PORT || 8080;
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
