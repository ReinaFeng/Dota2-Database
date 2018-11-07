const express = require('express')
const app = express()
const path = require('path')
const http = require('http');
const { Client } = require('pg');
const { PORT, DATABASE_URL } = process.env;

const client = new Client({
  connectionString: DATABASE_URL,
  ssl:false
});

app.get('/', (req, res) => res.send('Hello World!'))
app.get('/match', (req, res) => {
  client.connect()
    .then(() => client.query('SELECT * FROM match;'))
    .then((query) => {
      console.log(query.rows)
      res.end(`Result: ${query.rows}`);
      client.end();
    })
    .catch(() => {
      res.end("ERROR");
      client.end();
    });
})

app.listen(PORT, () => console.log(`Server running on ${PORT}/`))

// express()
//   .use(express.static(path.join(__dirname, 'public')))
//   .set('views', path.join(__dirname, 'views'))
//   .set('view engine', 'ejs')
//   .get('/', (req, res) => res.render('pages/index'))
//   .get('/foo', (req, res) => res.send("Foo bar 🙂"))
//   .listen(PORT, () => console.log(`Listening on ${ PORT }`))
