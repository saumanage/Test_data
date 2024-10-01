/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ComponentDirectoryController {
    global ComponentDirectoryController() {

    }
    @RemoteAction
    global static String createRootDirectory(cwbtool.ComponentDirectoryController.ServiceWrapper obj) {
        return null;
    }
    @RemoteAction
    global static cwbtool.ComponentDirectoryController.ServiceWrapper createUpdateChildDirectory(cwbtool.ComponentDirectoryController.ServiceWrapper obj) {
        return null;
    }
    @RemoteAction
    global static void deleteDirectory(String strId) {

    }
    @RemoteAction
    global static void deleteFolderOrFile(String strId, Boolean isFIle) {

    }
    @RemoteAction
    global static cwbtool.ComponentDirectoryController.ServiceWrapper getDirectoryDetail(String strId) {
        return null;
    }
    @RemoteAction
    global static List<cwbtool.ComponentDirectoryController.ServiceWrapper> getDirectory() {
        return null;
    }
    @RemoteAction
    global static cwbtool.ComponentDirectoryController.MetadataDetail getMetadataDetail(String strType, String strInstanceUrl) {
        return null;
    }
    @RemoteAction
    global static List<cwbtool.ComponentDirectoryController.Node> getTreeViewDetail(String rootId) {
        return null;
    }
    @RemoteAction
    global static User getUserDetail() {
        return null;
    }
    @RemoteAction
    global static String scheduleBatch(List<String> lst, String strType, String strInstanceUrl, String rootId, String strParentId, Integer batchSize) {
        return null;
    }
global class MetadataDetail {
}
global class Node {
}
global class ServiceWrapper {
}
}
