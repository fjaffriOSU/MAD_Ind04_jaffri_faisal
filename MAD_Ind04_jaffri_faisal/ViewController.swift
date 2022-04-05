//
//  ViewController.swift
//  MAD_Ind04_jaffri_faisal
//
//  Created by Faisal Jaffri on 4/4/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //Tableview to display states and its nicknames
    @IBOutlet weak var myTableView: UITableView!
    //Array to store response from the GET API request
    var responseFromDB:[States] = []
    
    //Spinner used to display while API call is made
    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //deleagte and datasource for tableview
        myTableView.delegate = self
        myTableView.dataSource = self
        
        mySpinner.hidesWhenStopped = true
        mySpinner.startAnimating()

        //Call to process network request and Json response
        fetchDataFromDatabase()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.responseFromDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "myCell")
        cell.textLabel?.text = self.responseFromDB[indexPath.row].name
        cell.detailTextLabel?.text = self.responseFromDB[indexPath.row].nickname
        return cell
        
        
    }
    
    //MARK: - Networking and Json Parsing
    /***************************************************************/
    
    // This function makes an API call, parses the response and save it to a struct array
    func fetchDataFromDatabase(){
        let urlString =  "https://cs.okstate.edu/~fjaffri/read.php"
       
        guard let url = URL(string: urlString)
        else {
            print("Invalid URL")
            return
            
        }
        let task = URLSession.shared.dataTask(with: url)
        { (data, response, error) in
            // Check to see if any error was encountered.
            print(Thread.current)
            
            guard error == nil  else {
                print("URL Session error: \(error!)")
                return
            }
            // Check to see if we received any data.
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let json = try JSONDecoder().decode(Response.self,
                                                    from: data)
                /*Once the data is recieved and decoded, main thread reloads the UI (tableview) and populates the state names and nicknames. The spinner is also terminates at the same time
                 */
                DispatchQueue.main.async {
                    self.responseFromDB = json.stateInfo
                    self.mySpinner.stopAnimating()
                    self.myTableView.reloadData()
                }
            } catch let error as NSError {
                print("Error serializing JSON Data: \(error)")
            }
        }
        task.resume()
    }
    
}
//MARK: - Struct for API response
/***************************************************************/


struct States: Decodable {
    let name: String
    let nickname: String
    
}

struct Response: Decodable {
    var stateInfo: [States] = []
    var status:Bool
    
}

