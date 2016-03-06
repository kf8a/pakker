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

  def sig(_message) do
  end

  # def calcSig(message, seed \\ 0xAAAA) do
  #   ret = seed
  #   csi_alg(message, seed)
  # end

  # def csi_alg(message, seed, n) when n <= 1 do
  #   seed
  # end

  # def csi_alg(message, seed, n) do
  #   old_seed = seed
  #   seed 
  #   |> shift_and_add_1ff
  #   |> increment_seed 
  #   |> compute_seed(message, old_seed)
  # end

  # def increment_seed(seed) when seed >= 0x100 do
  #   seed + 1
  # end

  # def increment_seed(seed) do
  #   seed
  # end

  # def shift_and_add_1ff(seed) do
  #   band(seed <<< 1), 0x01ff)
  # end

  def compute_seed(message, old_seed) do
  end

  def compute_seed_with_char(seed, c, j) do
    bor(band(seed + (j >>> 8) + c, 0xFF), band(j <<< 8, 0xffff))
  end
end

defmodule SignatureTest do
  use ExUnit.Case

  test 'compute seed' do
    assert 0xaaf5 == Pakker.Signature.compute_seed_with_char(0xaaa , 65, 0xaaa)
  end

  # test 'compute signature bytes' do
  #   message = << 0x90, 0x01, 0x0f, 0x71 >>
  #   correct_signature = <<0x71, 0xd2 >>
  #   signature = Pakker.Signature.sig(message)
  #   assert signature == correct_signature
  # end
end
