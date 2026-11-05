const assert = require('node:assert/strict');
const { spawnSync } = require('node:child_process');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { after, test } = require('node:test');

const script = path.resolve(__dirname, '../scripts/start-server.sh');
const testHome = fs.mkdtempSync(path.join(os.tmpdir(), 'dotfiles-brainstorm-cli-'));
after(() => fs.rmSync(testHome, { recursive: true, force: true }));

function rejectArguments(args, message) {
  const result = spawnSync('bash', [script, ...args], {
    encoding: 'utf8',
    timeout: 10000,
    env: {
      ...process.env,
      HOME: testHome,
      XDG_CONFIG_HOME: path.join(testHome, '.config'),
      XDG_DATA_HOME: path.join(testHome, '.local/share'),
      XDG_STATE_HOME: path.join(testHome, '.local/state'),
      XDG_CACHE_HOME: path.join(testHome, '.cache'),
    },
  });
  assert.ifError(result.error);
  assert.equal(result.status, 1);
  assert.equal(result.stderr, '');
  assert.deepEqual(JSON.parse(result.stdout), { error: message });
  assert.deepEqual(fs.readdirSync(testHome), []);
}

for (const option of ['--project-dir', '--host', '--url-host', '--idle-timeout-minutes']) {
  test(`${option} rejects a missing value`, () => {
    rejectArguments([option], `${option} requires a value`);
  });
  test(`${option} rejects an empty value`, () => {
    rejectArguments([option, '', '--invalid-fixture'], `${option} requires a value`);
  });
  test(`${option} rejects the following option as a value`, () => {
    rejectArguments([option, '--foreground', '--invalid-fixture'], `${option} requires a value`);
  });
}

test('unknown arguments preserve quotes, backslashes and control characters in JSON', () => {
  const argument = '--unknown="quoted"\\path\n\t\r\u0001';
  rejectArguments([argument], `Unknown argument: ${argument}`);
});

test('valid option values and switches are parsed before a later error', () => {
  rejectArguments([
    '--project-dir', path.join(testHome, 'a project'), '--host', '127.0.0.1',
    '--url-host', 'localhost', '--idle-timeout-minutes', '1',
    '--open', '--foreground', '--background', '--invalid-fixture',
  ], 'Unknown argument: --invalid-fixture');
});

for (const value of ['0', '-1', '1.5', 'invalid']) {
  test(`invalid idle timeout ${value} fails before creating session state`, () => {
    rejectArguments(['--idle-timeout-minutes', value], '--idle-timeout-minutes must be a positive integer');
  });
}
