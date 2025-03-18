using Suppressor

function set_working_directory()
    path = split(pwd(), "\\")

    if path[end] == "household"
        return true
    end

    if path[end] == "windc_build"
        cd("household")
        return true
    end

    return false
    
end

function run_household(year, household, invest, capital, region, sector)
    set_working_directory()
    @suppress run(`gams build.gms --hhdata $household --year $year --invest $invest --capital_ownership $capital --rmap $region --smap $sector`)
end


function test_household_instance(year, household, invest, capital, region, sector)
    output = "$household - $year, $invest, $capital, $region, $sector"
    println(output)
    try
        run_household(y, household, i, c, r, s)
    catch e
        open(log_file, "a") do io
            write(io, "$output\n")
        end
    end
end


function test_household()
    set_working_directory()

    log_file = "household.log"

    #if isfile(log_file)
    #    rm(log_file)
    #end
    touch(log_file)

    cps_years = 2000:2023
    soi_years = 2014:2017
    investments = ["static", "dynamic"]
    capital_ownership = ["all", "partial"]
    regoinal_mapping = ["state", "census_divisions", "census_regions", "national"]
    sectoral_mapping = ["windc", "gtap_32", "sage", "gtap_10", "macro", "bluenote"]

    
    for (y,i,c,r,s) in Iterators.product(cps_years, investments, capital_ownership, regoinal_mapping, sectoral_mapping) 
        test_household_instance(y, "cps", i, c, r, s)
    end
    

    for (y,i,c,r,s) in Iterators.product(soi_years, investments, capital_ownership, regoinal_mapping, sectoral_mapping) 
        test_household_instance(y, "soi", i, c, r, s)
    end

end


test_household()