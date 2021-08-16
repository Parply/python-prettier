import torch

a = torch.ones((50, 50))
out_put = torch.chain_matmul(a, a, a, a)
