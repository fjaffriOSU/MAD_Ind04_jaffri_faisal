<?php

// Database Connection
class DBConnection {
    private $_dbHostname = "cs.okstate.edu";
    private $_dbName = "fjaffri";
    private $_dbUsername = "fjaffri";
    private $_dbPassword = "muddyF@ct59";
    private $_con;
 
    public function __construct() {
        try {
            $this->_con = new PDO("mysql:host=$this->_dbHostname;dbname=$this->_dbName", $this->_dbUsername, $this->_dbPassword);    
            $this->_con->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch(PDOException $e) {
            echo "Connection failed: " . $e->getMessage();
        }
 
    }
    // return Connection
    public function returnConnection() {
        return $this->_con;
    }
}
class States 
{
    protected $db;
    private $name;
    private $nickname;

    public function setName($name) {
        $this->name = $name;
    }
    public function setNickName($nickname) {
        $this->nickname = $nickname;
    }

    public function __construct() {
        $this->db = new DBConnection();
        $this->db = $this->db->returnConnection();
    }

 
    // getAll States
    public function getAllStates() {
        try {
                $sql = "SELECT * FROM states";
         $stmt = $this->db->prepare($sql);

            $stmt->execute();
            $result = $stmt->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        } catch (Exception $e) {
            die("Oh no! There's an error in the query!");
        }
    }

}

            $state = new States();  

        $stateInfo = $state->getAllStates();
        if(!empty($stateInfo)) {
          $js_encode = json_encode(array('status'=>TRUE, 'stateInfo'=>$stateInfo), true);
        } else {
            $js_encode = json_encode(array('status'=>FALSE, 'message'=>'There is no record yet.'), true);
        }
        header('Content-Type: application/json');
        echo $js_encode;
        header("HTTP/1.0 405 Method Not Allowed");


?>