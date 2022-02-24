(*
   Copyright 2008-2022 Microsoft Research
   
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at
   
       http://www.apache.org/licenses/LICENSE-2.0
       
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

   Author: A. Rozanov
*)
module FStar.IntegerIntervals
 
(* Aliases to all kinds of integer intervals *)

(* Special case for naturals under k, to use in sequences, lists, arrays, etc *)
type under (k: nat) = x:nat{x<k}

(* general infinite integer intervals *)
type less_than (k: int) = x:int{x<k}
type greater_than (k: int) = x:int{x>k}
type not_less_than (x: int) = greater_than (x-1)
type not_greater_than (x: int) = less_than (x+1)

(* Type coercion. While supposed to be absolutely trivial, 
   might still be invoked directly under extremely low rlimits *)
let coerce_to_less_than #n (x: not_greater_than n) : less_than (n+1) = x
let coerce_to_not_less_than #n (x: greater_than n) : not_less_than (n+1) = x

let interval_condition (x: int) (y: not_less_than x) t = (x <= t) && (t < y)

type interval_type (x:int) (y: not_less_than x) 
  = z : Type0{ z == t:int{interval_condition x y t} }

(* Default interval is half-open, which is the most frequently used case *) 
type interval (x: int) (y: not_less_than x) : interval_type x y 
  = t:int{interval_condition x y t}

(* general finite integer intervals *)
type efrom_eto (x: int) (y: greater_than x) = interval (x+1) y
type efrom_ito (x: int) (y: not_less_than x) = interval (x+1) (y+1)
type ifrom_eto (x: int) (y: not_less_than x) = interval x y
type ifrom_ito (x: int) (y: not_less_than x) = interval x (y+1)

(* If we define our intervals this way, then the following lemma comes for free: *)
private let closed_interval_lemma (x:int) (y: not_less_than x) 
  : Lemma (interval x (y+1) == ifrom_ito x y) = ()

(* when we want a zero-based index that runs over an interval, we use this *)
type counter_for (#x:int) (#y: not_less_than x) (interval: interval_type x y) = under (y-x)

(* how many numbers fall into an interval? *)
let interval_size (#x: int) (#y: not_less_than x) (interval: interval_type x y) : nat = y-x

(* special case for closed intervals, used in FStar.Algebra.CommMonoid.Fold *)
let closed_interval_size (x: int) (y: not_less_than x) : nat = interval_size (ifrom_ito x y)

(* A usage example and a test at the same time: *)
private let _ = assert (interval_size (interval 5 10) = 5)
private let _ = assert (interval_size (ifrom_ito 5 10) = 6)

(* This lemma, especially when used with forall_intro, helps the 
   prover verify the index ranges of sequences that correspond 
   to arbitrary folds. 

   It is supposed to be invoked to decrease the toll we put on rlimit,
   i.e. will be redundant in most use cases. *)
let counter_bounds_lemma (x:int) (y: not_less_than x) (i: (counter_for (ifrom_ito x y))) 
  : Lemma (x+i >= x /\ x+i <= y) = ()
