const express = require("express");
var bodyParser = require('body-parser')

const app = express();
app.use(bodyParser.urlencoded({ extended: false }))

app.use(bodyParser.json())

const port = 3030

const Restuarants = [
  { name: "See Lagos", address: "36b Wole Ariyo St, Lekki Phase I 106104, Lagos"},
  { name: "Terraform", address: "14 Wole Olateju Crescent Lekki, 102112, Lagos"},
  { name: "Sketch", address: "5 Adeola Hopewell St, Victoria Island 106104, Lagos"}
]

app.get("/", (req, res) => {
  res.json(Restuarants)
})

app.get("/restuarants/:id", (req, res) => {
  res.json(Restuarants[parseInt(req.params.id) - 1])
})

app.post("restuarants", (req, res) => {
  console.log(req.body)
  res.json({message: "all good"})
})

app.put("restuarants/:id", (req, res) => {
  console.log(req.params.id)
  res.json({message: `Updating restuarant ${req.params.id}`})
})

app.delete("restuarants/:id", (req, res) => {
  console.log(req.params.id)
  res.json({message: `Deleting restuarant ${req.params.id}`})
})

app.listen(port, () => {
  console.log(`The app is live on port ${port}`);
})