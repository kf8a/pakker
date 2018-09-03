
defmodule Signaturetest do
  use ExUnit.Case

  test 'compute seed for "A" ' do
    assert 43_669 == Pakker.Signature.compute_next_sig(0xaaaa , 0xaaaa, 65)
  end

  test 'compute seed for "B" ' do
    assert 43_670 == Pakker.Signature.compute_next_sig(0xaaaa , 0xaaaa, 66)
  end

  test 'compute null' do
    assert 86 == Pakker.Signature.compute_null(0xdd, 0xaaa)
  end

  test 'compute signature for empty message' do
    assert 0xAAAA == Pakker.Signature.calc_sig('', 0xAAAA)
  end

  test 'compute signature for "b" message' do
    assert 43_617 == Pakker.Signature.calc_sig('b', 0xAAAA)
  end

  test 'compute signature for "ab" message' do
    assert 24_780 == Pakker.Signature.calc_sig('ab', 0xAAAA)
  end

  test 'compute signature for "message" ' do
    assert 0x1a17 == Pakker.Signature.calc_sig('message', 0xAAAA)
  end

  test 'increment low seed' do
    assert 1 = Pakker.Signature.increment_seed(1)
  end

  test 'increment hight seed' do
    assert 0x102 = Pakker.Signature.increment_seed(0x101)
  end

  test 'compute signature for "testing"' do
    assert 0x1ef5 == Pakker.Signature.calc_sig('testing', 0xAAAA)
  end

  test 'compute signature nullifer bytes' do
    assert << 0xb8, 0xe9>> == Pakker.Signature.calc_sig_nullifier(0x1a17)
  end

  test 'compute signature for packet' do
    message = << 0x90, 0x01, 0x0f, 0x71 >>
    signature = Pakker.Signature.calc_sig(:erlang.binary_to_list(message), 0xAAAA)
    assert 13_217 == signature
  end

  test 'compute signature nullifer byte for packet' do
    # assert <<0x71, 0xd2 >> == Pakker.Signature.calc_sig_nullifier(13217)
    assert <<0x8a, 95 >> == Pakker.Signature.calc_sig_nullifier(13_217)
  end
end
