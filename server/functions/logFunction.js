// Middleware for logging
function logStart(apiName) {
  console.log(
    `\x1b[32m----------------- ${apiName} is triggered -----------------\x1b[0m`
  );
  console.log("");
}
// Middleware for logging
function logEnd(apiName) {
  console.log(
    `\x1b[32m-----------------  ${apiName} is Successfully completed -----------------\x1b[0m`
  );
  console.log("");
}
// Middleware for error handling
function handleError(res, e) {
  console.log(
    "\x1b[31m -----------------There is an issue -----------------\x1b[0m"
  );
  console.log(e);
  res.status(500).json({ error: e.message });
}

module.exports = { logStart, logEnd, handleError };
