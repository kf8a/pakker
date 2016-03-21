
defmodule Pakker.Signature do
  use Bitwise

  def calc_sig_nullifier(byte, sig) do
    sig = calc_sig(byte, sig)
    sig2 = band((sig <<< 1), 0x1ff)
    sig2 = increment_seed(sig2)
    compute_null(sig, sig2)
  end

  def calc_sig_nullifier(sig) do
    null1 = calc_sig_nullifier('', sig)
    null2 = calc_sig_nullifier([null1], sig)

    <<null1, null2>>
  end

  def calc_sig([byte | tail], sig) do
    x = ord(byte)
    j = sig
    sig = band((sig <<< 1), 0x1ff)
    |> increment_seed()
    |> compute_next_sig(j, x)
    calc_sig(tail, sig)
  end

  def calc_sig([], sig) do
    sig
  end

  def ord(byte) when is_binary(byte) do
    :binary.decode_unsigned(byte)
  end

  def ord(byte) do
    byte
  end

  def compute_null(sig, seed) do
    band(0x0100 - (seed + (sig >>> 8 )), 0xff)
  end

  def increment_seed(seed) when seed >= 0x100 do
    band(seed + 1, 0xffff)
  end

  def increment_seed(seed) do
    seed
  end

  def compute_next_sig(sig, j, x ) do
    band(bor(band(sig + (j >>> 8) + x, 0xff), (j <<<8)), 0xffff)
  end

end

defmodule Signaturetest do
  use ExUnit.Case

  test 'compute seed for "A" ' do
    assert 43669 == Pakker.Signature.compute_next_sig(0xaaaa , 0xaaaa, 65)
  end

  test 'compute seed for "B" ' do
    assert 43670 == Pakker.Signature.compute_next_sig(0xaaaa , 0xaaaa, 66)
  end

  test 'compute null' do
    assert 86 == Pakker.Signature.compute_null(0xdd, 0xaaa)
  end

  test 'compute signature for empty message' do
    assert 0xAAAA == Pakker.Signature.calc_sig('', 0xAAAA)
  end

  test 'compute signature for "b" message' do
    assert 43617 == Pakker.Signature.calc_sig('b', 0xAAAA)
  end

  test 'compute signature for "ab" message' do
    assert 24780 == Pakker.Signature.calc_sig('ab', 0xAAAA)
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
    assert 13217 == signature
  end

  # test 'compute signature nullifer byte for packet' do
  #   assert <<0x71, 0xd2 >> == Pakker.Signature.calc_sig_nullifier(13217)
  # end
end
