import torch

def test(a:torch.Tensor):
    return a +1 

a = torch.ones((50 , 50))
out_put = torch.chain_matmul(a, a, a, a) + test(a)

