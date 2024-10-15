mkdir summary
gams symmetric --suffix="_" --mkt=national  o=summary\national.lst gdx=summary\national.gdx
gams symmetric --suffix="_" --mkt=census    o=summary\census.lst   gdx=summary\census.gdx
gams symmetric --suffix="_" --mkt=state     o=summary\state.lst    gdx=summary\state.gdx

mkdir detailed
gams symmetric --suffix=" " --mkt=national  o=detailed\national.lst gdx=detailed\national.gdx
gams symmetric --suffix=" " --mkt=census    o=detailed\census.lst   gdx=detailed\census.gdx
gams symmetric --suffix=" " --mkt=state     o=detailed\state.lst    gdx=detailed\state.gdx
