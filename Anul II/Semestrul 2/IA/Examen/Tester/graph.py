import sys
from copy import copy


class WalkingNode:
    def __init__(self, info: str, parent, cost=0, h=0):
        self.info = info
        self.parent = parent
        self.g = cost
        self.h = h
        self.f = self.g + self.h

    def get_road(self):
        road = [self.info]
        node = self
        while node.parent is not None:
            road.insert(0, node.parent.info)
            node = node.parent
        return road

    def show_road(self):
        print(self)

    def __repr__(self):
        parent_repr = ""
        if self.parent is not None:
            parent_repr = f", parinte='{self.parent.info}'"
        return f"Nod('{self.info}', g={self.g}, f={self.f}{parent_repr})"

    def __str__(self):
        road = self.get_road()
        result = " -> ".join(road)
        result += f" cost({self.g})"
        return result


class Graph:
    def __init__(self):
        self.nodes = []
        self.start = None
        self.scopes = []

        self.connections = dict()
        self.estimates = dict()

        self.read()

    def read(self):
        with open("data/graph.txt", "r") as r:
            n = int(r.readline())
            self.start = r.readline().replace('\n', '')
            self.scopes = r.readline().replace('\n', '').split(' ')
            for i in range(n):
                l, v = r.readline().replace('\n', '').split(' ')
                self.nodes.append(l)
                self.estimates[l] = int(v)
            line = r.readline()
            while line:
                a, b, val = line.split(' ')
                self.connections[(a, b)] = int(val)
                line = r.readline().replace('\n', '')

    def test_scope(self, node):
        return node in self.scopes

    def calculate_h(self, node):
        if node not in self.estimates:
            return sys.maxsize
        return self.estimates[node]

    def generate_successors(self, current_node):
        successors = list()
        for node in self.nodes:
            if (current_node.info, node) in self.connections:
                g = self.connections[(current_node.info, node)]
                successors.append(WalkingNode(node, copy(current_node), current_node.g + g, self.calculate_h(node)))
        return successors


def in_list(list, node):
    for s in list:
        if s.info == node.info:
            return s
    return None


def insert_node(node, list):
    idx = 0
    while idx < len(list) and (node.f > list[idx].f or (node.f == list[idx].f and node.g < list[idx].g)):
        idx += 1
    list.insert(idx, node)
