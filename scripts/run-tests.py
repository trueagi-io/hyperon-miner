import subprocess
import pathlib
import sys
import shutil
from concurrent.futures import ThreadPoolExecutor, as_completed

# ------------------------------
# Configuration
# ------------------------------

MAX_WORKERS = 2          # Safe for GitHub Actions
TEST_TIMEOUT = 300       # Seconds per test (5 minutes)

# Colors
RESET = "\033[0m"
GREEN = "\033[92m"
RED = "\033[91m"
YELLOW = "\033[93m"
CYAN = "\033[96m"

# ------------------------------
# Helpers
# ------------------------------

def print_header(text):
    print(CYAN + "\n" + "=" * 60)
    print(text)
    print("=" * 60 + RESET)


def extract_and_print(result, path, idx):
    output = result.stdout or result.stderr or ""
    text = output.strip()

    failed = result.returncode != 0 or "❌" in text

    print(YELLOW + f"\nTest {idx + 1}: {path}" + RESET)
    print((RED if failed else GREEN) +
          ("FAILED" if failed else "PASSED") +
          RESET)
    print(YELLOW + f"Exit code: {result.returncode}" + RESET)

    if failed:
        print(RED + "Output:" + RESET)
        print(text[:3000])  # Avoid huge logs

    return failed


def run_test_file(test_file):
    run_sh = shutil.which("run.sh")
    if not run_sh:
        raise RuntimeError("❌ run.sh not found in PATH")

    try:
        result = subprocess.run(
            [run_sh, str(test_file)],
            capture_output=True,
            text=True,
            timeout=TEST_TIMEOUT
        )
        return result, test_file

    except subprocess.TimeoutExpired:
        class TimeoutResult:
            returncode = -1
            stdout = ""
            stderr = f"⏰ Timeout after {TEST_TIMEOUT}s"

        return TimeoutResult(), test_file

    except Exception as e:
        class ErrorResult:
            returncode = -1
            stdout = ""
            stderr = str(e)

        return ErrorResult(), test_file


# ------------------------------
# Main
# ------------------------------

print_header("Parallel Petta Test Runner")

allowed_tests = {
    "test-isurp-old.metta",
    "test-common-utils.metta",
    "test-isurp.metta",
    "test-est-tv.metta",
    "test-surp.metta",
    "test-emp-tv.metta",
    "test-jsd.metta",
    "test-pattern-miner.metta"
}

root = pathlib.Path("../")
test_files = sorted(
    f for f in root.rglob("test-*.metta")
    if f.name in allowed_tests
)

if not test_files:
    print(YELLOW + "⚠️  No whitelisted tests found." + RESET)
    sys.exit(0)

total = len(test_files)
fails = 0
failed_tests = []

print(CYAN + f"Running {total} tests with {MAX_WORKERS} workers...\n" + RESET)

with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
    futures = {
        executor.submit(run_test_file, test): idx
        for idx, test in enumerate(test_files)
    }

    for future in as_completed(futures):
        idx = futures[future]
        result, path = future.result()
        if extract_and_print(result, path, idx):
            fails += 1
            failed_tests.append(str(path))

# ------------------------------
# Summary
# ------------------------------

print_header("Test Summary")
print(f"Total: {total}")
print(GREEN + f"Passed: {total - fails}" + RESET)
print(RED + f"Failed: {fails}" + RESET)

if fails:
    print(RED + "\nFailed tests:" + RESET)
    for f in failed_tests:
        print(" -", f)
    sys.exit(1)

print(GREEN + "\n✅ All tests passed!" + RESET)
sys.exit(0)
