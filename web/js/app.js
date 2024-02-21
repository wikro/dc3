const { createApp, ref } = Vue;

const apiUrl = 'https://prometheus.dc3.se/api/v1';

const setup = () => {
  const targets = ref({});
  const activeTargets = ref({});
  const droppedTargets = ref({});

  const sortTargets = (a, b) => {
    return a.labels.instance.localeCompare(b.labels.instance);
  };

  const fetchTargets = () => {
    fetch(`${apiUrl}/targets`).then((response) => {
      response.json().then((json) => {
        targets.value = json;
        activeTargets.value = json.data.activeTargets.sort(sortTargets);
        droppedTargets.value = json.data.droppedTargets.sort(sortTargets);

        const timeout = 5 * 1000;
        const now = new Date();
        const delay = timeout - (now % timeout);

        setTimeout(fetchTargets, delay);
      });
    });
  };

  fetchTargets();

  return {
    targets,
    activeTargets,
    droppedTargets
  };
};

const app = createApp({ setup });

app.mount('#app');
