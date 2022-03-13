rm -f *.fst.checked
OPTIONS="--cache_checked_modules --silent"
echo AlgebraTypes
fstar.exe AlgebraTypes.fst ${OPTIONS}
echo Fraction Definition
fstar.exe Fractions.Definition.fst ${OPTIONS}
echo Fraction Equivalence
fstar.exe Fractions.Equivalence.fst ${OPTIONS}
echo Fraction Addition
fstar.exe Fractions.Addition.fst ${OPTIONS}
echo Fraction Multiplication
fstar.exe Fractions.Multiplication.fst ${OPTIONS}
echo Fraction Field
fstar.exe Fractions.fst ${OPTIONS}
echo FStar.IntegerIntervals
fstar.exe FStar.IntegerIntervals.fst ${OPTIONS}
echo FStar.Algebra.CommMonoid.Fold
fstar.exe FStar.Algebra.CommMonoid.Fold.fst ${OPTIONS}
echo FStar.Seq.Matrix
fstar.exe FStar.Seq.Matrix.fst ${OPTIONS}
echo FStar.Algebra.CommMonoid.Fold.Nested
fstar.exe FStar.Algebra.CommMonoid.Fold.Nested.fst ${OPTIONS}
echo Poly Definitions
fstar.exe Polynomials.Definition.fst ${OPTIONS}
echo Poly Equivalence
fstar.exe Polynomials.Equivalence.fst ${OPTIONS}
echo Poly Compact
fstar.exe Polynomials.Compact.fst ${OPTIONS}
echo Poly Addition
fstar.exe Polynomials.Addition.fst ${OPTIONS}