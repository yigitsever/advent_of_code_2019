# this solves part 2
import sys

import networkx as nx


def main(argv):

    G = nx.DiGraph()
    with open(argv[0]) as fp:
        for line in fp:
            line = line.rstrip("\n")
            start, end = line.split(")")
            G.add_node(start, label=start)
            G.add_node(end, label=end)
            G.add_edge(start, end)

    jump_to = nx.lowest_common_ancestor(G, "SAN", "YOU")  # SAN and YOU are given
    jumps = (
        len(nx.shortest_path(G, jump_to, "SAN"))
        + len(nx.shortest_path(G, jump_to, "YOU"))
        - 4
    )  # 4 because len includes start and end, so -2 times 2
    print(jumps)


if __name__ == "__main__":
    main(sys.argv[1:])
