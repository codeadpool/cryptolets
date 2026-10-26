#!/usr/bin/env python3
"""Small BLS12-381 single-PE context/tiling regression with affine Python oracle.

Coordinates in samples.csv are Montgomery affine X/Y, matching PE point ports.
Goldens are ordinary affine X/Z,Y/Z; (0,0) encodes infinity. No Tessera arithmetic
or scheduler is used to compute the oracle. Geometry remains K4/W8/LOGN16.
"""
import argparse
import csv
import json
from pathlib import Path

Q = int('1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab',16)
R = pow(2,381,Q)
G = (int('17f1d3a73197d7942695638c4fa9ac0fc3688c4f9774b905a14e3a3f171bac586c55e83ff97a1aeffb3af00adb22c6bb',16),
     int('08b3f481e3aaa0f1a09e30ed741d8ae4fcf5e095d5d00af600db18cb2c04b3edd03cc744a2888ae40caa232946c5e7e1',16))
MAX_POINTS=16


def add(a,b):
    if a is None:return b
    if b is None:return a
    x,y=a;u,v=b
    if x==u and (y+v)%Q==0:return None
    m=((3*x*x)*pow(2*y,-1,Q) if a==b else (v-y)*pow(u-x,-1,Q))%Q
    xx=(m*m-x-u)%Q
    return xx,(m*(x-xx)-y)%Q


def mul(n,a):
    r=None
    while n:
        if n&1:r=add(r,a)
        a=add(a,a);n>>=1
    return r


def generate(out):
    assert (G[1]*G[1]-G[0]*G[0]*G[0]-4)%Q==0
    pts=[G,(G[0],(-G[1])%Q),mul(2,G),None,mul(3,G),G,mul(5,G),mul(8,G),mul(13,G),mul(21,G),mul(34,G)]
    expected=[None]*8
    rows=[];gold=[];cases=[]
    def command(ctx,digits,clear=False,reduce=False,label=''):
        win=31-4*ctx
        if clear:expected[ctx]=None
        if not reduce:
            for i,d in enumerate(digits):expected[ctx]=add(expected[ctx],mul(d,pts[i%len(pts)]))
        result=expected[ctx] if reduce else None
        row=[len(digits),win,ctx,int(clear),int(reduce)]
        for i in range(MAX_POINTS):
            p=pts[i%len(pts)] if i<len(digits) else None
            x,y=(0,0) if p is None else (p[0]*R%Q,p[1]*R%Q)
            s=(digits[i]<<(8*win)) if i<len(digits) else 0
            assert s < (1<<255)
            row.extend((x,y,s))
        rows.append(row);gold.append((0,0) if result is None else result)
        cases.append({'command':len(rows)-1,'label':label,'context':ctx,'window':win,'n':len(digits),
                      'clear':clear,'reduce':reduce,'expected_point_reads':sum(d!=0 for d in digits)})
    for ctx in range(8):
        digits=[1,1,1,2,3,127 if ctx==0 else 255,0,2]
        if ctx==7:digits.append(4)
        command(ctx,digits,True,label='first_tile_context_'+str(ctx))
    command(0,[1]*11,label='second_tile_context_0_queue_backpressure')
    command(7,[255,255,1,0,255,3,255],label='second_tile_context_7_odd_count')
    command(3,[],True,label='clear_previously_populated_context_3_empty')
    for ctx in range(8):command(ctx,[],reduce=True,label='serial_reduce_context_'+str(ctx))
    command(0,[2,3,4,1,127],True,label='new_msm_reinitialize_context_0_and_scratch')
    command(0,[],reduce=True,label='serial_reduce_reinitialized_context_0')
    out.mkdir(parents=True,exist_ok=True)
    with (out/'samples.csv').open('w',newline='') as f:
        w=csv.writer(f,lineterminator='\n');w.writerow(['n','win','context','clear','reduce']+[f'{c}{i}' for i in range(MAX_POINTS) for c in ('x','y','s')]);w.writerows(rows)
    with (out/'goldens.csv').open('w',newline='') as f:
        w=csv.writer(f,lineterminator='\n');w.writerow(['x','y']);w.writerows(gold)
    (out/'cases.json').write_text(json.dumps({'curve':'BLS12-381 G1 y^2=x^3+4','oracle':'independent Python affine EC group arithmetic',
        'coordinate_domain':'Montgomery X/Y inputs; ordinary affine outputs','geometry':{'physical_bank_capacity':4096,'pe_contexts':8,'context_words':260,'bucket_xyz_words_each':2080},
        'commands':cases},indent=2)+'\n')
    print(f'Generated {len(rows)} commands, {sum(c["reduce"] for c in cases)} reductions in {out}')

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--out',type=Path,required=True);generate(p.parse_args().out)
