const { createApp, ref } = Vue;

const setup = () => {
  const pb = new PocketBase('https://pocketbase.dc3.se');

  const messages = ref([]);

  const fetchMessages = () => {
    pb.collection('chat').getList(1, 15, {}).then((list) => {
      messages.value = list.items;
    });
  };

  fetchMessages();

  const newMessage = (message) => {
    messages.value.push(message);

    if (messages.value.length > 15) {
      messages.value = messages.value.slice(1, 17);
    };
  };

  pb.collection('chat').subscribe('*', (e) => {
    newMessage(e.record);
  }, {});

  return { messages };
};

const app = createApp({ setup });

app.mount('#chat');
