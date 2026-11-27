#!/usr/bin/env bash

for g in fish feather mouse; do
    openscad -o goods_$g.stl -D "TOKEN=\"$g\"" goods.scad
done