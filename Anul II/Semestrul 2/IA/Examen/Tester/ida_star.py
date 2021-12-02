from graph import *

total_nodes, max_nodes = 0, 0


def build_road(graph: Graph, current_node: WalkingNode, limit: int):
    global total_nodes, max_nodes

    if graph.test_scope(current_node.info):
        return True, 0, current_node

    if current_node.f > limit:
        return False, current_node.f, None

    mini = float('inf')

    successors = graph.generate_successors(current_node)
    max_nodes = max(max_nodes, len(successors))
    total_nodes += len(successors)
    for s in successors:
        arrived, lim, scope_node = build_road(graph, s, limit)

        if arrived:
            return True, 0, scope_node
        mini = min(mini, lim)

    return False, mini, None


def ida_star(graph):
    level = graph.calculate_h(graph.start)
    start_node = WalkingNode(graph.start, None, 0, level)
    while True:
        arrived, limit, scope_node = build_road(graph, start_node, level)
        if arrived:
            return scope_node
        if limit == float('inf'):
            print("Nu exista drum!")
            break
        level = limit
    return None


if __name__ == '__main__':
    g = Graph()
    print(ida_star(g))
