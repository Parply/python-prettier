import torch 

a = torch.ones((500,500))
out_Put = torch.chain_matmul(a, a,a,a)