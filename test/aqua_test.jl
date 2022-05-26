using Test
using PolyBr
using Aqua

@testset "Aqua tests" begin
    Aqua.test_all(PolyBr; project_extras = false)
end