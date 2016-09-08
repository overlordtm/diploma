## Funkcionalni kriptosistemi

* `(pp, mk) = Setup`
    * Ustvarimo javni kljuc `pp`
    * Ustvarimo glavni kljuc `mk`
* `sk = Keygen(mk, k)`
    * Ustvarimo zasebni ključ `sk`
* `c = Enc(pp, x)`
    * Šifriranje sporočila (čistopisa) `x`
* `y = Dec(sk, c)`
    * Dešifriranje nam vrne funkcijo čistopisa `y=F(k, x)`

