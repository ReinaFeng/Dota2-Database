const express = require('express')
const app = express()
const path = require('path')
const port = process.env.PORT || 5000
const http = require('http');
const { Client } = require('pg');
const { DATABASE_URL } = process.env;

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

app.listen(port, () => console.log(`Server running on ${port}/`))

// express()
//   .use(express.static(path.join(__dirname, 'public')))
//   .set('views', path.join(__dirname, 'views'))
//   .set('view engine', 'ejs')
//   .get('/', (req, res) => res.render('pages/index'))
//   .get('/foo', (req, res) => res.send("Foo bar 🙂"))
//   .listen(PORT, () => console.log(`Listening on ${ PORT }`))
