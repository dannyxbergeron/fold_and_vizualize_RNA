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
ax, _ = fvm.plot_rna(
     cg,
     text_kwargs={"fontweight":"ultralight", 'fontsize': 4, "color": '#2F3236'},
     lighten=.85,
     backbone_kwargs={"linewidth":0.5, "color": "#2F3236"}
)

ax.set_title(f'{snakemake.wildcards[0]}\n({mfe})')
plt.savefig(out, format='svg')
