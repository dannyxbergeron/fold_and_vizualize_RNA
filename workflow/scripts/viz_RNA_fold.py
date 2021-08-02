import matplotlib.pyplot as plt
import forgi.visual.mplotlib as fvm
import forgi

fx_file = snakemake.input.fx_file
out = snakemake.output.svg

plt.rcParams['svg.fonttype'] = 'none'
plt.rcParams['font.sans-serif'] = ['Arial']


def main():

    cg = forgi.load_rna(fx_file, allow_many=False)
    fvm.plot_rna(
         cg,
         text_kwargs={"fontweight":"ultralight", 'fontsize': 4, "color": '#2F3236'},
         lighten=.85,
         backbone_kwargs={"linewidth":0.5, "color": "#2F3236"}
    )
    # plt.show()
    plt.savefig(out, format='svg')


if __name__ == '__main__':
    main()
