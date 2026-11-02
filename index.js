const express = require("express");
const app = express()

app.use(require("express").static(__dirname + "/public"));

app.get("/", (req, res) => {
  res.sendFile(__dirname + "/index.html");
});

app.get("/side-projects/roblox-friends-ui-recreation", (req, res) => {
  res.sendFile(__dirname + "/public/friends-ui/index.html");
});

app.get("/rblx-fuir", (req, res) => {
  res.send('<script>window.open("/side-projects/roblox-friends-ui-recreation", "_self");</script>');
});

app.get('*', function (req, res) {
  res.status(404).sendFile(__dirname + "/public/page-not-found.html");
});

app.listen(8080, '::');
