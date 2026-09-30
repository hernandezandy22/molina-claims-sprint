import pandas as pd 
import matplotlib.pyplot as plt
import textwrap 

BLUE= "#0A84FF"

def wrap(text, width=46):
	return "\n".join(textwrap.wrap(text,width))


df = pd.read_csv("02_results.csv")
df= df.sort_values("total_spent")

labels = [wrap(d) for d in df["hcpcs_desc"]]

fig, ax = plt.subplots(figsize=(11,7.5))
ax.barh(labels, df["total_spent"],color=BLUE)

for i, v in enumerate(df["total_spent"]):
	ax.text(v, i, f"${v/1e6:.0f}M" , va="center", ha="left")

for side in ["top", "right", "left"]:
	ax.spines[side].set_visible(False)
ax.tick_params(left=False,bottom=False)
ax.set_xticks([])


plt.tight_layout()
plt.savefig("test_chart.png")


print("Saved test_chart.png")
