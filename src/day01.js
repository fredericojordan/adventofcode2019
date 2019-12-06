var assert = require('assert');
var fs = require('fs');

const FuelReq = (mass) => Math.floor(mass/3)-2;

const FuelReqRecursive = (mass) => {
  let fuel = FuelReq(mass);
  if (fuel <= 0) return 0;
  return fuel + FuelReqRecursive(fuel);
};

assert.equal(FuelReq(12), 2);
assert.equal(FuelReq(14), 2);
assert.equal(FuelReq(1969), 654);
assert.equal(FuelReq(100756), 33583);

assert.equal(FuelReqRecursive(14), 2);
assert.equal(FuelReqRecursive(1969), 966);
assert.equal(FuelReqRecursive(100756), 50346);

var module_mass_list = fs.readFileSync("./input01.txt").toString().trim();
module_mass_list = module_mass_list.split("\n");
module_mass_list = module_mass_list.map(item => parseInt(item, 10));

let fuel_list = module_mass_list.map(FuelReq);
fuel_list = fuel_list.reduce( (acc, item) => item + acc, 0 );

console.log("Part 1: " + fuel_list.toString());

let complete_fuel_list = module_mass_list.map(FuelReqRecursive);
complete_fuel_list = complete_fuel_list.reduce( (acc, item) => item + acc, 0 );

console.log("Part 2: " + complete_fuel_list.toString());
