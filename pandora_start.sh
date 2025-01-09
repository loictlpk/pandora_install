#!/bin/bash

source ~/venv/bin/activate
cd ~/pandora
poetry run update --yes > ~/pandora_start_script.log
