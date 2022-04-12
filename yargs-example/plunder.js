#!/usr/bin/env node

const yargs = require("yargs/yargs");
const {hideBin} = require("yargs/helpers");
//hideBin is a shorthand for process.argv.slice(2). 
//see https://nodejs.org/en/knowledge/command-line/how-to-parse-command-line-arguments/
const argv = yargs(hideBin(process.argv)).argv;


if (argv.ships > 3 && argv.distance < 53.5) {
    console.log('Plunder more riffiwobbles!')
  } else {
    console.log('Retreat from the xupptumblers!')
}