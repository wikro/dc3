const data = {
  sessions: [
    [
      { name: "Standing Shoulder Press", sets: 1, reps: 5, weight: 20, done: false },
      { name: "Dip", sets: 5, reps: 15, weight: 20, done: false },
      { name: "Chin-up", sets: 5, reps: 10, weight: 50, done: false }
    ]
  ]
};

const state = {};
const action = {};
const view = {};

const model = {};

// ===== Model

model.init = () => {
  const proposal = {
    model: model,
    update: {
      sessions: data.sessions
    }
  };

  model.present(proposal);
};

model.present = (proposal) => {
  if (proposal.model !== undefined) {
    Object.assign(proposal.model, proposal.update);
  }

  if (proposal.exercise !== undefined) {
    Object.assign(proposal.exercise, proposal.update);
  }

  state.update();
};

// ===== State

state.ready = () => {
  return model.sessions !== undefined;
};

state.update = () => {
  if (state.ready()) {
    return view.render();
  }
};

// ===== Views

view.session = (session, session_id) => {
  let html = `
    <div class="session">
      <h3>Session ${session_id}</h3>
  `;

  for (const exercise_id in session) {
    const exercise = session[exercise_id];
    html +=  `
      <ul ${exercise.done ? 'class="done"' : ''}>
        <li>${exercise.name}</li>
        <li>${exercise.sets} x ${exercise.reps}</li>
        <li>${exercise.weight} kg</li>
        <li><input type="checkbox" onclick="action.toggle_done(${session_id}, ${exercise_id});" ${exercise.done ? 'checked' : ''}/></li>
      </ul>
    `;
  }

  html += `
    </div>
  `;

  return html;
};

view.render = () => {
  const app = document.getElementById("app");

  app.innerHTML = ``;
  for (const i in model.sessions) {
    const session = model.sessions[i];
    app.innerHTML += view.session(session, i);
  }
};

// ===== Actions

action.toggle_done = (session_id, exercise_id) => {
  const exercise = model.sessions[session_id][exercise_id];

  const proposal = {
    exercise: exercise,
    update: { done: !exercise.done }
  };

  model.present(proposal);
};

// ===== Init

model.init();
