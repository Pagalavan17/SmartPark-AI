abstract class ISupportRepository {
  Future<List<Map<String, String>>> getFaqs();
  Future<void> submitTicket(String title, String description);
}
