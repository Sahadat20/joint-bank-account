const { buildModule, deployModule } = require("@nomicfoundation/hardhat-ignition");

const JAN_1ST_2030 = 1893456000;
const ONE_GWEI = 1_000_000_000n;

const LockModule = buildModule("LockModule", (m) => {
  const unlockTime = m.getParameter("unlockTime", JAN_1ST_2030);
  const lockedAmount = m.getParameter("lockedAmount", ONE_GWEI);

  const lock = m.contract("BankAccount", [], {
    value: lockedAmount,
  });

  return { lock };
});

async function main() {
  const deploymentResult = await deployModule(LockModule, {
    parameters: {
      unlockTime: JAN_1ST_2030,
      lockedAmount: ONE_GWEI,
    },
  });

  console.log("Contract deployed at address:", deploymentResult.lock.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});