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

console.log({lp}); // XXX

const main = () => {
  // Instantiate a Glop solver, naming it LinearExample.
  const solver = new lp.Solver('LinearExample', lp.Solver.GLOP_LINEAR_PROGRAMMING);

  // Create the two variables and let them take on any value.
  // XXX const x = new solver.NumVar(-solver.infinity(), solver.infinity(), 'x')
  // XXX const y = new solver.NumVar(-solver.infinity(), solver.infinity(), 'y')

  // Objective function: Maximize 3x + 4y.
// XXX  const objective = new solver.Objective()
// XXX    objective.SetCoefficient(x, 3)
// XXX    objective.SetCoefficient(y, 4)
// XXX    objective.SetMaximization()
// XXX
// XXX    # Constraint 0: x + 2y <= 14.
// XXX    constraint0 = solver.Constraint(-solver.infinity(), 14)
// XXX    constraint0.SetCoefficient(x, 1)
// XXX    constraint0.SetCoefficient(y, 2)
// XXX
// XXX    # Constraint 1: 3x - y >= 0.
// XXX    constraint1 = solver.Constraint(0, solver.infinity())
// XXX    constraint1.SetCoefficient(x, 3)
// XXX    constraint1.SetCoefficient(y, -1)
// XXX
// XXX    # Constraint 2: x - y <= 2.
// XXX    constraint2 = solver.Constraint(-solver.infinity(), 2)
// XXX    constraint2.SetCoefficient(x, 1)
// XXX    constraint2.SetCoefficient(y, -1)
// XXX
// XXX    print('Number of variables =', solver.NumVariables())
// XXX    print('Number of constraints =', solver.NumConstraints())
// XXX
// XXX    # Solve the system.
// XXX    status = solver.Solve()
// XXX    # Check that the problem has an optimal solution.
// XXX    if status != pywraplp.Solver.OPTIMAL:
// XXX        print("The problem does not have an optimal solution!")
// XXX        exit(1)
// XXX
// XXX    print('Solution:')
// XXX    print('x =', x.solution_value())
// XXX    print('y =', y.solution_value())
// XXX    print('Optimal objective value =', objective.Value())
// XXX    print('')
// XXX    print('Advanced usage:')
// XXX    print('Problem solved in ', solver.wall_time(), ' milliseconds')
// XXX    print('Problem solved in ', solver.iterations(), ' iterations')
// XXX    print('x: reduced cost =', x.reduced_cost())
// XXX    print('y: reduced cost =', y.reduced_cost())
// XXX    activities = solver.ComputeConstraintActivities()
// XXX    print('constraint0: dual value =',
// XXX          constraint0.dual_value(), ' activities =',
// XXX          activities[constraint0.index()])
// XXX    print('constraint1: dual value =',
// XXX          constraint1.dual_value(), ' activities =',
// XXX          activities[constraint1.index()])
// XXX    print('constraint2: dual value =',
// XXX          constraint2.dual_value(), ' activities =',
// XXX          activities[constraint2.index()])
};

main();
