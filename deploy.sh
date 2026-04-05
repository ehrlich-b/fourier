#!/bin/bash
set -e
scp index.html root@ehrlich.dev:/var/www/fourier.ehrlich.dev/index.html
echo "Deployed to fourier.ehrlich.dev"
