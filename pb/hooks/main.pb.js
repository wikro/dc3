routerAdd("GET", "/gh", (c) => {
  const latest = new Record();

  $app.dao().recordQuery("gloomhaven_stroyline").orderBy("created DESC").limit(1).one(record);

  return c.json(200, record)
});

