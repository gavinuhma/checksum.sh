# checksum.sh - Verify Every Install Script

![checksum.sh](./checksum.sh.png?raw=true "checksum.sh Logo")

Checksum.sh is a simple way to download, review, and verify install scripts. If the checksum is OK the script will be printed to stdout, which can be piped to `sh` or elsewhere. If the checksum doesn't match it produces an error and nothing is piped. [View the code on GitHub](https://github.com/gavinuhma/checksum.sh).

For example, to install Rust:
```bash
checksum https://sh.rustup.rs 8327fa6ce106d2a387fdd02cb95c3607193c2edb | sh
```

In contrast to Rust's usual installation which doesn't verify the checksum:
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

# Install

**Option 1: Define the checksum function directly**

Paste the following into your command line to define the `checksum` function.

```bash
function checksum() {
  local s
  s=$(curl -fsSL "$1")
  local h
  if command -v shasum >/dev/null ; then
    h=shasum
  else
    h=sha1sum
  fi
  if [ ! "$2" ] ; then
    printf %s\\n "$s" | "$h" | awk '{print $1}'
    return 1;
  fi
  printf %s\\n "$s" | "$h" --check --status <(printf '%s  -\n' "$2") || {
    echo "checksum failed" >&2;
    return 1;
  }
  printf %s\\n "$s"
}
```

**Option 2: Download the script**

Alternatively, you can download, review and verify the [checksum.sh script](https://github.com/gavinuhma/checksum.sh/blob/main/checksum.sh):
```bash
curl -O https://checksum.sh/checksum.sh
cat checksum.sh
echo "df260dd53581e6e30c0afbe32b80db6b0bec2d07  checksum.sh" | shasum -c
```

If everything is OK, you can source the script which will define the `checksum` function.
```bash
source checksum.sh
```

# Use
To download and verify a script pass the URL and the CHECKSUM:

`checksum <URL> <CHECKSUM>`

The script will be printed out by default so you can inspect it.

If you're happy with it, you can pipe the script to `sh` to execute it:

`checksum <URL> <CHECKSUM> | sh`

If you just want to calculate the checksum for a URL you can omit the CHECKSUM:

`checksum <URL>`

# Examples

_Note: If any of these install scripts have changed these commands will error because the checksum will be invalid._

### Install [Rust](https://www.rust-lang.org/tools/install)

```bash
checksum https://sh.rustup.rs 8327fa6ce106d2a387fdd02cb95c3607193c2edb | sh
```

### Install [Cape](https://docs.capeprivacy.com/getting-started/)

```bash
checksum https://raw.githubusercontent.com/capeprivacy/cli/main/install.sh 2309498bc07fbca42d421f696a605da15d99d939 | sh
```

### Install [Nitrogen](https://github.com/capeprivacy/nitrogen)

```bash
checksum https://raw.githubusercontent.com/capeprivacy/nitrogen/main/install.sh 8012d9e1d1420942f0ae6955fc99c790d52e9c3e | sh
```

### Install [Nix](https://nixos.org/download.html)

```bash
checksum https://nixos.org/nix/install 84b31e0093aaa169c1f580c2fbe2397d059d1983 | sh
```

### Install [Deno](https://deno.land/#installation)
```bash
checksum https://deno.land/install.sh 57a4d67e64d2a7204541b9e131cedb289a79e834 | sh
```
