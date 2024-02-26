routerAdd("GET", "/gh", (c) => {
  const latest = new Record();

  $app.dao().recordQuery("gloomhaven_storyline").orderBy("created DESC").limit(1).one(latest);

  return c.redirect(307, latest.getString("url"));
});

