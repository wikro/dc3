const redirect = (c) => {
  const latest = new Record();

  $app.dao().recordQuery("gloomhaven_storyline").orderBy("created DESC").limit(1).one(latest);

  return c.redirect(307, latest.getString("url"));
};

routerAdd("GET", "/gh", (c) => redirect(c));
routerAdd("GET", "/gh/", (c) => redirect(c));
