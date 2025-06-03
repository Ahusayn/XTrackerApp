//
//  ExportData.swift
//  XTracker
//
//  Created by HSSN on 27/05/2025.
//



import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct ExportData: View {
    @Environment(\.modelContext) private var context
    @Query private var transactions: [TransactionModel]
    
    @State private var fileURL: URL?
    @State private var showShareSheet = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Export Your Transactions")
                .font(.title2)
                .padding(.top)

            Button("Export as CSV") {
                guard !transactions.isEmpty else {
                    print("⚠️ No transactions to export.")
                    return
                }

                let csv = generateCSV(from: transactions)

                if let url = saveCSVAndExport(csv) {
                    presentShareSheet(with: url) // 🔥 Insantly shows the native Apple sheet
                } else {
                    print("⚠️ Failed to prepare file for sharing.")
                }
            }

            .buttonStyle(.borderedProminent)
            .padding(.horizontal)

            Text("After tapping Export, choose **'Save to Files'** in the share sheet to save the CSV permanently on your device.")
                .font(.footnote)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showShareSheet) {
            if let fileURL = fileURL {
                ShareSheet(activityItems: [fileURL])
            }
        }
    }

    // MARK: - CSV Generation
    func escapeCSV(_ value: String) -> String {
        "\"\(value.replacingOccurrences(of: "\"", with: "\"\""))\""
    }

    func generateCSV(from transactions: [TransactionModel]) -> String {
        var csv = "Date,Amount,Comment,Category,Type,PaymentType,Account\n"
        for tx in transactions {
            let date = tx.date.formatted(date: .numeric, time: .omitted)
            let line = [
                escapeCSV(date),
                "\(tx.amount)",
                escapeCSV(tx.comment),
                escapeCSV(tx.selectedCategory.name),
                escapeCSV(tx.type.rawValue),
                escapeCSV(tx.paymentType),
                escapeCSV(tx.account?.name ?? "N/A")
            ].joined(separator: ",")
            csv += line + "\n"
        }
        return csv
    }

    // MARK: - File Writing
    func saveCSVAndExport(_ csv: String) -> URL? {
        let fileName = "Transactions.csv"
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        do {
            let data = csv.data(using: .utf8)!
            try data.write(to: fileURL, options: .atomic)
            
            let fileSize = try Data(contentsOf: fileURL).count
            print("✅ CSV saved: \(fileURL)")
            print("📦 File size: \(fileSize) bytes")
            
            return fileSize > 0 ? fileURL : nil
        } catch {
            print("❌ Failed to save file: \(error)")
            return nil
        }
    }
    
    func presentShareSheet(with url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }

}

#Preview {
    ExportData()
}
