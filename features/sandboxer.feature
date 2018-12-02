Feature: Jenkins API connection
  If config is provided
  CLI command will connect and authorise in Jenkins

  Scenario: Test Connection
    When I run `sandboxer test`
    Then the output should contain "Gross!"

  # Scenario: Default Build
    # When I run `sandboxer build`
    # Then the output should contain "Tomatoes"
