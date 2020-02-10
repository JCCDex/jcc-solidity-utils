const NodeManagemenet = artifacts.require('NodeManagemenet');

contract('NodeManagemenet', () => {
  it('get node', async () => {
    let inst = await NodeManagemenet.new();
    let nodes = await inst.getNode();
    assert.deepEqual(nodes.jingtumNodes, []);

    await inst.updateJingtumNodes(["https://srje071qdew231.jccdex.cn"])
    nodes = await inst.getNode();
    assert.deepEqual(nodes.jingtumNodes, ["https://srje071qdew231.jccdex.cn"]);
    await inst.insertJingtumNodes(["https://srje071qdew23.jccdex.cn"])
    nodes = await inst.getNode();
    assert.deepEqual(nodes.jingtumNodes, ["https://srje071qdew231.jccdex.cn", "https://srje071qdew23.jccdex.cn"]);

    await inst.updateMoacNodes(["https://srje071qdew231.jccdex.cn"])
    nodes = await inst.getNode();
    assert.deepEqual(nodes.moacNodes, ["https://srje071qdew231.jccdex.cn"]);
    await inst.insertMoacNodes(["https://srje071qdew23.jccdex.cn"])
    nodes = await inst.getNode();
    assert.deepEqual(nodes.moacNodes, ["https://srje071qdew231.jccdex.cn", "https://srje071qdew23.jccdex.cn"]);
    
    await inst.updateInfoNodes(["https://srje071qdew231.jccdex.cn"])
    nodes = await inst.getNode();
    assert.deepEqual(nodes.infoNodes, ["https://srje071qdew231.jccdex.cn"]);
    await inst.insertInfoNodes(["https://srje071qdew23.jccdex.cn"])
    nodes = await inst.getNode();
    assert.deepEqual(nodes.infoNodes, ["https://srje071qdew231.jccdex.cn", "https://srje071qdew23.jccdex.cn"]);
    
    await inst.updateEthereumNodes(["https://srje071qdew231.jccdex.cn"])
    nodes = await inst.getNode();
    assert.deepEqual(nodes.ethereumNodes, ["https://srje071qdew231.jccdex.cn"]);
    await inst.insertEthereumNodes(["https://srje071qdew23.jccdex.cn"])
    nodes = await inst.getNode();
    assert.deepEqual(nodes.ethereumNodes, ["https://srje071qdew231.jccdex.cn", "https://srje071qdew23.jccdex.cn"]);
    
    await inst.updateExplorerNodes(["https://srje071qdew231.jccdex.cn"])
    nodes = await inst.getNode();
    assert.deepEqual(nodes.explorerNodes, ["https://srje071qdew231.jccdex.cn"]);
    await inst.insertExplorerNodes(["https://srje071qdew23.jccdex.cn"])
    nodes = await inst.getNode();
    assert.deepEqual(nodes.explorerNodes, ["https://srje071qdew231.jccdex.cn", "https://srje071qdew23.jccdex.cn"]);
    

  });
});