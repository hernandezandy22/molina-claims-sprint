import pandas as pd 
import matplotlib.pyplot as plt
import textwrap 

def wrap(text, width=30): 
	return "\n".join(textwrap.wrap(text,width))

df = pd.read_csv("03_results.csv")
df= df.sort_values("total_spent")

labels = [wrap(n) for n in df["provider_name"]]

fix, ax = plt.subplots(figsize=(10.5,6.8))
ax.barh(labels, df["total_spent"])

for i, v in enumerate(df["total_spent"]): 
	ax.text(v,i, f"${v/1e6:.0f}M", va="center", ha="left")

plt.tight_layout()
plt.savefig("test_chart2.png")

print("Saved test_chart2.png")
