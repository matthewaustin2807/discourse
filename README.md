[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=16407529&assignment_repo_type=AssignmentRepo)
# Final Project - Young Justice
## Discourse: One Stop App for Anything Related to Course Review and Student Needs

## Software Requirements and Specifications
### Purpose
#### Background
Students, especially in their first year of enrollment, often find difficulties while looking for courses to enroll in. Even after receiving guidance from their academic advisors, sometimes there could be multiple sections of the same course with different instructors each with different teaching styles. Our proposed application deals with this problem, where students could browse for all available courses offered during the academic calendar and find reviews submitted by students who have taken the course in the past. The application will also provide the necessary metrics students could use to compare different courses and instructors to find the one that best suits their learning needs. Our platform will also provide a marketplace where students can buy, sell and exchange used course materials.

#### Definitions
Metrics: All information which describes how a course is carried out. This includes, but is not limited to the workload, lecture styles, workload formats, workload distribution across the semester, attendance policies, interaction with instructors, etc. 

Marketplace: A dedicated space where students can search for used course materials, with the intent to either buy or exchange them. Students can also list their used course materials within this space.  

Course Materials: Documents related to the course such as syllabus, textbooks and notes. Thorough verifications will be done to ensure no unauthorized materials such as exams and quizzes are published. 

### Overall Description
#### User Characteristics
- Age: 18-30 
- Gender: All genders 
- Main Focus: NEU undergraduate and graduate students seeking assistance with selecting courses, comparing instructors, and exchanging course materials. 

#### User Stories
User stories describe the functionality from the user's perspective. Here are some user stories for the NEU Class Navigator app: 

- As a student, I want to browse and view all available courses for the upcoming academic calendar. 
- As a student, I want to read reviews of courses written by students who have previously taken them. 
- As a student, I want to see metrics such as course workload, attendance policy, and instructor interaction. 
- As a student, I want to compare different course sections and instructors to choose the best fit for my learning style. 
- As a student, I want to post my reviews of courses and professors after completing them. 
- As a student, I want to be able to exchange used textbooks and course materials with other students. 
- As a student, I want to ensure that only authorized materials such as textbooks and notes are listed in the marketplace. 
- As a student, I want to interact with other students by posting questions and discussing courses through the app. 
- As a student, I want to be able to message other students privately to ask about course-specific concerns. 
- As a student, I want the app to pull in data from external platforms like RateMyProfessor to get comprehensive insights without visiting multiple sites. 
- As a student, I want my data and interactions within the app to be secure and private.

#### App Workflow
![appworkflow](appworkflow.png)

### Requirements
#### Functional Requirements (Critical Features are Listed as Bold): 
- **The app shall allow students to view detailed course data, such as workload, lecture styles, and attendance policies.** 
- **The app shall allow students to post reviews of courses and instructors after completing the course.**
- **The app shall display student reviews of courses, including pros and cons, workload descriptions, and overall ratings, etc.** 
- **The app shall provide a comparison tool for students to compare the difference between courses or instructors.** 
- **The app shall allow students to list their used course materials in the marketplace for sale or exchange.** 
- **The app shall allow students to search for used course materials in a dedicated marketplace.** 
- **The app shall allow students to post questions and participate in discussions about specific courses.**
- **The app shall allow students to save courses they prefer for future reference.**
- The app shall provide data from external platforms (e.g., RateMyProfessor) for additional insights on instructors to users. 
- The app shall allow students to update or delete their reviews and posts. 
- The app shall include an advanced search function for students to filter courses by metrics like workload, teaching style, and instructor. 
- The app shall provide a private messaging function for students to communicate about course-related concerns. 
- The app shall offer a feedback function for students to report biased reviews or inappropriate course materials. 

#### Non-Functional Requirements (Critical features are Listed as Bold)
- **The app shall be accessible to screen readers such as iOS’s VoiceOver or Android’s TalkBack**
- **The app shall secure the user data, including reviews and personal information.**
- **The app shall be reliable, with 99.9% uptime during peak enrollment periods.** 
- **The system shall support 50k active user authentication per month**  
- **The system shall be able to store at most 1GB of user data a month.** 
- **The system shall be able to support 20k document writes, 50k document reads, and 20k document deletes per day.** 
- **The app shall offer an interface for students while having minimal learning curves and being user-friendly.** 
- **The app shall use a responsive design to adapt different screen sizes and resolutions.** 
- The app shall run searches and comparisons within 2 seconds under normal load conditions.
- The app shall be regularly audited to ensure security compliance and data protection.
- The app shall have minimal downtime during updates or maintenance windows.


## Model Class Diagram
```mermaid
classDiagram
    class Course {
        +string courseId
        +string courseName
        +string courseNumber
        +string courseDescription
        +string externalUrl
        +double externalRating
        +toMap() Map
        +toFirestore() 
        +fromFirestore() Course
        +fromDocument() Course
    }

    class Instructor {
        +string instructorId
        +string firstName
        +string lastName
        +string externalUrl
        +double externalRating
        +double averageCourseRating
        +double averageDifficultyRating
        +List~IndividualCourseReviews~ courseReviewsForInstructor
        +toMap() Map
        +toFirestore() 
        +fromFirestore() Instructor
        +fromDocument() Instructor
        +fromJson() Instructor
    }

    class CourseReview {
        +string courseReviewId
        +string courseId
        +string instructorId
        +Course course
        +Instructor instructor
        +double averageOverallRating
        +double averageDifficultyRating
        +List~string~ tags
        +Map workloadFrequency
        +Map gradeFrequency
        +List~IndividualCourseReview~ individualCourseReviews
        +List~Map~ workloadFrequencyData
        +List~Map~ gradeFrequencyData
        +toFirestore() Map
        +fromFirestore() CourseReview
    }

    class IndividualCourseReview {
        +string individualCourseReviewId
        +string reviewerUsername
        +string courseId
        +Course course
        +string instructorId
        +Instructor instructor
        +string semester
        +string year
        +string estimatedWorkload
        +string grade
        +double difficultyRating
        +double overallRating
        +string reviewDetail
        +List~string~ tags
        +toFirestore() Map
        +fromFirestore() IndividualCourseReview
        +fromDocument() IndividualCourseReview
    }

    class MarketPageItemFirebase {
        +string id
        +string listerId
        +string listerName
        +string imageLink
        +string itemName
        +string itemCondition
        +List~Tag~ tags
        +List~String~ fileUrls
        +string itemDescription
        +toMap() Map
        +fromDocument() MarketPageItemFirebase
    }

    class MarketPageItem {
        +string id
        +string listerId
        +string imageLink
        +string itemName
        +string itemCondition
        +string itemDescription
        +List~Tag~ tags
        +List~string~ fileUrls
        +string listerName
    }

    class DiscussionEntryFirebase {
        +string entryId
        +string userId
        +string username
        +int likes
        +int dislikes
        +string discussionTitle
        +List~string~ replyIds
        +List~DiscussionReplyFirebase~ replies
        +List~string~ tags
        +string discussionBody
        +string datePosted
        +toFirestore() Map
        +fromFirestore() DiscussionEntryFirebase
        +fromDocument() DiscussionEntryFirebase
    }

    class DiscussionReplyFirebase {
        +string replyId
        +string replierId
        +string replierName
        +string replyBody
        +List~string~ replyIds
        +List~DiscussionReplyFirebase~ replies
        +int likes
        +int dislikes
        +string datePosted
        +toFirestore() Map
        +toMap() Map
        +fromFirestore() DiscussionReplyFirebase
        +fromDocument() DiscussionReplyFirebase
    }

    class Bookmark {
        +string courseId
        +string userId
        +toMap() Map
        +fromDocument() Bookmark
        +fromJson() Bookmark
    }

    class Tag {
        +string id
        +string tagDescription
        +toMap() Map
        +fromMap() Tag
    }

    class RootModel {
        <<Abstract>>
        +getLabel()*
        +getKey()*
    }

    RootModel <|-- Course
    RootModel <|-- Instructor

    Instructor o-- IndividualCourseReview

    CourseReview o-- Course
    CourseReview o-- Instructor
    CourseReview o-- IndividualCourseReview

    MarketPageItemFirebase o-- Tag

    MarketPageItem o-- Tag

    DiscussionEntryFirebase o-- DiscussionReplyFirebase

```

```mermaid
gantt
    dateFormat  YYYY-MM-DD
    title Young Justice Project Timeline (estimated)
    Done with all UI Pages: done, milestone, 2024-11-13, m1
    Finish Incorporating Data with UI: done, milestone, 2024-11-25, m2
    Complete App: done, milestone, 2024-11-30, m3
    section Pages
        Landing Page : done, 2024-10-28, 1d
        Homepage : done, 2024-10-29, 1d 
        Writing Review Page: done, 2024-10-30, 1d
        Course Review Detail Page : done, 2024-10-31, 2d
        Review Digest Page: done, 2024-10-31, 2d
        Market Place Page: done, 2024-11-02, 2d
        Market Place Individual Listing Page: done, 2024-11-02, 2d
        Market Place Create Listing Page: done, 2024-11-02, 2d
        Discussion Forum Page: done, 2024-11-04, 2d
        Discussion Forum Entry Page: done, 2024-11-04, 2d
        My Accounts Page: done, 2024-11-06, 3d
        My Reviews Page: done, 2024-11-06, 3d
        My Bookmarks Page: done, 2024-11-06, 3d
    section Data
        Figure out JSON Structure for all Data: done, 2024-11-04, 7d
    section Functionality
        User Authentication: done, 2024-10-28, 1d
        Bottom Navigation Widget: done, 2024-11-09, 1d
        Search Bar Widget: done, 2024-11-10, 1d
        Incorporate Firestore with UI: done, 2024-11-11, 14d

    section Cosmetics
        Finalize Color Scheme: done, 2024-11-27, 1d
```