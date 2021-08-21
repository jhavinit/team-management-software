const express = require('express');

const app = express();

app.get('/', (req, res) => {
  res.end('this is working fine');
});
const port = 3000;

app.listen(port, () => {
  console.log(`Server has started at port ${port}`);
});
