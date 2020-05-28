## **Reactive** Programming
### *The flow of app state*

---

> *[An app] is not something that you just dump something on. It's not a big truck.* It's a series of tubes.
-- Ted Stevens

^ One of the more overused memes out there, but it can actually be a pretty helpful metaphor.

---

![](images/pipes.jpg)

---

Route the plumbing
+
Attach pressure gauges (side-effects)
+
Connect the sources / sinks
+
Let it flow

![](images/pipes.jpg)

---

**Use case:**
App that can search for GitHub repositories and display them in a list

---

# Imperative

1. Listen for search button callback (target/action)
2. Read value of text field and **call** search API
3. Listen for search API callback (closure)
4. **Parse** response and **update** data source with models
5. **Reload** table view and configure/display cells

---

# Reactive

1. Describe search query as a **relationship** between the text field and the search button
2. Describe **transformation** from search text to API response
3. Describe **transformation** from response to cell models
4. Create **binding** from cell models to the table view

---

> Don't you still need to do all the "Imperative" things?
-- You, an astute listener

---

Yes! But...
The difference is in the way we **think** about state

---

# Imperative

**Update** data source with models

 ==

**Mutate** a state variable

---

# Reactive

**Relationships**

&&

**Transformations**

---

# *Demo*
