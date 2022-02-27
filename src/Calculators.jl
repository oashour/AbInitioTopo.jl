"""
Computes Z4 topological invariants given an irvsp.out file, range of bands [nstart,nend] for systems with TRS and IS
"""
function compute_Z4(myFile::String, nstart::Int64, nend::Int64)
    parity = parse_parity_from_irvsp(myFile, nstart, nend)
    # Compute the Strong Index
    nₖ⁺ = sum(x->x>0, parity, dims=1) # Compute number of +1 parity eigenvalues
    nₖ⁻ = sum(x->x<0, parity, dims=1) # Compute number of -1 parity eigenvalues
    κ = mod(1/4*sum( nₖ⁺ .- nₖ⁻), 4) # Compute κ, the Z₄ invariant
    ν₀ = mod(κ, 2)

    # Compute the Weak Indices
    nₖ₁⁺ = nₖ⁺[[2,5,6,8]]
    nₖ₁⁻ = nₖ⁻[[2,5,6,8]]
    ν₁ = mod(1/4*sum(nₖ₁⁺.- nₖ₁⁻), 2)
    nₖ₂⁺ = nₖ⁺[[3,5,7,8]]
    nₖ₂⁻ = nₖ⁻[[3,5,7,8]]
    ν₂ = mod(1/4*sum(nₖ₂⁺ .- nₖ₂⁻), 2)
    nₖ₃⁺ = nₖ⁺[[4,6,7,8]]
    nₖ₃⁻ = nₖ⁻[[4,6,7,8]]
    ν₃ = mod(1/4*sum(nₖ₃⁺.- nₖ₃⁻), 2)

    Z₄ = "Z₄ = (κ;ν₁ν₂ν₃) = ($(trunc(Int,κ));$(trunc(Int,ν₁))$(trunc(Int,ν₂))$(trunc(Int,ν₃)))"
    Z₂ = "Z₂ = (ν₀;ν₁ν₂ν₃) = ($(trunc(Int,ν₀));$(trunc(Int,ν₁))$(trunc(Int,ν₂))$(trunc(Int,ν₃))), where ν₀ = κ mod 2"
    if κ ∈ (1, 3)
        result = "strong topological insulator"
    elseif κ == 0
        result = "trivial insulator"
        if (ν₁ == 1 || ν₂ == 1 || ν₃ == 1)
            result = "weak topological insulator"
        end
    elseif κ == 2
        result = "higher-order topological insulator"
    end

    println(Z₄)
    println(Z₂)
    println("System is a $result")
end

"""
Computes Z2 topological invarilnts given an irvsp.out file, range of bands [nstart,nend] for systems with TRS and IS
"""
function compute_Z2(myFile::String, nstart::Int64, nend::Int64)
    parity = parse_parity_from_irvsp(myFile, nstart, nend)
    δ = ones(8)
    for n = 1:2:(nend-nstart+1)
        δ .*= parity[n, :]
    end
    minus1_ν₀ = prod(δ)
    minus1_ν₁ = prod(δ[[2,5,6,8]])
    minus1_ν₂ = prod(δ[[3,5,7,8]])
    minus1_ν₃ = prod(δ[[4,6,7,8]])
    ν₀ = minus1_ν₀ == 1 ? 0 : 1
    ν₁ = minus1_ν₁ == 1 ? 0 : 1
    ν₂ = minus1_ν₂ == 1 ? 0 : 1
    ν₃ = minus1_ν₃ == 1 ? 0 : 1
    if ν₀ == 1
        result = "strong topological insulator"
    elseif ν₀ == 0
        result = "trivial insulator"
        if (ν₁ == 1 || ν₂ == 1 || ν₃ == 1)
            result = "weak topological insulator"
        end
    end
    Z₂ = "Z₂ = (ν₀;ν₁ν₂ν₃) = ($(trunc(Int,ν₀));$(trunc(Int,ν₁))$(trunc(Int,ν₂))$(trunc(Int,ν₃)))"
    println(Z₂)
    println("System is a $result")
end