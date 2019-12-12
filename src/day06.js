var fs = require('fs');

const orbit2Object = (orbits, orbit) => {
  let bodies = orbit.split(")");

  orbits[bodies[1]] = bodies[0];

  return orbits;
};

const countDepth = (orbitMap, orbit) => {
  let parentOrbit = orbitMap[orbit];

  if (parentOrbit in orbitMap) {
    return 1 + countDepth(orbitMap, parentOrbit);
  }

  return 1;
};

const orbitChain = (orbitMap, orbit) => {
  let parentOrbit = orbitMap[orbit];

  if (parentOrbit in orbitMap) {
    return orbitChain(orbitMap, parentOrbit).concat([orbit]);
  }

  return [orbit];
};

const commonOrbitDistance = (orbitMap, orbit1, orbit2) => {
  let orbitChain1 = orbitChain(orbitMap, orbit1);
  let orbitChain2 = orbitChain(orbitMap, orbit2);
  let orbitPairs = zip(orbitChain1 , orbitChain2);
  orbitPairs = orbitPairs.filter(pair => pair[0] !== pair[1] );
  return orbitPairDepth(orbitPairs, orbit1) + orbitPairDepth(orbitPairs, orbit2);
};

const orbitPairDepth = (orbitPairs, orbit) => {
  if (orbit === orbitPairs[0][0] || orbit === orbitPairs[0][1]) {
    return 0;
  }
  return 1 + orbitPairDepth(orbitPairs.slice(1), orbit);
};

const zip = (arr1, arr2) => arr1.map((k, i) => [k, arr2[i]]);

let orbitMap = fs.readFileSync("./input06.txt").toString().split("\n").reduce(orbit2Object, {});
let orbitCount = Object.keys(orbitMap).reduce((sum, orbit) => sum + countDepth(orbitMap, orbit), 0);

console.log("Part 1: " + orbitCount.toString());

let distance = commonOrbitDistance(orbitMap, "YOU", "SAN");

console.log("Part 2: " + distance.toString());
