const express = require('express')
const path = require('path')
require('dotenv').config();
const { PORT, DATABASE_URL } = process.env;
const asyncHandler = require('express-async-handler')
const { Client } = require('pg');
const app = express()

const runQuery = async (queryString) => {
  const client = new Client({
    connectionString: DATABASE_URL,
    ssl: false
  });

  await client.connect()
  const query = await client.query(queryString)
  await client.end()
  return query
}

app.use(express.static(path.join(__dirname, 'public')))
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'ejs')

/**************** UI PAGES *****************/
app.get('/', (req, res) => res.render('pages/index'))

app.get('/hero', asyncHandler(async (req, res) => {
  try {
    const { rows } = await runQuery('SELECT * FROM hero_view1;')
    rows.reverse()
    res.render('pages/all_heroes', {
      viewName: "Heroes By Win Rate",
      results: rows
    })
  } catch (error) {
    console.error(error)
    res.end(JSON.stringify(error));
  }
}))

//TODO this ui isn't a thing yet
app.get('/hero/:heroId', asyncHandler(async (req, res) => {
  try {
    const { rows } = await runQuery(`
    SELECT
      *
    FROM 
      item_hero
    WHERE
      times=(
        SELECT 
          max(times)
        FROM
          item_hero
        WHERE
          hero_name='${req.params.heroId}' AND item_name!='empty')
      AND
        hero_name='${req.params.heroId}';
    `)
    const heroData = await runQuery(`SELECT * FROM hero WHERE hero_id=${req.params.heroId}`)
    
    rows.reverse()
    res.render('pages/hero', {
      viewName: "Heroes By Win Rate",
      results: rows,
      heroData: heroData.rows
    })
  } catch (error) {
    console.error(error)
    res.end(JSON.stringify(error));
  }
}))

//TODO actually query this with param
// app.get('/users/favorite/:player', asyncHandler(async (req, res) => {
//   try {
//     const { rows } = await runQuery(`
//       SELECT * 
//       FROM 
//         user_hero2 
//       WHERE
//         player.steam_id=${req.params.hero};
//     `)
//     res.end(JSON.stringify(rows))
//     // res.render('pages/db', {
//     //   viewName: "User Win Rate",
//     //   results: rows
//     // })
//   } catch (error) {
//     res.end(JSON.stringify(error));
//   }
// }))

app.get('/users/:userId', asyncHandler(async (req, res) => {
  try {
    const userHeroesData = await runQuery(`
      SELECT *
      FROM
        user_hero_view1
      WHERE
        steam_id='${req.params.userId}';
      `)
    const userMatchData = await runQuery(`
      SELECT *
      FROM
        player JOIN match ON (player.match_id=match.match_id)
      WHERE
        steam_id='${req.params.userId}';
      `)
    const { rows } = await runQuery(`SELECT * FROM users WHERE steam_id='${req.params.userId}';`)
    
    res.render('pages/user', {
      viewName: "User Page",
      results: rows,
      userHeroesData: userHeroesData.rows,
      userMatchData: userMatchData.rows
    })
  } catch (error) {
    res.end(JSON.stringify(error));
  }
}))

app.get('/users', asyncHandler(async (req, res) => {
  try {
    const { rows } = await runQuery('SELECT * FROM user_view1 NATURAL JOIN users;')
    rows.reverse()
    res.render('pages/all_users', {
      viewName: "All User's Win Rates",
      results: rows
    })
  } catch (error) {
    console.error(error)
    res.end(JSON.stringify(error));
  }
}))

app.get('/matches/:match/winners', asyncHandler(async (req, res) => {
  try {
    const { rows } = await runQuery(`
      SELECT * 
      FROM 
        match_view1 
      WHERE 
        match_id='${req.params.match}';
    `)
    res.render('pages/match_winners', {
      viewName: "Match Winners",
      results: rows
    })
  } catch (error) {
    console.error(error)
    res.end(JSON.stringify(error));
  }
}))

app.get('/matches', asyncHandler(async (req, res) => {
  try {
    const { rows } = await runQuery(`
      SELECT *
      FROM
        match
      ORDER BY
        start_time DESC;
      `)
    res.render('pages/all_matches', {
      viewName: "Most Recent Matches",
      results: rows
    })
  } catch (error) {
    console.error(error)
    res.end(JSON.stringify(error));
  }
}))

app.get('/items/:itemId', asyncHandler(async (req, res) => {
  try {
    const { rows } = await runQuery(`
      SELECT *
      FROM
        item
      WHERE
        item_id='${req.params.itemId}';
    `)
    res.render('pages/item', {
      viewName: "Most Recent Matches",
      results: rows
    })
  } catch (error) {
    console.error(error)
    res.end(JSON.stringify(error));
  }
}))

app.get('/items', asyncHandler(async (req, res) => {
  try {
    const { rows } = await runQuery('SELECT * FROM item_by_freq;')
    res.render('pages/all_items', {
      viewName: "Most Recent Matches",
      results: rows
    })
  } catch (error) {
    console.error(error)
    res.end(JSON.stringify(error));
  }
}))

app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}/`))
