const express = require('express')
const app = express()
const path = require('path')
const asyncHandler = require('express-async-handler')
const { Client } = require('pg');
const { PORT, DATABASE_URL } = process.env;

const client = new Client({
  connectionString: DATABASE_URL,
  ssl: false
});

const runQuery = async (queryString) => {
  await client.connect()
  const query = await client.query(queryString)
  await client.end()
  return query
}

app.use(express.static(path.join(__dirname, 'public')))
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'ejs')

app.get('/', (req, res) => res.render('pages/index'))

app.get('/hero', asyncHandler(async (req, res) => {
  try {
    const query = runQuery('SELECT * FROM hero_view1;')
    console.log(query.rows)
    res.end(`Result: ${query.rows}`);
  } catch (error) {
    res.end("ERROR");
  }
}))

app.get('/users-win/:userId', asyncHandler(async (req, res) => {
  try {
    const query = runQuery(`SELECT * FROM user_view1 WHERE steam_id=${req.params.userId};`)
    console.log(query.rows)
    res.end(`Result: ${query.rows}`);
  } catch (error) {
    res.end("ERROR");
  }
}))

app.get('/users-win', asyncHandler(async (req, res) => {
  try {
    const query = runQuery('SELECT * FROM user_view2;')
    console.log(query.rows)
    res.end(`Result: ${query.rows}`);
  } catch (error) {
    res.end("ERROR");
  }
}))

app.listen(PORT, () => console.log(`Server running on ${PORT}/`))

// express()
//   .use(express.static(path.join(__dirname, 'public')))
//   .set('views', path.join(__dirname, 'views'))
//   .set('view engine', 'ejs')
  // .get('/', (req, res) => res.render('pages/index', data: {}))
//   .get('/foo', (req, res) => res.send("Foo bar 🙂"))
//   .listen(PORT, () => console.log(`Listening on ${ PORT }`))
