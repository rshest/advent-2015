import fs = require('fs');

const file = process.argv[2] || 'input.txt';
const input = fs.readFileSync(file).toString();
const len = x => x ? x.length : 0;

function isNice1(s: string) : boolean {
  const cond1 = len(s.match(/[aeiou]/g)) >= 3;
  const cond2 = len(s.match(/(.)\1/g)) > 0;
  const cond3 = len(s.match(/(ab|cd|pq|xy)/g)) == 0;
  return cond1 && cond2 && cond3;
}

function isNice2(s: string) : boolean {
  const cond1 = len(s.match(/(..).*\1/g)) > 0;
  const cond2 = len(s.match(/(.).\1/g)) > 0;
  return cond1 && cond2;
}

function countNice(input: string, criteria: (s: string) => boolean) {
  return input.split(/\r?\n/)
    .filter(s => s.length > 0)
    .filter(criteria)
    .length;
}

console.log(`Number of nice strings: ${countNice(input, isNice1)}`);
console.log(`Number of nice strings: ${countNice(input, isNice2)}`);

