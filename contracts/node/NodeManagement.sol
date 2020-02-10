pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

import "../owner/Administrative.sol";

contract NodeManagemenet is Administrative {
    Node private allNode;

    // 定义所有节点结构
    struct Node {
        // 井通节点
        string[] jingtumNodes;
        // 井畅info服务器节点
        string[] infoNodes;
        // 以太坊节点
        string[] ethereumNodes;
        // MOAC节点
        string[] moacNodes;
        // 井畅浏览器节点
        string[] explorerNodes;
    }

    constructor() public Administrative() {}

    function getNode() public view returns (NodeManagemenet.Node) {
        return allNode;
    }

    function updateJingtumNodes(string[] nodes) public onlyPrivileged returns (bool updated) {
        require(nodes.length > 0, "node's length must be bigger than 0");
        allNode.jingtumNodes = nodes;
        return true;
    }

    function insertJingtumNodes(string[] nodes) public onlyPrivileged returns (bool inserted) {
        require(nodes.length > 0, "node's length must be bigger than 0");
        uint256 len = nodes.length;
        for (uint256 i = 0; i < len; i++) {
            allNode.jingtumNodes.push(nodes[i]);
        }
        return true;
    }

    function updateMoacNodes(string[] nodes) public onlyPrivileged returns (bool updated) {
        require(nodes.length > 0, "node's length must be bigger than 0");
        allNode.moacNodes = nodes;
        return true;
    }

    function insertMoacNodes(string[] nodes) public onlyPrivileged returns (bool inserted) {
        require(nodes.length > 0, "node's length must be bigger than 0");
        uint256 len = nodes.length;
        for (uint256 i = 0; i < len; i++) {
            allNode.moacNodes.push(nodes[i]);
        }
        return true;
    }

    function updateInfoNodes(string[] nodes) public onlyPrivileged returns (bool updated) {
        require(nodes.length > 0, "node's length must be bigger than 0");
        allNode.infoNodes = nodes;
        return true;
    }

    function insertInfoNodes(string[] nodes) public onlyPrivileged returns (bool inserted) {
        require(nodes.length > 0, "node's length must be bigger than 0");
        uint256 len = nodes.length;
        for (uint256 i = 0; i < len; i++) {
            allNode.infoNodes.push(nodes[i]);
        }
        return true;
    }

    function updateEthereumNodes(string[] nodes) public onlyPrivileged returns (bool updated) {
        require(nodes.length > 0, "node's length must be bigger than 0");
        allNode.ethereumNodes = nodes;
        return true;
    }

    function insertEthereumNodes(string[] nodes) public onlyPrivileged returns (bool inserted) {
        require(nodes.length > 0, "node's length must be bigger than 0");
        uint256 len = nodes.length;
        for (uint256 i = 0; i < len; i++) {
            allNode.ethereumNodes.push(nodes[i]);
        }
        return true;
    }

    function updateExplorerNodes(string[] nodes) public onlyPrivileged returns (bool updated) {
        require(nodes.length > 0, "node's length must be bigger than 0");
        allNode.explorerNodes = nodes;
        return true;
    }

    function insertExplorerNodes(string[] nodes) public onlyPrivileged returns (bool inserted) {
        require(nodes.length > 0, "node's length must be bigger than 0");
        uint256 len = nodes.length;
        for (uint256 i = 0; i < len; i++) {
            allNode.explorerNodes.push(nodes[i]);
        }
        return true;
    }
}
