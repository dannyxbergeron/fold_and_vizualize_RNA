import matplotlib.pyplot as plt
import forgi.visual.mplotlib as fvm
import forgi

fx_file = snakemake.input.fx_file
mfe_file = snakemake.input.mfe
out = snakemake.output.svg

plt.rcParams['svg.fonttype'] = 'none'
plt.rcParams['font.sans-serif'] = ['Arial']

with open(mfe_file, 'r') as f:
    mfe = f.readline()
    mfe = mfe.replace('Free Energy of Ensemble', 'mfe').strip()

cg = forgi.load_rna(fx_file, allow_many=False)
seq_len = len(cg._seq)
# print(f'--> SEQ_LEN: {seq_len}')

# plot params
FONTSIZE = 4
LINEWIDTH_BACKBONE = 0.5
LINEWIDTH_BASEPAIR = 1

'''
For some reasons, the forgi is crashing with some structurs.
In order to make it work for all my structures, I changed the folowing
line:
    vec=vec/ftuv.magnitude(vec)
for this:
    if ftuv.magnitude(vec) == 0:
        vec=vec/0.1
    else:
        vec=vec/ftuv.magnitude(vec)
at line 370 of the file:
workflow/.snakemake/conda/<YOU_CONDA_ENV>/lib/python3.8/site-packages/forgi/visual/mplotlib.py

The issue was reported, but unfortunately never corrected, see:
https://github.com/ViennaRNA/forgi/issues/39
'''

ax, _ = fvm.plot_rna(
     cg,
     text_kwargs={"fontweight":"ultralight", 'fontsize': FONTSIZE, "color": '#2F3236'},
     lighten=0.85,
     color=True,
     backbone_kwargs={"linewidth":LINEWIDTH_BACKBONE, "color": "#2F3236"},
     basepair_kwargs={"linewidth":LINEWIDTH_BASEPAIR, 'color': 'red'},
)

ax.set_title(f'{snakemake.wildcards[0]}\n({mfe})')
plt.savefig(out, format='svg')
# plt.show()
