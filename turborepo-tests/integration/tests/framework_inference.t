Setup
  $ . ${TESTDIR}/../../helpers/setup.sh
  $ . ${TESTDIR}/_helpers/setup_monorepo.sh $(pwd) framework_inference

Prove that we start with no inferred variables
  $ ${TURBO} run build --dry=json | jq -r '.tasks[].environmentVariables.inferred'
  []

Add in an inferred variable
  $ NEXT_PUBLIC_CHANGED=true ${TURBO} run build --dry=json | jq -c '.tasks[].environmentVariables.inferred'
  ["NEXT_PUBLIC_CHANGED=b5bea41b6c623f7c09f1bf24dcae58ebab3c0cdd90ad966bc43a45b44867e12b"]

Switch off framework inference and we no longer include inferred variables.
  $ NEXT_PUBLIC_CHANGED=true ${TURBO} run build --framework-inference=false --dry=json | jq -r '.tasks[].environmentVariables.inferred'
  []

Confirm that the right values appear in the run summary when framework inference is on.
  $ ${TURBO} run build --framework-inference=true --dry=json > output.json
  $ cat output.json | jq -r '.frameworkInference'
  true
  $ cat output.json | jq -r '.tasks[].framework'
  nextjs

Confirm that the right values appear in the run summary when framework inference is off.
  $ ${TURBO} run build --framework-inference=false --dry=json > output.json
  $ cat output.json | jq -r '.frameworkInference'
  false
  $ cat output.json | jq -r '.tasks[].framework'
  <FRAMEWORK DETECTION SKIPPED>
