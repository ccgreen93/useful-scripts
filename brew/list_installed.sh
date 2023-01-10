#!/bin/bash

brew leaves | xargs -n1 brew desc --eval-all
