const pb = new PocketBase("https://pocketbase.dc3.se")

pb.collection('chat').subscribe('*', function (e) {
    console.log(e.action);
    console.log(e.record);
}, {});
