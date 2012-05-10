#!/bin/bash
# dummy script
# Exemple of how to get the directory containing the current script


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo $DIR contains the directory where this script is running
