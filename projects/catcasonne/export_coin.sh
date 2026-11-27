#!/usr/bin/env bash

for c in carpet silver thread black; do
    openscad -o coin_$c.stl -D "LAYER=\"$c\"" coin.scad
done