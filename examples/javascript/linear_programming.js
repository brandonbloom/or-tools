#!/usr/bin/env node
// Copyright 2010-2018 Google LLC
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Linear optimization example.

// XXX const lp = require('ortools/linear_solver');
const lp = require('linear_solver');

const main = () => {
  // Instantiate a Glop solver, naming it LinearExample.
  const solver = new lp.Solver('LinearExample', lp.Solver.GLOP_LINEAR_PROGRAMMING);

  // Create the two variables and let them take on any value.
  const x = solver.NumVar(-Infinity, Infinity, 'x');
  const y = solver.NumVar(-Infinity, Infinity, 'y');

  // Objective function: Maximize 3x + 4y.
  const objective = solver.Objective();
  objective.SetCoefficient(x, 3);
  objective.SetCoefficient(y, 4);
  objective.SetMaximization();

  // Constraint 0: x + 2y <= 14.
  constraint0 = solver.Constraint(-Infinity, 14);
  constraint0.SetCoefficient(x, 1);
  constraint0.SetCoefficient(y, 2);

  // Constraint 1: 3x - y >= 0.
  constraint1 = solver.Constraint(0, Infinity);
  constraint1.SetCoefficient(x, 3);
  constraint1.SetCoefficient(y, -1);

  // Constraint 2: x - y <= 2.
  constraint2 = solver.Constraint(-Infinity, 2);
  constraint2.SetCoefficient(x, 1);
  constraint2.SetCoefficient(y, -1);

  console.log('Number of variables =', solver.NumVariables());
  console.log('Number of constraints =', solver.NumConstraints());

  // Solve the system.
  const status = solver.Solve()
  // Check that the problem has an optimal solution.
  if (status !== lp.Solver.OPTIMAL) {
    console.log("The problem does not have an optimal solution!");
    process.exit(1);
  }

  console.log('Solution:');
  console.log('x =', x.solution_value());
  console.log('y =', y.solution_value());
  console.log('Optimal objective value =', objective.Value());
  console.log('');
  console.log('Advanced usage:');
  console.log('Problem solved in ', solver.wall_time(), ' milliseconds');
  console.log('Problem solved in ', solver.iterations(), ' iterations');
  console.log('x: reduced cost =', x.reduced_cost());
  console.log('y: reduced cost =', y.reduced_cost());
  const activities = solver.ComputeConstraintActivities(); // XXX indexing.
  console.log(
    'constraint0: dual value =',
    constraint0.dual_value(),
    ' activities =',
    activities[constraint0.index()],
  );
  console.log(
    'constraint1: dual value =',
    constraint1.dual_value(),
    ' activities =',
    activities[constraint1.index()]
  );
  console.log(
    'constraint2: dual value =',
    constraint2.dual_value(),
    ' activities =',
    activities[constraint2.index()]
  );
};

main();
