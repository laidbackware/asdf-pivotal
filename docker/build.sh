#!/bin/bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker build $script_dir -t laidbackware/asdf-tools-test:v1

docker push laidbackware/asdf-tools-test:v1

