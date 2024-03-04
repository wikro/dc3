const api = () => {
  const workouts = [
    {
      "exercises": [
        {
          "name": "Standing shoulder press",
          "description": "",
          "sets": [
            { "reps": 5, "weight": 32.5 },
            { "reps": 5, "weight": 37.5 },
            { "reps": 5, "weight": 42.5 }
          ],
          "current_set": 0
        },
        {
          "name": "Dip",
          "description": "",
          "sets": [
            { "reps": 15, "weight": 25.0 },
            { "reps": 15, "weight": 25.0 },
            { "reps": 15, "weight": 25.0 },
            { "reps": 15, "weight": 25.0 },
            { "reps": 15, "weight": 25.0 }
          ],
          "current_set": 0
        },
        {
          "name": "Chin-up",
          "description": "",
          "sets": [
            { "reps": 10, "weight": 25.0 },
            { "reps": 10, "weight": 25.0 },
            { "reps": 10, "weight": 25.0 },
            { "reps": 10, "weight": 25.0 },
            { "reps": 10, "weight": 25.0 }
          ],
          "current_set": 0
        }
      ]
    },
    {
      "exercises": [
        {
          "name": "Deadlift",
          "description": "",
          "sets": [
            { "reps": 5, "weight": 65.0 },
            { "reps": 5, "weight": 75.0 },
            { "reps": 5, "weight": 85.0 }
          ],
          "current_set": 0
        },
        {
          "name": "Good morning",
          "description": "",
          "sets": [
            { "reps": 12, "weight": 25.0 },
            { "reps": 12, "weight": 25.0 },
            { "reps": 12, "weight": 25.0 },
            { "reps": 12, "weight": 25.0 },
            { "reps": 12, "weight": 25.0 }
          ],
          "current_set": 0
        },
        {
          "name": "Hanging leg raise",
          "description": "",
          "sets": [
            { "reps": 15, "weight": 25.0 },
            { "reps": 15, "weight": 25.0 },
            { "reps": 15, "weight": 25.0 },
            { "reps": 15, "weight": 25.0 },
            { "reps": 15, "weight": 25.0 }
          ],
          "current_set": 0
        }
      ]
    },
    {
      "exercises": [
        {
          "name": "Bench press",
          "description": "",
          "sets": [
            { "reps": 5, "weight": 32.0 },
            { "reps": 5, "weight": 35.0 },
            { "reps": 5, "weight": 37.0 }
          ],
          "current_set": 0
        },
        {
          "name": "Dumbbell chess press",
          "description": "",
          "sets": [
            { "reps": 15, "weight": 25.0 },
            { "reps": 15, "weight": 25.0 },
            { "reps": 15, "weight": 25.0 },
            { "reps": 15, "weight": 25.0 },
            { "reps": 15, "weight": 25.0 }
          ],
          "current_set": 0
        },
        {
          "name": "Dumbbell row",
          "description": "",
          "sets": [
            { "reps": 10, "weight": 25.0 },
            { "reps": 10, "weight": 25.0 },
            { "reps": 10, "weight": 25.0 },
            { "reps": 10, "weight": 25.0 },
            { "reps": 10, "weight": 25.0 }
          ],
          "current_set": 0
        }
      ]
    },
    {
      "exercises": [
        {
          "name": "Squat",
          "description": "",
          "sets": [
            { "reps": 5, "weight": 65.0 },
            { "reps": 5, "weight": 75.0 },
            { "reps": 5, "weight": 85.0 }
          ],
          "current_set": 0
        },
        {
          "name": "Leg press",
          "description": "",
          "sets": [
            { "reps": 15, "weight": 25.0 },
            { "reps": 15, "weight": 25.0 },
            { "reps": 15, "weight": 25.0 },
            { "reps": 15, "weight": 25.0 },
            { "reps": 15, "weight": 25.0 }
          ],
          "current_set": 0
        },
        {
          "name": "Leg curl",
          "description": "",
          "sets": [
            { "reps": 10, "weight": 25.0 },
            { "reps": 10, "weight": 25.0 },
            { "reps": 10, "weight": 25.0 },
            { "reps": 10, "weight": 25.0 },
            { "reps": 10, "weight": 25.0 }
          ],
          "current_set": 0
        }
      ]
    }
  ];

  const programs = [
    {
      "current_week": 0,
      "weeks": [
        {
          "current_workout": 0,
          "workouts": [ workouts[0], workouts[1], workouts[2], workouts[3] ]
        }
      ]
    }
  ];

  return programs;
};

const { createApp, ref, reactive, computed } = Vue;

const setup = () => {
  const program = ref(api()[0]);

  const weeks = computed(() => {
    return program.value.weeks;
  });

  const current_week = computed(() => {
    return weeks.value[program.value.current_week];
  });

  const workouts = computed(() => {
    return current_week.value.workouts;
  });

  const current_workout = computed(() => {
    return workouts.value[current_week.value.current_workout];
  });

  const exercises = computed(() => {
    return current_workout.value.exercises;
  });

  const changeWeek = (event) => {
    program.value.current_week = event.target.value;
  };

  const changeWorkout = (event) => {
    current_week.value.current_workout = event.target.value;
  };

  const resetExercise = (event, exercise) => {
    exercise.current_set = 0;
  };

  const setDone = (event, exercise, setId) => {
    let next_set = setId;
    const min = 0;
    const max = exercise.sets.length;

    if (event.target.checked) {
      next_set = setId + 1;
    };

    if (next_set < min) {
      next_set = min;
    };

    if (next_set > max) {
      next_set = max;
    }

    exercise.current_set = next_set;
  };

  return {
    weeks,
    workouts,
    exercises,
    current_week,
    current_workout,
    setDone,
    changeWorkout
  };
};

createApp({ setup }).mount("#app");
