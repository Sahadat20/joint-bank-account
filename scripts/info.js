const fs = require('fs');
const path = require('path');

async function getDeploymentInfo() {
  const deploymentsDir = path.join(__dirname, 'deployments', 'localhost');
  const deploymentFile = path.join(deploymentsDir, 'BankAccount.json');

  if (fs.existsSync(deploymentFile)) {
    const deployment = JSON.parse(fs.readFileSync(deploymentFile, 'utf8'));
    console.log("Contract deployed at address:", deployment.address);
  } else {
    console.error("Deployment file not found");
  }
}

getDeploymentInfo().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});