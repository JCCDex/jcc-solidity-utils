pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

import "../owner/Administrative.sol";

contract NodeManagemenet is Administrative {
    Nodes private allNodes;

    // 定义所有节点结构
    struct Nodes {
        // 井通节点
        bytes32[] jingtumNodes;
        // 井畅info服务器节点
        bytes32[] infoNodes;
        // 以太坊节点
        bytes32[] ethereumNodes;
        // MOAC节点
        bytes32[] moacNodes;
        // 井畅浏览器节点
        bytes32[] explorerNodes;
    }

    constructor() public Administrative() {}

    function getNodes() public view returns (NodeManagemenet.Nodes) {
        return allNodes;
    }

    function updateJingtumNodes(bytes32[] nodes)
        public
        onlyPrivileged
        returns (bool updated)
    {
        require(nodes.length > 0, "node's length must be bigger than 0");
        allNodes.jingtumNodes = nodes;
        return true;
    }

    function insertJingtumNodes(bytes32[] nodes)
        public
        onlyPrivileged
        returns (bool updated)
    {
        require(nodes.length > 0, "node's length must be bigger than 0");
        uint256 len = nodes.length;
        for (uint256 i = 0; i < len; i++) {
            allNodes.jingtumNodes.push(nodes[i]);
        }
        return true;
    }

    function updateInfoNodes(bytes32[] nodes)
        public
        onlyPrivileged
        returns (bool updated)
    {
        require(nodes.length > 0, "node's length must be bigger than 0");
        allNodes.infoNodes = nodes;
        return true;
    }

    function insertInfoNodes(bytes32[] nodes)
        public
        onlyPrivileged
        returns (bool updated)
    {
        require(nodes.length > 0, "node's length must be bigger than 0");
        uint256 len = nodes.length;
        for (uint256 i = 0; i < len; i++) {
            allNodes.infoNodes.push(nodes[i]);
        }
        return true;
    }

    function updateEthereumNodes(bytes32[] nodes)
        public
        onlyPrivileged
        returns (bool updated)
    {
        require(nodes.length > 0, "node's length must be bigger than 0");
        allNodes.ethereumNodes = nodes;
        return true;
    }

    function insertEthereumNodes(bytes32[] nodes)
        public
        onlyPrivileged
        returns (bool updated)
    {
        require(nodes.length > 0, "node's length must be bigger than 0");
        uint256 len = nodes.length;
        for (uint256 i = 0; i < len; i++) {
            allNodes.ethereumNodes.push(nodes[i]);
        }
        return true;
    }

    function updateMoacNodes(bytes32[] nodes)
        public
        onlyPrivileged
        returns (bool updated)
    {
        require(nodes.length > 0, "node's length must be bigger than 0");
        allNodes.moacNodes = nodes;
        return true;
    }

    function insertMoacNodes(bytes32[] nodes)
        public
        onlyPrivileged
        returns (bool updated)
    {
        require(nodes.length > 0, "node's length must be bigger than 0");
        uint256 len = nodes.length;
        for (uint256 i = 0; i < len; i++) {
            allNodes.moacNodes.push(nodes[i]);
        }
        return true;
    }

    function updateExplorerNodes(bytes32[] nodes)
        public
        onlyPrivileged
        returns (bool updated)
    {
        require(nodes.length > 0, "node's length must be bigger than 0");
        allNodes.explorerNodes = nodes;
        return true;
    }

    function insertExplorerNodes(bytes32[] nodes)
        public
        onlyPrivileged
        returns (bool updated)
    {
        require(nodes.length > 0, "node's length must be bigger than 0");
        uint256 len = nodes.length;
        for (uint256 i = 0; i < len; i++) {
            allNodes.explorerNodes.push(nodes[i]);
        }
        return true;
    }
}
