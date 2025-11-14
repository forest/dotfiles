# The Core Challenge: Fragile Tests at Multiple Levels

**The Problem:** Both acceptance tests (story-level) and unit tests (sub-task level) can be fragile when not written well. Even small system changes often cause test breakages. We need durable tests that separate WHAT the system should do from HOW it does it at both levels.

**The Solution:** Apply the four-layer architecture at both levels - acceptance tests for complete user stories and unit tests for individual sub-tasks  that separates WHAT the system should do from HOW it does it.

# Test Types and Their Purpose

## Acceptance Tests (User Story Level)
**Definition (Brian Marick's Model):** Tests that are **business-facing** and **support programming**

**Key Characteristics:**
- Test **complete user stories** end-to-end
- Written from perspective of **external user** of the system
- Focus on **WHAT** the system does for users
- Evaluate system in **life-like scenarios**
- Executed in **production-like test environments**
- When written before code, they become executable specifications that drive development

## Unit Tests (Sub-Task Level)
**Definition:** Tests that verify **individual sub-task functionality** in isolation

**Key Characteristics:**
- Test **single sub-task increments** 
- Written from perspective of **developer using the component**
- Focus on **WHAT** the component does, not **HOW** it works internally
- Can be executed quickly and independently
- Drive development of individual commits through ATDD

# The Four-Layer Architecture (Applied at Both Levels)
## Layer 1: Test Cases (Executable Specifications)

**Purpose:** Express user scenarios in problem domain language only

**Example:**

```
@Test
void shouldAllowUserToBuyBook() {
    goToStore();
    searchForBook("Continuous Delivery");
    selectBookByAuthor("Jez Humble");
    addSelectedBookToShoppingBasket();
    checkout();
    payWithCreditCard();
    assertThat(itemHasBeen("purchased"));
}
```

**Key Properties:**

- Says **nothing** about how the system works
- Uses same language as user story outline
- Could apply to **any** bookstore (Amazon, physical store, etc.)
- Focuses purely on **user behavior and outcomes**

## Layer 2: DSL (Domain Specific Language)

**Purpose:** Make it easy to encode and capture test cases with good reuse

**Responsibilities:**

- Provides collection of **shared behaviors** across test cases
- Handles **optional parameters** and **default values**
- Creates **aliases** for system names (enables repeatable test runs)
- Parses inputs and manages test data
- **Optimized for writing test cases quickly and efficiently**

**Example:**

```
public void checkout(PaymentMethod paymentMethod, Address shippingAddress) {
    // Handle optional parameters with defaults
    // Parse inputs for different scenarios
    // Call down to protocol driver layer
    protocolDriver.performCheckout(paymentMethod, shippingAddress);
}
```

## Layer 3: Protocol Driver

**Purpose:** Translate problem domain language into real system interactions

**Key Insight:** Interface to protocol driver is **still high-level and abstract** (still uses problem domain language like "checkout")

**Responsibilities:**

- **Only layer** that knows how the system actually works
- Translates abstract concepts into concrete system interactions:
    - **UI testing:** Uses Selenium to find fields, click buttons
    - **API testing:** Makes HTTP calls to REST endpoints
    - **Message-based:** Generates and sends messages
    - **Whatever the natural interface** of your system is

**Example:**

```
public void performCheckout() {
    // This layer knows about Selenium, web elements, etc.
    driver.findElement(By.id("checkout-button")).click();
    driver.findElement(By.name("credit-card")).sendKeys(creditCardNumber);
    // ... actual system interactions
}
```

## Layer 4: System Under Test

**Purpose:** The actual system deployed in production-like test environment
# The Power of Separation of Concerns

## Test Reusability

**Same test case can work with different implementations:**

- Web application (via Selenium)
- Mobile app (via Appium)
- API (via HTTP calls)
- Physical robot in real store
- Voice interface
- Thought-controlled interface

**Only the protocol driver changes - test cases remain identical.**

## Maintenance Benefits

- **Test cases don't break** when UI changes
- **Only protocol driver needs updates** when system interface changes
- **Shared DSL** means fixing one method fixes multiple tests
- **Test cases remain correct** even when system is broken

## Development Benefits

- **Executable specifications** drive development from outside-in
- **Clear separation** between business requirements and technical implementation
- **Faster test writing** through DSL reuse
- **Better communication** with non-technical stakeholders

# Implementation Approaches

### Internal DSL (Preferred)

- Hosted in regular programming language (Java, C#, Python, etc.)
- Get all the tools of the programming language
- Examples shown use Java internal DSL

## External DSL

- Explicitly different language (Gherkin/Cucumber, SpecFlow)
- Same four-layer principles apply
- Feature steps become the DSL layer
- Step definitions become the protocol driver layer

# Key Design Principles

## Test Case Layer Rules:

- **No technical details** - no mention of buttons, fields, URLs
- **Problem domain language only** - "buy book," not "click checkout button"
- **System agnostic** - should work for any implementation
- **User behavior focused** - what user wants to achieve

## DSL Layer Rules:

- **Optimized for test writing** - make common cases easy
- **Handle complexity** - optional parameters, defaults, aliases
- **Promote reuse** - shared behaviors across tests
- **Still abstract** - no system-specific details

## Protocol Driver Rules:

- **Only layer that knows system details** - UI elements, API endpoints, etc.
- **Translates abstractions** - from "checkout" to actual system calls
- **Handles system interface** - whatever the natural interface is
- **Isolates system coupling** - contains all fragile system dependencies

# Example: Book Purchase Test Case

**User Story:** "I want to pay for books with a credit card"

**Test Steps in Problem Domain Language:**

1. Go to store
2. Search for book ("Continuous Delivery")
3. Select book from results
4. Add book to shopping cart
5. Go to checkout
6. Pay with credit card
7. Assert book is purchased

**Key Insight:** This description works for Amazon, Barnes & Noble, physical bookstore, or any future implementation. Only the protocol driver changes.

# Wiring acceptance and unit tests

## File Organization Structure

### **For Acceptance Tests (User Story Level):**
- **Layer 1:** `tests/acceptance/test_[story].py` - User story executable specifications
- **Layer 2:** `tests/acceptance/story_dsl.py` - Story-level domain language  
- **Layer 3:** `tests/acceptance/[system]_driver.py` - System-level protocol driver
- **Layer 4:** Complete integrated system

### **For Unit Tests (Sub-Task Level):**
- **Layer 1:** `tests/unit/test_[module].py` - Sub-task executable specifications
- **Layer 2:** `tests/unit/dsl.py` - Component-level domain language
- **Layer 3:** `tests/unit/[module]_protocol_driver.py` - Component protocol driver  
- **Layer 4:** Individual module/component (e.g., `src/package/module.py`)

## Example: Authentication Story vs Sub-Task

### **Acceptance Test (Story Level)**
Tests the complete user story: "Access Google Docs Services for Document Automation"

**File:** `tests/acceptance/test_authentication_story.py`
```python
from story_dsl import given, when, then

class TestAuthenticationStory:
    
    def test_developer_can_authenticate_and_create_documents(self):
        """Complete story: Developer authenticates and creates documents"""
        # Given
        developer = given.a_developer_with_valid_credentials()
        
        # When  
        developer = when.developer_initializes_authentication()
        document = when.developer_creates_a_new_document()
        
        # Then
        then.document_is_created_successfully(document)
        then.document_has_caylent_branding(document)
```

### **Unit Test (Sub-Task Level)**  
Tests individual sub-task: "Load credentials from file path"

**File:** `tests/unit/test_auth.py`
```python
from dsl import given, when, then

class TestCredentialLoading:
    
    def test_should_load_valid_credentials_from_file(self):
        """Sub-task: Load credentials from file"""
        # Given
        credentials_file = given.a_valid_credentials_file_at("./location.json")
        
        # When
        credentials = when.developer_loads_credentials_from_file(credentials_file)
        
        # Then
        then.credentials_are_valid_for_service_account(credentials)
```

# Layer Implementation Examples

## Layer 2: Domain Specific Language (Different Levels)

### **Story-Level DSL** (`tests/acceptance/story_dsl.py`)
```python
class StoryDsl:
    def a_developer_with_valid_credentials(self):
        """Set up complete developer environment"""
        return self.system_driver.setup_developer_environment()
    
    def developer_creates_a_new_document(self):
        """End-to-end document creation"""
        return self.system_driver.create_document_through_library()

# Export for story-level testing
story_dsl = StoryDsl()
given = story_dsl
when = story_dsl  
then = story_dsl
```

### **Component-Level DSL** (`tests/unit/dsl.py`)
```python
class TestDsl:
    def a_valid_credentials_file_at(self, file_path: str):
        """Create test credential file"""
        return self.protocol_driver.create_temp_credentials_file(file_path)
    
    def developer_loads_credentials_from_file(self, credentials_file):
        """Test credential loading component"""
        return self.protocol_driver.load_credentials_file(credentials_file)

# Export for unit testing
dsl = TestDsl()
given = dsl
when = dsl
then = dsl
```

## Layer 3: Protocol Driver (Different Scopes)

### **System Driver** (`tests/acceptance/system_driver.py`)
```python
class SystemDriver:
    """Drives the complete integrated system"""
    
    def setup_developer_environment(self):
        """Set up complete environment including credentials, APIs, etc."""
        # Sets up entire system for story testing
        
    def create_document_through_library(self):
        """Test complete document creation workflow"""
        # Uses the actual library API as a developer would
        from caylent_docs_lib import CaylentDocsClient
        client = CaylentDocsClient()
        return client.create_document("Test Doc")
```

### **Component Driver** (`tests/unit/auth_protocol_driver.py`)  
```python
class AuthProtocolDriver:
    """Drives individual authentication component"""
    
    def load_credentials_file(self, file_path):
        """Test just the credential loading component"""
        # Only tests the CaylentCredentials component
        from caylent_docs_lib.auth import CaylentCredentials
        return CaylentCredentials.load_from_file(file_path)
```

# When to Use Each Level

## Acceptance Tests (Story Level)
- **Purpose**: Verify complete user stories work end-to-end
- **Scope**: Full system integration 
- **Frequency**: Run before story completion
- **Focus**: User outcomes and business value

## Unit Tests (Sub-Task Level)  
- **Purpose**: Verify individual sub-task functionality
- **Scope**: Single component or module
- **Frequency**: Run with each commit (ATDD workflow)
- **Focus**: Component behavior and developer interface

# ATDD Workflow Integration

## Story Level (Acceptance Tests):
1. **Write story acceptance test** - defines complete user story behavior
2. **Break into sub-tasks** - each sub-task contributes to story completion
3. **Story test fails** (RED) - because sub-tasks aren't implemented yet
4. **Complete sub-tasks** using unit-level ATDD
5. **Story test passes** (GREEN) - when all sub-tasks are complete

## Sub-Task Level (Unit Tests):
1. **Write unit test** for sub-task behavior
2. **Test fails** (RED) - because component doesn't exist yet  
3. **Write minimal implementation** to pass test
4. **Test passes** (GREEN) - sub-task is complete
5. **Commit to trunk** - one working increment delivered

# Key Design Principles

## Acceptance Test Rules (Story Level):
- **Complete user workflows** - test entire user journeys
- **Business outcomes** - verify user value is delivered
- **System integration** - test how components work together
- **Production-like environment** - realistic test conditions

## Unit Test Rules (Sub-Task Level):
- **Component isolation** - test individual pieces
- **Developer interface** - test how developers use the component
- **Fast execution** - enable rapid feedback during development
- **Implementation independence** - survive internal changes

---

**Core Takeaway:** Apply the four-layer architecture at both story level (acceptance tests) and sub-task level (unit tests). This creates a comprehensive testing strategy where acceptance tests verify complete user value while unit tests enable rapid development of individual components through ATDD.