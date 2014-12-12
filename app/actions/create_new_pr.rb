class CreateNewPr
  def initialize(payload_parser, *)
    @payload_parser = payload_parser
  end

  def self.matches(payload_parser, *)
    payload_parser.action == "opened"
  end

  def call
    pull_request = PullRequest.create(payload_parser.params.merge(tags: tags))
    post_to_slack(pull_request)
  end

  protected

  attr_reader :payload_parser

  private

  def tags
    @tags ||= begin
      tag_names = TagParser.new.parse(payload_parser.body)

      if tag_names.empty?
        tag_names = ["code"]
      end

      tag_names.map(&Tag.method(:with_name))
    end
  end

  def post_to_slack(pull_request)
    WebhookNotifier.new(pull_request).send_notification
  end
end
