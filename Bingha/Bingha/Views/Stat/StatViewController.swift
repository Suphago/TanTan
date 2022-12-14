//
//  StatViewController.swift
//  Bingha
//
//  Created by Terry Koo on 2022/07/27.
//

import UIKit
import Lottie

class StatViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    @IBAction func licenseButtonAction(_ sender: Any) {
        print("button touch")
        let uvc = self.storyboard!.instantiateViewController(withIdentifier: "licenseViewController")
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true)
    }
    
    //FIX: 추가됨
    let reducedCarbonCollectionViewModel: ReducedCarbonCollectionViewModel = ReducedCarbonCollectionViewModel()
    let compareViewModel: CompareViewModel = CompareViewModel()
    let statisticsViewModel: StatisticsViewModel = StatisticsViewModel()
    
    let segmentID: String = "CollectionViewSegmentControl"
    //FIX: 수정됨
    let reducedID: String = "ReducedCarbonCollectionView"
    let compareHeaderID = "CollectionViewCompareHeader"
    let compareID: String = "CompareCollectionViewCell"
    let statisticsHeaderID = "CollectionViewStatisticsHeader"
    let statisticsID: String = "StatisticsCollectionViewCell"
    
    // 컬렉션 뷰 안에 세그먼트 컨트롤러가 있어서 아웃렛 변수 선언이 안돼서 일반 변수로 처리.
    var selectedSegment = 0
    // 여기서 컨트롤 하면 될듯.statisticsViewModel에 들어갈 값 변경해주고, compareViewModel 들어갈 값만 변경해주면 끝. 굳굳.
    @IBAction func switchSegment(_ sender: UISegmentedControl) {
        // 세그먼트 변할 때 마다 데이터 매핑시켜주기.
        segmentSetData(sender: sender)
        collectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "ReducedCarbonCollectionView", bundle: nil), forCellWithReuseIdentifier: reducedID)
        collectionView.register(UINib(nibName: "CompareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: compareID)
        collectionView.register(UINib(nibName: "StatisticsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: statisticsID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 이 탭에 들어올때 한번 최신화 시켜줘야함
        segmentloadData()

        collectionView.register(UINib(nibName: "ReducedCarbonCollectionView", bundle: nil), forCellWithReuseIdentifier: reducedID)
        collectionView.register(UINib(nibName: "CompareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: compareID)
        collectionView.register(UINib(nibName: "StatisticsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: statisticsID)
        collectionView.reloadData()
    }
    
    func segmentSetData(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            StatisticsViewModel.statisticsList = StatisticsViewModel.todayStatisticsList
            CompareViewModel.compareList[0].compareAmount = ReducedCarbonCalculator.shared.reducedCarbonToTreeForStat(carbon: FirebaseController.todayTotalDecreaseCarbon)
            CompareViewModel.compareList[1].compareAmount = ReducedCarbonCalculator.shared.reducedCarbonToSeaweed(carbon: FirebaseController.todayTotalDecreaseCarbon)
            CompareViewModel.compareList[2].compareAmount = ReducedCarbonCalculator.shared.protectedGlacier(carbon: FirebaseController.todayTotalDecreaseCarbon)
            ReducedCarbonCollectionViewModel.reducedCarbonList[0] = ReducedCarbonCollection(reducedCarbonPeriod: "오늘 총 탄소배출 저감량", reducedCarbonAmount: FirebaseController.todayTotalDecreaseCarbon)
            selectedSegment = 0
        }
        else if sender.selectedSegmentIndex == 1 {
            StatisticsViewModel.statisticsList = StatisticsViewModel.weeklyStatisticsList
            CompareViewModel.compareList[0].compareAmount = ReducedCarbonCalculator.shared.reducedCarbonToTreeForStat(carbon: FirebaseController.weeklyTotalDecreaseCarbon)
            CompareViewModel.compareList[1].compareAmount = ReducedCarbonCalculator.shared.reducedCarbonToSeaweed(carbon: FirebaseController.weeklyTotalDecreaseCarbon)
            CompareViewModel.compareList[2].compareAmount = ReducedCarbonCalculator.shared.protectedGlacier(carbon: FirebaseController.weeklyTotalDecreaseCarbon)
            ReducedCarbonCollectionViewModel.reducedCarbonList[0] = ReducedCarbonCollection(reducedCarbonPeriod: "최근 3주 간 총 탄소배출 저감량", reducedCarbonAmount: FirebaseController.weeklyTotalDecreaseCarbon)
            selectedSegment = 1
        }
        else {
            StatisticsViewModel.statisticsList = StatisticsViewModel.monthlyStatisticsList
            CompareViewModel.compareList[0].compareAmount = ReducedCarbonCalculator.shared.reducedCarbonToTreeForStat(carbon: FirebaseController.monthlyTotalDecreaseCarbon)
            CompareViewModel.compareList[1].compareAmount = ReducedCarbonCalculator.shared.reducedCarbonToSeaweed(carbon: FirebaseController.monthlyTotalDecreaseCarbon)
            CompareViewModel.compareList[2].compareAmount = ReducedCarbonCalculator.shared.protectedGlacier(carbon: FirebaseController.monthlyTotalDecreaseCarbon)
            ReducedCarbonCollectionViewModel.reducedCarbonList[0] = ReducedCarbonCollection(reducedCarbonPeriod: "최근 3달 간 총 탄소배출 저감량", reducedCarbonAmount: FirebaseController.monthlyTotalDecreaseCarbon)
            selectedSegment = 2
        }
    }
    
    func segmentloadData() {
        // 여기 넣는 로직 작성.
        if selectedSegment == 0 {
            StatisticsViewModel.statisticsList = StatisticsViewModel.todayStatisticsList
            CompareViewModel.compareList[0].compareAmount = ReducedCarbonCalculator.shared.reducedCarbonToTreeForStat(carbon: FirebaseController.todayTotalDecreaseCarbon)
            CompareViewModel.compareList[1].compareAmount = ReducedCarbonCalculator.shared.reducedCarbonToSeaweed(carbon: FirebaseController.todayTotalDecreaseCarbon)
            CompareViewModel.compareList[2].compareAmount = ReducedCarbonCalculator.shared.protectedGlacier(carbon: FirebaseController.todayTotalDecreaseCarbon)
            ReducedCarbonCollectionViewModel.reducedCarbonList[0] = ReducedCarbonCollection(reducedCarbonPeriod: "오늘 총 탄소배출 저감량", reducedCarbonAmount: FirebaseController.todayTotalDecreaseCarbon)
            
        }
        else if selectedSegment == 1 {
            StatisticsViewModel.statisticsList = StatisticsViewModel.weeklyStatisticsList
            CompareViewModel.compareList[0].compareAmount = ReducedCarbonCalculator.shared.reducedCarbonToTreeForStat(carbon: FirebaseController.weeklyTotalDecreaseCarbon)
            CompareViewModel.compareList[1].compareAmount = ReducedCarbonCalculator.shared.reducedCarbonToSeaweed(carbon: FirebaseController.weeklyTotalDecreaseCarbon)
            CompareViewModel.compareList[2].compareAmount = ReducedCarbonCalculator.shared.protectedGlacier(carbon: FirebaseController.weeklyTotalDecreaseCarbon)
            ReducedCarbonCollectionViewModel.reducedCarbonList[0] = ReducedCarbonCollection(reducedCarbonPeriod: "최근 3주 간 총 탄소배출 저감량", reducedCarbonAmount: FirebaseController.weeklyTotalDecreaseCarbon)
        }
        else {
            StatisticsViewModel.statisticsList = StatisticsViewModel.monthlyStatisticsList
            CompareViewModel.compareList[0].compareAmount = ReducedCarbonCalculator.shared.reducedCarbonToTreeForStat(carbon: FirebaseController.monthlyTotalDecreaseCarbon)
            CompareViewModel.compareList[1].compareAmount = ReducedCarbonCalculator.shared.reducedCarbonToSeaweed(carbon: FirebaseController.monthlyTotalDecreaseCarbon)
            CompareViewModel.compareList[2].compareAmount = ReducedCarbonCalculator.shared.protectedGlacier(carbon: FirebaseController.monthlyTotalDecreaseCarbon)
            ReducedCarbonCollectionViewModel.reducedCarbonList[0] = ReducedCarbonCollection(reducedCarbonPeriod: "최근 3달 간 총 탄소배출 저감량", reducedCarbonAmount: FirebaseController.monthlyTotalDecreaseCarbon)
        }
    }
    
    
}

//컬렉션뷰 익스텐션
extension StatViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //컬렉션뷰 섹션 개수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    //컬렉션뷰 섹션당 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            //세그먼트 컨트롤 섹션
        case 0: return 1
            //해당 기간 탄소 절감량 섹션. 이건 한개 이상 늘어날 일 없으니 안 바꿨습니다.
        case 1: return 1
            //비교 헤더 섹션
        case 2: return 1
            //비교 섹션: 3개. 나중에 추가될수도 있으니까 이거로
        case 3: return compareViewModel.countOfCompareList
            //걷기 모음 헤더 섹션
        case 4: return 1
            //걷기 모음 섹션: 걷기 횟수만큼
        case 5: return statisticsViewModel.countOfStatisticsList
        default:
            return 0
        }
    }
    
    //컬렉션뷰 섹션별로 셀 가져와서 업데이트
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        // 세그먼트 컨트롤. 태그번호로 가져오고 첫번째 세그먼트 기본으로.
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: segmentID, for: indexPath)
            if let segment = cell.viewWithTag(0) as? UISegmentedControl {
                segment.selectedSegmentIndex = 0
                //TODO: 세그먼트 컨트롤 동작 구현하기
            }
            return cell
            
        //FIX: 탄소저감량 섹션
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reducedID, for: indexPath) as! ReducedCarbonCollectionView
            let ReducedInfo = reducedCarbonCollectionViewModel.ReducedCarbonModelInfo(at: indexPath.item)
            cell.update(info: ReducedInfo)
            return cell
        
        //비교 헤더 섹션
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: compareHeaderID, for: indexPath)
            return cell
            
        //비교 섹션
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: compareID, for: indexPath) as! CompareCollectionViewCell
            let compareInfo = compareViewModel.CompareModelInfo(at: indexPath.item)
            cell.update(info: compareInfo)
            return cell
            
        //걷기 모음 헤더 섹션
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: statisticsHeaderID, for: indexPath)
            return cell
            
        //걷기 모음 섹션
        case 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: statisticsID, for: indexPath) as! StatisticsCollectionViewCell
            let statisticInfo = statisticsViewModel.statisticsInfo(at: indexPath.item)
            cell.update(info: statisticInfo)
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: statisticsID, for: indexPath) as! StatisticsCollectionViewCell
            let statisticInfo = statisticsViewModel.statisticsInfo(at: indexPath.item)
            cell.update(info: statisticInfo)
            return cell
        }
    }
    
    //컬렉션뷰 섹션 안 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            let width: CGFloat = collectionView.bounds.width-40
            return CGSize(width: width, height: 40)
        case 1:
            let width: CGFloat = collectionView.bounds.width-40
            return CGSize(width: width, height: 90)
        case 2:
            let width: CGFloat = collectionView.bounds.width-40
            return CGSize(width: width, height: 40)
        case 3:
            let width: CGFloat = collectionView.bounds.width-40
            let height: CGFloat = 150
            return CGSize(width: width, height: height)
        case 4:
            let width: CGFloat = collectionView.bounds.width-40
            return CGSize(width: width, height: 40)
        case 5:
            let itemSpacing: CGFloat = 14
            let width: CGFloat = (collectionView.bounds.width - itemSpacing) / 2.25
            return CGSize(width: width, height: width)
        default:
            let itemSpacing: CGFloat = 14
            let width: CGFloat = (collectionView.bounds.width - itemSpacing)
            return CGSize(width: width, height: width)
        }
    }
    
    //컬렉션뷰 내부 인셋
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section{
        case 2:
            return UIEdgeInsets(top: 0, left: 20, bottom: 5, right: 20)
        case 4:
            return UIEdgeInsets(top: 10, left: 20, bottom: 5, right: 20)
        default:
            return UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)

        }
    }
}


