from graph import *


def a_star(graph, show_tree=False, show_lists=True):
    open_list = [WalkingNode(graph.start, None, 0, graph.calculate_h(graph.start))]
    closed_list = []

    while len(open_list) > 0:

        if show_lists:
            print("open=", open_list, sep="")
            print("closed=", closed_list, sep="")
        current_node = open_list.pop(0)
        closed_list.append(current_node)

        if show_tree:
            print(f"\nExtindem: {current_node.info}")

        if graph.test_scope(current_node.info):
            return current_node

        successors = graph.generate_successors(current_node)

        for s in successors:
            node_open = in_list(open_list, s)
            if node_open is not None:
                if node_open.f > s.f:
                    open_list.remove(node_open)
                    insert_node(s, open_list)
                    if show_tree:
                        print(f"Arbore: {s.info} devine copilul lui {current_node.info} <-> {s.g}/{s.f}")
                continue
            node_closed = in_list(closed_list, s)
            if node_closed is not None:
                if node_closed.f > s.f:
                    closed_list.remove(node_closed)
                    insert_node(s, open_list)
                    if show_tree:
                        print(f"Explicatie: Mutam {s} din closed in open")
                continue
            if show_tree:
                print(f"Arbore: {s.info} devine copilul lui {current_node.info} <-> {s.g}/{s.f}")
            insert_node(s, open_list)

    return None


if __name__ == '__main__':
    g = Graph()
    show_tree_not_lists = False
    print(a_star(g, show_tree=show_tree_not_lists, show_lists=not show_tree_not_lists))
