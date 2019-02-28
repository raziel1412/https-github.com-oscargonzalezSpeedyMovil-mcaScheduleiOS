//
//  ScheduleCACVC.swift
//  mcaScheduleiOS
//
//  Created by Omar Israel Trujillo Osornio on 12/27/18.
//  Copyright © 2018 Speedy Movil. All rights reserved.
//

import UIKit
import mcaUtilsiOS
import mcaManageriOS

public class ScheduleCACVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var header : UIHeaderForm = UIHeaderForm(frame: .zero)
    private var frameTabBar = CGRect()
    var tableSchedule : UITableView!
    let vcLine = UIView()
    var dataSource = [String]()
    var dataSourceSubText = [String]()
    var heightNavigationBar: CGFloat = 0.0
    let conf = mcaManagerSession.getGeneralConfig()
    /// Variable que almacena el RUT
    var rut : String?
    /// Variable que almacena el correo electrónico
    var email : String?
    var name : String?
    // MARK: - ViewControlelr Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setupComponents()
        print("ENTRAMOS A AGENDAR CAC")
        AnalyticsInteractionSingleton.sharedInstance.ADBTrackView(viewName: "Soporte|Agendar citas en CAC", detenido: false)
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupComponents(){
        self.heightNavigationBar = 65.0
        
        
        let txtcacDatesHeader = mcaManagerSession.getGeneralConfig()?.translations?.data?.cacDatesTexts?.cacDatesHeader ?? "Agendar Hora"
        let txtcacDatesSecondButtonTitle = mcaManagerSession.getGeneralConfig()?.translations?.data?.cacDatesTexts?.cacDatesSecondButtonTitle ?? "Ver Horas Agendadas"
        let txtcacDatesFirstButtonDescription = mcaManagerSession.getGeneralConfig()?.translations?.data?.cacDatesTexts?.cacDatesFirstButtonDescription ?? "Elige la sucursal y la hora de tu cita."
        let txtcacDatesSecondButtonDescription = mcaManagerSession.getGeneralConfig()?.translations?.data?.cacDatesTexts?.cacDatesSecondButtonDescription ?? "Revisa la sucursal y la hora de tu cita."
        
        dataSource = [txtcacDatesHeader, txtcacDatesSecondButtonTitle]
        dataSourceSubText = [txtcacDatesFirstButtonDescription, txtcacDatesSecondButtonDescription]
        
        self.view.backgroundColor = institutionalColors.claroWhiteColor
        self.initWith(navigationType: .IconBack, headerTitle: conf?.translations?.data?.cacDatesTexts?.cacDatesHeader ?? "Agendar Hora")
        

        var height : CGFloat = 0
        if self.view.frame.height == 812{
            height = view.frame.height - frameTabBar.height - self.heightNavigationBar - 100
        }else{
            height = view.frame.height - frameTabBar.height - self.heightNavigationBar
        }
        
        
        tableSchedule = UITableView()
        tableSchedule.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
        tableSchedule.dataSource = self
        tableSchedule.delegate = self
        tableSchedule.separatorStyle = .none
        tableSchedule.backgroundColor = institutionalColors.claroWhiteColor
        self.view.addSubview(tableSchedule)
    }
    //MARK: UITableViewDelegate - UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let bordelCell = UIView()
        let cardCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        cardCell.textLabel?.text = dataSource[indexPath.row]
        cardCell.textLabel?.font = UIFont(name: RobotoFontName.RobotoBold.rawValue, size: CGFloat(20.0))
        cardCell.textLabel?.textColor = institutionalColors.claroBlackColor
        
        cardCell.detailTextLabel?.text = dataSourceSubText[indexPath.row]
        cardCell.textLabel?.font = UIFont(name: RobotoFontName.RobotoRegular.rawValue, size: CGFloat(14.0))
        cardCell.textLabel?.textColor = institutionalColors.claroBlackColor
        cardCell.detailTextLabel?.textColor = institutionalColors.claroBlueColor
        
        let accessoryView = UIImageView(image: mcaUtilsHelper.getImage(image: "ico_siguiente"))
        cardCell.accessoryView = accessoryView
        
        bordelCell.frame = CGRect(x: 10, y: 5, width:  tableView.frame.width - 20, height: 70)
        
        let border = SideView(Left: true, Right: true, Top: true, Bottom: true)
        bordelCell.addBorderLayer(sides: border, color: institutionalColors.claroLightGrayColor, thickness: 0.5)
        bordelCell.backgroundColor = UIColor .clear
        cardCell.addSubview(bordelCell)
        
        if indexPath.row == 0{
            cardCell.imageView?.image = mcaUtilsHelper.getImage(image: "ic_detalle_minutos") //#imageLiteral(resourceName: "ic_detalle_minutos")
        }else{
            cardCell.imageView?.image = mcaUtilsHelper.getImage(image: "ico-agendacion") //#imageLiteral(resourceName: "ico-agendacion")
        }
        
        return cardCell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0

    }
    ///Ajusta la altura de los header por seccion de las 3 tablas que se utilizan en las boletas
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 220.0
    }
    
    ///Creacion del header donde se escuentra la tabla con los tipos de opciones que tiene el usuario asignado
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        headerView.backgroundColor = institutionalColors.claroWhiteColor
        
        header.setupElements(imageName: "icon_seccion_soporte_centros", title: mcaManagerSession.getGeneralConfig()?.translations?.data?.cacDatesTexts?.cacDatesTitle ?? "¿Necesitas ir a una sucursal?", subTitle:  mcaManagerSession.getGeneralConfig()?.translations?.data?.cacDatesTexts?.cacDatesDescription ?? "Agenda una hora en tu sucursal más cercana, te ayudaremos a resolver tus dudas")
        
        header.frame = CGRect(x: 0.0, y: 0.0, width: self.tableSchedule.frame.width, height: headerView.frame.height)
        headerView.addSubview(header)
        vcLine.backgroundColor = institutionalColors.claroBlackColor
        vcLine.frame = CGRect(x: 0.0, y: headerView.frame.maxY + 15 , width: 100.0, height: 1)
        vcLine.center = CGPoint(x: UIScreen.main.bounds.width/2.0, y: vcLine.center.y)
        vcLine.sizeToFit()
        headerView.addSubview(vcLine)
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        
        rut = mcaManagerSession.getCurrentSession()?.retrieveProfileInformationResponse?.personalDetailsInformation?.rUT ?? ""
        email = mcaManagerSession.getCurrentSession()?.retrieveProfileInformationResponse?.contactMethods?.first?.emailContactMethodDetail?.emailAddress ?? ""
        name = mcaManagerSession.getCurrentSession()?.retrieveProfileInformationResponse?.personalDetailsInformation?.accountUserFirstName ?? ""

        if indexPath.row == 0{
            AnalyticsInteractionSingleton.sharedInstance.ADBTrackCustomLink(viewName: "Soporte|Agendar citas en CAC:Agendar cita")
            let webViewType = WebViewType.ScheduleCAC
            let urlString = (conf?.webViews?[safe:1]?.url ?? "https://reservaweb.clarochile.cl/agenda/asp/par_sel.asp").replacingOccurrences(of: " ", with: "") + "?rut=\(rut!)&correo=\(email!)&nombre=\(name!)&tiempo=\(10)"
            let info = GenericWebViewModel(headerTitle: conf?.translations?.data?.cacDatesTexts?.cacDatesHeader ?? "Agendar Hora", serviceSelected: webViewType, loadUrl: urlString, buttonNavType: ButtonNavType.IconBack  , reloadUrlSuccess:  nil, paidUrlSucces: nil)
            self.navigationController?.pushViewController(GenericWebViewVC(info: info), animated: true)
            
        }
        if indexPath.row == 1{
            AnalyticsInteractionSingleton.sharedInstance.ADBTrackCustomLink(viewName: "Soporte|Agendar citas en CAC:Ver citas agendadas")
            let webViewType = WebViewType.ScheduleCAC
            let info = GenericWebViewModel(headerTitle: conf?.translations?.data?.cacDatesTexts?.cacDatesViewDatesHeader ?? "Ver Citas Agendadas", serviceSelected: webViewType, loadUrl: conf?.webViews?[safe:2]?.url ?? "https://reservaweb.clarochile.cl/agenda/asp/hor_can.asp", buttonNavType: ButtonNavType.IconBack  , reloadUrlSuccess:  nil, paidUrlSucces: nil)
            self.navigationController?.pushViewController(GenericWebViewVC(info: info), animated: true)
        }
    }
    // MARK: - Target Actions

}

