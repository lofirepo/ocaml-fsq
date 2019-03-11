open OUnit2

module Q = Fsq.Make(String)

let test_fsq _ctx =
  let q = Q.empty 3 in
  assert_equal 0 @@ Q.size q;
  let q = Q.push "a" q in
  assert_equal 1 @@ Q.size q;
  let q = Q.push "b" q in
  assert_equal 2 @@ Q.size q;
  let q = Q.push "c" q in
  assert_equal 3 @@ Q.size q;
  let q = Q.push "d" q in
  assert_equal 3 @@ Q.size q;
  assert_equal true @@ Q.mem "c" q;
  assert_equal false @@ Q.mem "a" q;
  let q =
    match Q.pop q with
    | Some (k, q) ->
       assert_equal "b" k;
       q
    | None -> q in
  assert_equal 2 @@ Q.size q;
  assert_equal true @@ Q.mem "d" q;
  assert_equal false @@ Q.mem "b" q;
  let ks = Q.to_list q in
  assert_equal 2 @@ List.length ks;
  assert_equal "c" @@ List.hd ks;
  assert_equal "d" @@ List.nth ks 1;
  let q2 = Q.of_list 3 ks in
  assert_equal 2 @@ Q.size q2;
  assert_equal true @@ Q.mem "c" q2;
  assert_equal true @@ Q.mem "d" q2

let suite =
  "suite">:::
    [
      "push">:: test_fsq;
    ]

let () =
  run_test_tt_main suite
