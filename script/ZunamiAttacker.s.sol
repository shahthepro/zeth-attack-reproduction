// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {ZunamiAttacker} from "../src/ZunamiAttacker.sol";

contract ZunamiAttackeScript is Script {
    ZunamiAttacker public zunamiAttacker;

    function setUp() public {
        zunamiAttacker = new ZunamiAttacker();
    }

    function run() public {
        zunamiAttacker.attack();
    }
}
