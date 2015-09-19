import matplotlib.pyplot as plt
import numpy as np
from IPython.html.widgets import interact
import nibabel as nib

def axial(s,data):
    return np.transpose(data[:, :, s])
def coronal(s,data):
    return np.transpose(data[:, s, ::-1])
def sagittal(s,data):
    return np.transpose(data[s, :, ::-1])
    
def viewer(fname):
    data = nib.load(fname).get_data()
    def plot(slice, view):
        try:
            fig, ax = plt.subplots()
            ax.imshow(view(slice,data), cmap='gray')
            axes = ax.get_axes()
            axes.get_xaxis().set_ticks([])
            axes.get_yaxis().set_ticks([])
            fig.show()
        except IndexError:
            print("Oops, I don't have that many slices for this projection, sorry")
    interact(plot, slice=(0, max(data.shape)-1), view={k.__name__:k for k in (axial, coronal, sagittal)})
