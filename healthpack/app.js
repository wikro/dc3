const data = {
  sessions: [
    [
      { name: "Standing Shoulder Press", sets: 1, reps: 5, weight: 20 },
      { name: "Standing Shoulder Press", sets: 1, reps: 5, weight: 25 },
      { name: "Standing Shoulder Press", sets: 1, reps: "5+", weight: 30 },
      { name: "Dip", sets: 5, reps: 15, weight: 20 },
      { name: "Chin-up", sets: 5, reps: 10, weight: 50 }
    ]
  ]
};

const state = {};
const action = {};
const view = {};

const model = {
  sessions: data.sessions
};

// ===== Model

model.present = (proposal) => {
  if (Object.hasOwn(proposal, "counter")) {
    model.counter = proposal.counter;
  }

  state.update();
};

// ===== State

state.ready = () => {
  return true;
};

state.update = () => {
  if (state.ready()) {
    return view.render();
  }
};

// ===== Views

view.exercise = (exercise) => {
  return `
    <li>${exercise.name}</li>
    <li>${exercise.sets} x ${exercise.reps}</li>
    <li>${exercise.weight} kg</li>
  `;
};

view.session = (session) => {
  let html = `
    <div class="session">
      <h3>Session</h3>
      <ul>
  `;

  for (const exercise of session) {
    html += view.exercise(exercise);
  }

  html += `
      </ul>
    </div>
  `;

  return html;
};

view.render = () => {
  const app = document.getElementById("app");

  app.innerHTML = ``;
  for (const session of model.sessions) {
    app.innerHTML += view.session(session);
  }
};

// ===== Actions

action.inc_counter = () => {
  const incremented = model.counter + 1;
  model.present({ counter: incremented });
};

// ===== Init

state.update();
