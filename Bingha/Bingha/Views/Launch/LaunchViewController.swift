//
//  LaunchViewController.swift
//  Bingha
//
//  Created by ryu hyunsun on 2022/07/30.
//

import UIKit

class LaunchViewController: UIViewController {
    let firebaseController = FirebaseController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 파이어베이스에서 데이터 로드.
        let isFirst = checkIsFirst()
        pullFirebaseData()
        // 온보딩을 봤는지 안봤는지 체크하기. 유저디폴트에서 꺼내 확인한다. isFirst만 바꿔주면 됨!
        // 데이터 다 불러와지면 넘기게!
        DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .seconds(1))) { [weak self] in
            self?.changeView(isFirst: isFirst)
        }
    }
    
    func changeView(isFirst: Bool) {
        if isFirst {
            // TODO: 온보딩 완성되면 연결해주기.
            let st = UIStoryboard(name: "Onboarding", bundle: nil)
            let vc = st.instantiateViewController(withIdentifier: "OnboardingViewController")
            let scenes = UIApplication.shared.connectedScenes
            let windowScenes = scenes.first as? UIWindowScene
            if let window = windowScenes?.windows.first {
                window.rootViewController = vc
            }
        }
        // 깔깔깔 해치웠다.
        else {
            let st = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = st.instantiateViewController(withIdentifier: "TabBar")
            let scenes = UIApplication.shared.connectedScenes
            let windowScenes = scenes.first as? UIWindowScene
            if let window = windowScenes?.windows.first {
                window.rootViewController = vc
            }
        }
    }
    
    func pullFirebaseData() {
        Task {
            try await firebaseController.loadTodayCarbonData()
        }
        Task {
            try await firebaseController.loadIcebergData()
        }
        Task {
            try await firebaseController.loadMonthlyData()
        }
        Task {
            try await firebaseController.loadWeeklyData()
        }
    }
    
    func checkIsFirst() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirst") == nil || defaults.object(forKey: "isFirst") as? Bool == true {
            defaults.set(true, forKey:"isFirst")
            return true
        } else {
            return false
        }
        
    }
    
}
