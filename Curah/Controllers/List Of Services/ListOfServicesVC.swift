//
//  ListOfServicesVC.swift
//  Curah
//
//  Created by Apple on 01/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

protocol updateViewSwipeHeight {
    func updateHeight(value:Int)
}

class ListOfServicesVC: UIViewController {
    var servicesList : [ProviderServices] = []
    var objProtocol : updateViewSwipeHeight?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        objProtocol?.updateHeight(value:(servicesList.count+2)*50)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ListOfServicesVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicesList.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellServicesNamePrice")
        cell?.selectionStyle = .none
        return self.configureCell(cell: cell!, indexpath: indexPath)
    }
    
    func configureCell(cell:UITableViewCell, indexpath:IndexPath) -> UITableViewCell {
        let viewAtBack : UIView = (cell.viewWithTag(1))!
        viewAtBack.borderWidth = 1.0
        viewAtBack.borderColor = UIColor.lightGray.withAlphaComponent(0.4)
        viewAtBack.clipsToBounds=true
        viewAtBack.backgroundColor = (indexpath.row%2==0) ? UIColor.clear : UIColor.lightGray.withAlphaComponent(0.07)
        (cell.viewWithTag(2) as? UILabel)!.text = servicesList[indexpath.row].name
        (cell.viewWithTag(3) as? UILabel)!.text = "$\(servicesList[indexpath.row].price ?? 0)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}
