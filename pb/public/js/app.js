const exercises = [
  {
    "name": "Standing Shoulder Press",
    "description": ""
  },
  {
    "name": "Dip",
    "description": ""
  },
  {
    "name": "Chin-up",
    "description": ""
  }
];

const workouts = [
  {
    "exercises": [
      {
        "exercise": exercises[0],
        "sets": [
          { "reps": 5, "weight": 32.5 },
          { "reps": 5, "weight": 37.5 },
          { "reps": 5, "weight": 42.5 }
        ]
      },
      {
        "exercise": exercises[1],
        "sets": [
          { "reps": 15, "weight": 25.0 },
          { "reps": 15, "weight": 25.0 },
          { "reps": 15, "weight": 25.0 },
          { "reps": 15, "weight": 25.0 },
          { "reps": 15, "weight": 25.0 }
        ]
      },
      {
        "exercise": exercises[2],
        "sets": [
          { "reps": 10, "weight": 25.0 },
          { "reps": 10, "weight": 25.0 },
          { "reps": 10, "weight": 25.0 },
          { "reps": 10, "weight": 25.0 },
          { "reps": 10, "weight": 25.0 }
        ]
      }
    ]
  }
];

const program = {
  "weeks": [
    {
      "workouts": [ workouts[0] ]
    }
  ]
};

getWorkout = (week_id, workout_id) => {
  return program.weeks[week_id].workouts[workout_id];
};

const { createApp, ref } = Vue;

const setup = () => {
  const workout = ref({});

  workout.value = getWorkout(0, 0);

  return { workout };
};

createApp({ setup }).mount('#app');
