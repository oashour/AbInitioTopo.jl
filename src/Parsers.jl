"""
Parses parity eigenvalues given an irvsp output file.
It will read the eigenvalues starting from band `nstart` until band `nend`.
`nstart` should be odd and `nend` should be even.
"""
function parse_parity_from_irvsp(file, nstart, nend)
    s = open(file) do file
        s = read(file, String)
    end

    split_file = split(s,"********************************************************************************")[2:end]
    num_k = length(split_file) 

    parity = zeros(nend-nstart+1, num_k)

    for (nk,split_string) in enumerate(split_file)
        p = Float64[]
        irreps = split(split_string, "\nbnd ndg  eigval     E           I   \n")[2]
        irreps = split(irreps,"\n")
        for (nl, line) in enumerate(irreps)
            nb = parse(Float64, split(lstrip(line), " ")[1])
            if nb > nend
                break
            elseif nb < nstart
                continue 
            end
            newline = split(line, "=")[end] # Extract the irreps in the form, e.g.,  (G2+ + G2+ + G2+ + G2+)
            if !isempty(newline) && isdigit(lstrip(newline)[1])
                throw(ArgumentError("Irrep was not computed for band $nb at kpoint $nk. This usually happens with conduction bands or deep valence bands. Set nend and nstart to exclude them."))
            end
            # This gives an array of strings, each of which is a single irrep
            irreps_parsed = split(newline, " + ") 
            mult = length(irreps_parsed) # The multiplicity
            for i=1:mult
                append!(p, parse(Float64, string(irreps_parsed[i][3],"1")))
            end
        end
        parity[:, nk] = p
    end

    return parity

end