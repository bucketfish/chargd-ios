import AppIntents

struct IntentProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        return [AppShortcut(intent: RunChargdIntent(), phrases: [
        "Run Chargd"])]
    }
}

struct RunChargdIntent: AppIntent {
    static var title: LocalizedStringResource = "Run Chargd"
    static var description = IntentDescription("Chargd will run when you plug in or out your charger.")
    
    func perform() async throws -> some ReturnsValue {
        postUpdate()

        return .result(value: "")
    }
}
