# // signature algorithm.
# // Standard signature is initialized with a seed of
# // 0xaaaa. Returns signature.  If the function is called
# // on a partial data set, the return value should be
# // used as the seed for the remainder
# typedef unsigned short uint2;
# typedef unsigned long uint4;
# typedef unsigned char byte;
# uint2 calcSigFor(void const *buff, uint4 len, uint2 seed=0xAAAA)
# {
#   uint2 j, n;
#   uint2 rtn = seed;
#   byte const *str = (byte const *)buff;
#   // calculate a representative number for the byte
#   // block using the CSI signature algorithm.
#   for (n = 0; n < len; n++)
#   {
#     j = rtn;
#     rtn = (rtn << 1) & (uint2)0x01FF;
#     if (rtn >= 0x100)
#     rtn++;
#     rtn = (((rtn + (j >> 8) + str[n]) & (uint2)0xFF) | (j << 8));
#   }
#   return rtn;
# } // calcSigFor

defmodule Pakker.Signature do
  use Bitwise

  def calc_sig_nullifier(sig) do
    new_seed = band(sig<<<1, 0x1ff)
    new_sig = sig
    new_seed =increment_seed(new_seed)
    null1 = band(0x0100 - (new_seed + (sig >>> 8 )), 0xff)
    IO.inspect(null1)
    IO.inspect(sig)
    new_sig = csi_alg(null1, sig)

    new_seed = band((new_sig <<< 1), 0x01ff)
    new_seed =increment_seed(new_seed)
    null2 = 0x0100 - (new_seed + (new_sig >>> 8))
    <<null1, null2>>
  end

  def calc_sig(message, seed \\ 0xAAAA) do
    Enum.reduce(message, seed, fn(x, seed) -> csi_alg(x,seed) end)
  end

  def csi_alg(byte, seed) do
    old_seed = seed
    seed 
    |> shift_and_add_1ff
    |> increment_seed 
    |> compute_seed(byte, old_seed)
  end

  def increment_seed(seed) when seed >= 0x100 do
    band(seed + 1, 0xffff)
  end

  def increment_seed(seed) do
    seed
  end

  def shift_and_add_1ff(seed) do
    band(band(seed <<< 1, 0x01ff), 0xffff)
  end

  def compute_seed(seed, c, j) do
    bor(band(seed + (j >>> 8) + :binary.decode_unsigned(c), 0xff), band(j <<< 8, 0xffff))
  end
end

defmodule Signaturetest do
  use ExUnit.Case

  test 'compute seed' do
    assert 0xaaf5 == Pakker.Signature.compute_seed(0xaaa , "A", 0xaaa)
  end

  test 'compute signature nullifer bytes' do
    message = << 0x90, 0x01, 0x0f, 0x71 >>
    signature = Pakker.Signature.calc_sig(message)
    nullifier = Pakker.Signature.calc_sig_nullifier(signature)
    correct_nullifer = <<0x71, 0xd2 >>
    assert nullifier == correct_nullifer
  end
end
