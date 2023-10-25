

maxim x y
  | x > y     = x
  | otherwise = y

max3 x y z = let { mxy = maxim x y ; m = maxim mxy z } in m


-- replace tabs with spaces to make this compile
max3' x y z = let mxy = maxim x y
		   m = maxim mxy z
	      in m
