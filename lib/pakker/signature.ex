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
    band(bor(band(sig + (j >>> 8) + x, 0xff), (j <<< 8)), 0xffff)
  end
end
