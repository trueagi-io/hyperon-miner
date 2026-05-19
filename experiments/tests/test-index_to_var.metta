! (register-module! ../../../hyperon-miner)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self hyperon-miner:experiments:utils:index_to_var)

!(assertEqual (replace (,(, (link $x $y) (an $o $y)) (this $x $t))) (, (, (link Z (S Z)) (an (S (S Z)) (S Z))) (this Z (S (S (S Z))))))
!(assertEqual (replacev (Inheritance (LINK Z (S Z)) (S (S Z)))) (Inheritance (LINK $var0 $var1) $var2))