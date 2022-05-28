for (f,df,ddf) in f_nargs_1
    @eval $f(e::E) where {E <: Expression} = Expression1($f,e)
end



for (f,df1,df2,ddf11,ddf12,ddf22) in f_nargs_2
    @eval begin
        $f(e1::E1,e2::E2) where {E1 <: Expression,E2 <: Expression} =
            Expression2($f,e1,e2)
        $f(e1::E1,e2::E2) where {E1 <: Expression,E2 <: Real} =
            Expression2($f,e1,e2)
        $f(e1::E1,e2::E2) where {E1 <: Real,E2 <: Expression} =
            Expression2($f,e1,e2)
    end
end


add_sum(e1::E,e2) where {T <: AbstractFloat, E <: Expression{T}} = add_sum(ExpressionSum([e1]),e2)
add_sum(e1::ExpressionSum{T,E,I},e2) where {T,E,I} = _add_sum(e1,e2) ? e1 : ExpressionSum(e1,[e2])
function _add_sum(e1::ExpressionSum{T,E,I},e2) where {T,E,I}
    if e2 isa eltype(e1.es)
        push!(e1.es,e2)
        return true
    else
        return _add_sum(inner(e1),e2)
    end
end
function _add_sum(e1::ExpressionSum{T,E,Nothing},e2) where {T,E}
    if e2 isa eltype(e1.es)
        push!(e1.es,e2)
        return true
    else
        return false
    end
end
