const data = {
  core: [
    { name: "Standing Shoulder Press", one_rep_max: 20 },
    { name: "Deadlift", one_rep_max: 70 },
  ],
  supplement: [
    { name: "Dip", sets: 5, reps: 15, weight: 20 },
    { name: "Chin-up", sets: 5, reps: 10, weight: 50 },
    { name: "Good Morning", sets: 5, reps: 12, weight: 30 },
    { name: "Hanging Leg Raise", sets: 5, reps: 15, weight: "n/a" }
  ],
  sessions: [
    { core: 0, supplements: [0, 1] },
    { core: 1, supplements: [1, 2] }
  ]
};

const state = {};
const action = {};
const view = {};

const model = {};

// ===== Model

model.core_sets = (core_id) => {
  const core = data.core[core_id];
  const core_sets = [];
  const min_weight = 2.5;

  for (let set = 1; set <= 3; set++) {
    const core_set = {
      done: false,
      sets: 1,
      reps: 5,
      weight: Math.round((core.one_rep_max * (0.55 + set * 0.10)) / min_weight) * min_weight,
      ...core
    };

    core_sets.push(core_set);
  }

  return core_sets;
};

model.supplement_sets = (supplement_ids) => {
  const supplement_sets = [];

  for (const supplement_id of supplement_ids) {
    const supplement = data.supplement[supplement_id];

    const supplement_set = {
      done: false,
      ...supplement
    };

    supplement_sets.push(supplement_set);
  }

  return supplement_sets;
};

model.init = () => {
  const sessions = [];

  for (const session_data of data.sessions) {
    const session = [];

    const core_sets = model.core_sets(session_data.core);
    session.push(...core_sets);

    const supplement_sets = model.supplement_sets(session_data.supplements);
    session.push(...supplement_sets);

    sessions.push(session);
  }

  const proposal = {
    model: model,
    update: {
      sessions: sessions
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
  const sessions = document.getElementById("sessions");

  sessions.innerHTML = ``;
  for (const session_id in model.sessions) {
    const session = model.sessions[session_id];
    sessions.innerHTML += view.session(session, session_id);
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
