routerAdd("GET", "/gh", (c) => {
  const latest = new Record();

  $app.dao().recordQuery("gloomhaven_storyline").orderBy("created DESC").limit(1).one(latest);

  return c.json(307, "https://www.google.com");
});

