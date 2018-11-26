const express = require('express')
const app = express()
const path = require('path')
const url = require('url');
const fs = require('fs');
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

app.get('/hero/1', asyncHandler(async (req, res) => {
  try {
    const { rows } = await runQuery('SELECT * FROM hero_view1;')
    res.end(JSON.stringify(rows));
  } catch (error) {
    console.error(error)
    res.end(JSON.stringify(error));
  }
}))

app.get('/hero/2', asyncHandler(async (req, res) => {
  try {
    const { rows } = await runQuery('SELECT * FROM hero_view2;')
    res.end(JSON.stringify(rows));
  } catch (error) {
    res.end(JSON.stringify(error));
  }
}))

app.get('/users/favorite/:hero', asyncHandler(async (req, res) => {
  try {
    const { rows } = await runQuery('SELECT * FROM user_hero2;')
    res.end(JSON.stringify(rows));
  } catch (error) {
    res.end(JSON.stringify(error));
  }
}))

app.get('/users-win/:userId', asyncHandler(async (req, res) => {
  try {
    const { rows } = await runQuery(`SELECT * FROM user_view1 WHERE steam_id='${req.params.userId}';`)
    res.end(JSON.stringify(rows));
  } catch (error) {
    res.end(JSON.stringify(error));
  }
}))

app.get('/users-win', asyncHandler(async (req, res) => {
  try {
    const { rows } = await runQuery('SELECT * FROM user_view2;')
    res.end(JSON.stringify(rows));
  } catch (error) {
    console.error(error)
    res.end(JSON.stringify(error));
  }
}))

app.get('/user_match', (req, res) => {
  res.render('pages/user_match')
})

app.get('/user_overview', (req, res) => {
  res.render('pages/user_overview')
})

app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}/`))
