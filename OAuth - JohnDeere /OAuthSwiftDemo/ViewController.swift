
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let getAPICatalog :String = "https://apicert.soa-proxy.deere.com/platform/"
    let getOrganizationURL :String = "https://apicert.soa-proxy.deere.com/platform/organizations"

    var services = ["MyJohnDeere"]
    typealias ServiceResponse = (String, NSError?) -> Void

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "OAuth"
        doOAuthMyJohnDeere()
        let tableView: UITableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func doOAuthMyJohnDeere(){
        let oauthswift = OAuth1Swift(
            consumerKey:    MyJohnDeere["consumerKey"]!,
            consumerSecret: MyJohnDeere["consumerSecret"]!,
            requestTokenUrl: "",
            authorizeUrl:    "",
            accessTokenUrl:  ""
        )
        
        oauthswift.client.credential.oauth_header_type = "oauth1"
        let parameters = [:]

        //STEP:1 -  GET API CATALOG CALL
        print("GET APICatalog Request URL : \(getAPICatalog)")
        oauthswift.client.get(getAPICatalog, parameters: parameters as! Dictionary<String, AnyObject>,
            success: {
                data, response in
                print("GET APICatalog Response :\(response)")
                let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                if let links = jsonDict["links"]! as? [AnyObject] {
                    let requestToken :String = links[0]["uri"] as! String
                    let authorizeToken :String = links[1]["uri"] as! String
                    let accessToken :String = links[2]["uri"] as! String
                   
                    print("\n Request Token URL: \(requestToken)")
                    print("\n Authorize Token URL: \(authorizeToken)")
                    print("\n Access Token URL: \(accessToken)")
                    oauthswift.request_token_url  = requestToken
                    oauthswift.authorize_url      = authorizeToken
                    oauthswift.access_token_url   = accessToken
                }
                
        //Authorization
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/oob")!, success: {
            credential, response in
            self.showAlertView("MyJohnDeere", message: "oauth_token:\(credential.oauth_token)\n oauth_token_secret:\(credential.oauth_token_secret)")
                print("\n Authorization Response:\(response)")
            
            //GET Organization
            oauthswift.client.get(self.getOrganizationURL, parameters: parameters as! Dictionary<String, AnyObject>,
                success: {
                    data, response in
                    print("Success.Parameters 3rd call:\(parameters)")
                    let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                    print(jsonDict)
                }, failure: {(error:NSError!) -> Void in
                    print("Failed.Parameters 3rd call:\(parameters)")
                    print(error)
            })
            }, failure: {(error:NSError!) -> Void in
                print(error.localizedDescription)
        })
        }, failure: {(error:NSError!) -> Void in
                print("Failed.API Catalog:\(parameters)")
                print(error)
        })
    }

    // MARK: GET Something

    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) -> Void {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            do {
                print(response)
                print(data)
                let object: String? = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? String
                onCompletion(object!,nil)
            } catch {
                print("json error: \(error)")
            }
        })
        task.resume()
    }
    
    func snapshot() -> NSData {
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let fullScreenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(fullScreenshot, nil, nil, nil)
        return  UIImageJPEGRepresentation(fullScreenshot, 0.5)!
    }

    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return services.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = services[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        doOAuthMyJohnDeere()
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
}
