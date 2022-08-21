
@testable import miniReddit
import XCTest

class MainPostsTableViewDelegateProviderTests: XCTestCase {
    
    func testMainPostsTableViewDelegateProvider_RowsCount_EqualRowsCountInProvider() throws {
        // Given
        let provider = MockedPostsProvider()
        provider.rows.append(PostsCellModelStubs.one)
        
        let imageLoader = MockedPostsImageLoader()
        
        let sut = makeSUT(provider: provider, imageLoader: imageLoader)
        
        // When
        
        // Then
        XCTAssertEqual(sut.rowsCount, provider.rows.count)
    }
    
    func testMainPostsTableViewDelegateProvider_PostIdentifier_EqualPostIdentifierInProvider() throws {
        // Given
        let provider = MockedPostsProvider()
        provider.rows.append(PostsCellModelStubs.one)
        
        let imageLoader = MockedPostsImageLoader()
        
        let sut = makeSUT(provider: provider, imageLoader: imageLoader)
        
        // When
        
        // Then
        XCTAssertEqual(sut.postIdentifier(at: 0), provider.rows.first?.id)
    }
    
    func testMainPostsTableViewDelegateProvider_ConfiguredCell_MakeCell() throws {
        // Given
        let provider = MockedPostsProvider()
        let cellModel = PostsCellModelStubs.one
        provider.rows.append(cellModel)
        
        let imageLoader = MockedPostsImageLoader()
        
        let tableView = MockedPostsView()
        tableView.register(MockedPostsCell.self)
        
        let sut = makeSUT(provider: provider, imageLoader: imageLoader)

        // When
        let cell = sut.configuredCell(tableView: tableView, indexPath: .init(row: 0, section: 0)) as? MockedPostsCell
        
        // Then
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.title, cellModel.title)
        XCTAssertEqual(cell?.ratio, cellModel.content.ratio)
        XCTAssertEqual(cell?.image, nil)
    }
    
    func testMainPostsTableViewDelegateProvider_OnCellWillDisplay_UpdateCell() throws {
        // Given
        let provider = MockedPostsProvider()
        let cellModel = PostsCellModelStubs.one
        provider.rows.append(cellModel)
        
        let imageLoader = MockedPostsImageLoader()
        let postImage = UIImage(systemName: "circle")
        imageLoader.image = postImage
        
        let cell = MockedPostsCell()
        let promise = expectation(description: "Update cell content with DispatchQueue.main.async")
        cell.completion = { promise.fulfill() }
        
        let sut = makeSUT(provider: provider, imageLoader: imageLoader)
        
        // When
        sut.onCellWillDisplay(cell, indexPath: .init(row: 0, section: 0))
        
        wait(for: [promise], timeout: 0.1)
        
        //Then
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell.id, cellModel.id)
        XCTAssertEqual(cell.image, postImage)
    }
    
    func testMainPostsTableViewDelegateProvider_OnCellDidEndDisplaying_StopImageLoading() throws {
        // Given
        let provider = MockedPostsProvider()
        let cellModel = PostsCellModelStubs.one
        provider.rows.append(cellModel)
        
        let imageLoader = MockedPostsImageLoader()
        
        let sut = makeSUT(provider: provider, imageLoader: imageLoader)
        
        // When
        sut.onCellDidEndDisplaying(for: 0)
        
        //Then
        XCTAssertNotNil(imageLoader.stopURL)
        XCTAssertEqual(imageLoader.stopURL, cellModel.content.url)
        XCTAssertEqual(imageLoader.stopCounter, 1)
    }
    
    func testMainPostsTableViewDelegateProvider_OnCellPrefetching_StartImageLoading() throws {
        // Given
        let provider = MockedPostsProvider()
        let cellModel = PostsCellModelStubs.one
        provider.rows.append(cellModel)

        let imageLoader = MockedPostsImageLoader()

        let tableView = MockedPostsView()
        let indexPath = IndexPath.init(row: 0, section: 0)
        let indexPaths: [IndexPath] = [indexPath]
        
        let sut = makeSUT(provider: provider, imageLoader: imageLoader)

        // When
        sut.onCellPrefetching(tableView: tableView, indexPaths: indexPaths)

        //Then
        XCTAssertNotNil(imageLoader.startURL)
        XCTAssertEqual(imageLoader.startURL, cellModel.content.url)
        XCTAssertEqual(imageLoader.startCounter, 1)
    }
    
    func testMainPostsTableViewDelegateProvider_OnCellPrefetching_LoadNewRows() throws {
        // Given
        let provider = MockedPostsProvider()
        let cellModel = PostsCellModelStubs.one
        provider.rows.append(cellModel)
        
        var loadRowsCounter = 0
        provider.loadRowsCompletion = { loadRowsCounter = 1 }

        let imageLoader = MockedPostsImageLoader()

        let tableView = MockedPostsView()
        let indexPath = IndexPath.init(row: 0, section: 0)
        let indexPaths: [IndexPath] = [indexPath]
        
        let sut = makeSUT(provider: provider, imageLoader: imageLoader)

        // When
        sut.onCellPrefetching(tableView: tableView, indexPaths: indexPaths)

        //Then
        XCTAssertEqual(loadRowsCounter, 1)
    }
    
    func testMainPostsTableViewDelegateProvider_OnCellPrefetching_NotLoadNewRows() throws {
        // Given
        let provider = MockedPostsProvider()
        let cellModel = PostsCellModelStubs.one
        provider.rows.append(cellModel)
        provider.rows.append(cellModel)
        
        var loadRowsCounter = 0
        provider.loadRowsCompletion = { loadRowsCounter = 1 }

        let tableView = MockedPostsView()
        let indexPath = IndexPath.init(row: 0, section: 0)
        let indexPaths: [IndexPath] = [indexPath]
        
        let sut = makeSUT(provider: provider, imageLoader: MockedPostsImageLoader())

        // When
        sut.onCellPrefetching(tableView: tableView, indexPaths: indexPaths)

        //Then
        XCTAssertEqual(loadRowsCounter, 0)
    }
    
    func testMainPostsTableViewDelegateProvider_OnCellCancelPrefetching_StopImageLoading() throws {
        // Given
        let provider = MockedPostsProvider()
        let cellModel = PostsCellModelStubs.one
        provider.rows.append(cellModel)
        
        let imageLoader = MockedPostsImageLoader()
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let indexPaths: [IndexPath] = [indexPath]
        
        let sut = makeSUT(provider: provider, imageLoader: imageLoader)
        
        // When
        sut.onCellCancelPrefetching(at: indexPaths)
        
        //Then
        XCTAssertNotNil(imageLoader.stopURL)
        XCTAssertEqual(imageLoader.stopURL, cellModel.content.url)
        XCTAssertEqual(imageLoader.stopCounter, 1)
    }
}

//MARK: - Helpers
extension MainPostsTableViewDelegateProviderTests {
    
    private func makeSUT(
        provider: PostsProvider,
        imageLoader: PostsImageLoader
    ) -> PostsTableViewDelegateProvider {
        
        MainPostsTableViewDelegateProvider<MockedPostsCell>(
            provider: provider,
            imageLoader: imageLoader
        )
    }
}
